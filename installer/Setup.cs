using System;
using System.IO;
using System.Linq;
using System.Diagnostics;

class Setup
{
    static void Main(string[] args)
    {
        Console.ForegroundColor = ConsoleColor.Cyan;
        Console.WriteLine("Personal Knowledge Base - One-Click Installer");
        Console.ResetColor();

        try
        {
            string rootDir = AppDomain.CurrentDomain.BaseDirectory;
            // Handle if we are inside a subfolder (like 'installer') vs root
            if (Path.GetFileName(rootDir.TrimEnd(Path.DirectorySeparatorChar)).ToLower() == "installer")
            {
                rootDir = Path.GetDirectoryName(rootDir.TrimEnd(Path.DirectorySeparatorChar));
            }

            Console.WriteLine(string.Format("Project Root: {0}", rootDir));

            // 1. Git Metadata & Repo Tracking
            string gitDir = Path.Combine(rootDir, ".git");
            if (Directory.Exists(gitDir))
            {
                Console.WriteLine("\n[!] DETECTED: .git folder in project root.");
                
                // Try to save repo URL before deleting .git
                string repoUrl = GetRepoUrl(rootDir);
                if (!string.IsNullOrEmpty(repoUrl))
                {
                    SaveRepoUrl(rootDir, repoUrl);
                    Console.WriteLine("Saved Repository URL for future updates.");
                }

                Console.WriteLine("If you copied this PKB to a new project, you should delete this .git folder");
                Console.WriteLine("to prevent GIT from treating this as a nested repository.");
                Console.Write("Delete .git folder? (y/n): ");
                string response = Console.ReadLine().ToLower();
                if (response == "y")
                {
                    Console.Write("Deleting .git... ");
                    DeleteDirectory(gitDir);
                    Console.ForegroundColor = ConsoleColor.Green;
                    Console.WriteLine("Done.");
                    Console.ResetColor();
                }
                else
                {
                    Console.WriteLine("Skipped cleanup.");
                }
            }

            string scriptsDir = Path.Combine(rootDir, "scripts");
            if (!Directory.Exists(scriptsDir))
            {
                throw new DirectoryNotFoundException(string.Format("Could not find scripts directory at: {0}", scriptsDir));
            }

            // 2. Update PATH
            Console.WriteLine("\n[2/3] Updating User PATH...");
            string path = Environment.GetEnvironmentVariable("Path", EnvironmentVariableTarget.User);
            if (!path.Split(';').Contains(scriptsDir))
            {
                string newPath = path + (path.EndsWith(";") ? "" : ";") + scriptsDir;
                Environment.SetEnvironmentVariable("Path", newPath, EnvironmentVariableTarget.User);
                Console.ForegroundColor = ConsoleColor.Green;
                Console.WriteLine("   -> Added to PATH.");
            }
            else
            {
                Console.ForegroundColor = ConsoleColor.Yellow;
                Console.WriteLine("   -> PATH already set.");
            }
            Console.ResetColor();

            // 3. Add PS Aliases
            Console.WriteLine("[3/3] Updating PowerShell Profile...");
            string myDocuments = Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments);
            string profilePath = Path.Combine(myDocuments, "WindowsPowerShell", "Microsoft.PowerShell_profile.ps1");
            string profileDir = Path.GetDirectoryName(profilePath);

            if (!Directory.Exists(profileDir)) Directory.CreateDirectory(profileDir);

            string aliasTemplate = @"
# --- Personal Knowledge Base Aliases ---
function mem-add {{ & ""{0}"" @args }}
function mem-search {{ & ""{1}"" @args }}
function analyze-stack {{ & ""{2}"" @args }}
function standards-search {{ & ""{3}"" @args }}
function standards-web {{ & ""{4}"" @args }}
function init-context {{ & ""{5}"" @args }}
# --- End PKB Aliases ---";

            string aliasBlock = string.Format(aliasTemplate,
                Path.Combine(scriptsDir, "Add-Memory.ps1"),
                Path.Combine(scriptsDir, "Search-Memory.ps1"),
                Path.Combine(scriptsDir, "Sync-TechStack.ps1"),
                Path.Combine(scriptsDir, "Find-Pattern.ps1"),
                Path.Combine(scriptsDir, "Search-WebBestPractices.ps1"),
                Path.Combine(scriptsDir, "Install-Context.ps1")
            );

            string currentProfile = File.Exists(profilePath) ? File.ReadAllText(profilePath) : "";
            if (!currentProfile.Contains("# --- Personal Knowledge Base Aliases ---"))
            {
                File.AppendAllText(profilePath, "\n" + aliasBlock);
                Console.ForegroundColor = ConsoleColor.Green;
                Console.WriteLine("   -> Aliases added to profile.");
            }
            else
            {
                Console.ForegroundColor = ConsoleColor.Yellow;
                Console.WriteLine("   -> Aliases already present.");
            }
            Console.ResetColor();

            Console.WriteLine("\nInstallation Complete!");
            Console.WriteLine("Please restart your terminal to use commands like 'mem-add'.");
        }
        catch (Exception ex)
        {
            Console.ForegroundColor = ConsoleColor.Red;
            Console.WriteLine("\nError during installation:");
            Console.WriteLine(ex.Message);
            Console.ResetColor();
        }

        Console.WriteLine("\nPress any key to exit...");
        Console.ReadKey();
    }

    static string GetRepoUrl(string rootDir)
    {
        try
        {
            Process p = new Process();
            p.StartInfo.FileName = "git";
            p.StartInfo.Arguments = "remote get-url origin";
            p.StartInfo.WorkingDirectory = rootDir;
            p.StartInfo.RedirectStandardOutput = true;
            p.StartInfo.UseShellExecute = false;
            p.StartInfo.CreateNoWindow = true;
            p.Start();
            string output = p.StandardOutput.ReadToEnd().Trim();
            p.WaitForExit();
            if (p.ExitCode == 0) return output;
        } catch {}
        return null;
    }

    static void SaveRepoUrl(string rootDir, string url)
    {
        string contextDir = Path.Combine(rootDir, ".context");
        if (!Directory.Exists(contextDir)) Directory.CreateDirectory(contextDir);
        File.WriteAllText(Path.Combine(contextDir, "repo.url"), url);
    }

    // Helper to handle read-only files in .git
    static void DeleteDirectory(string targetDir)
    {
        string[] files = Directory.GetFiles(targetDir);
        string[] dirs = Directory.GetDirectories(targetDir);

        foreach (string file in files)
        {
            File.SetAttributes(file, FileAttributes.Normal);
            File.Delete(file);
        }

        foreach (string dir in dirs)
        {
            DeleteDirectory(dir);
        }

        Directory.Delete(targetDir, false);
    }
}
