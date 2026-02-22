using System;
using System.IO;
using System.Diagnostics;
using System.Linq;

class Update
{
    static void Main(string[] args)
    {
        Console.ForegroundColor = ConsoleColor.Cyan;
        Console.WriteLine("Personal Knowledge Base - One-Click Updater");
        Console.ResetColor();

        try
        {
            string rootDir = AppDomain.CurrentDomain.BaseDirectory;
            if (Path.GetFileName(rootDir.TrimEnd(Path.DirectorySeparatorChar)).ToLower() == "installer")
            {
                rootDir = Path.GetDirectoryName(rootDir.TrimEnd(Path.DirectorySeparatorChar));
            }

            string repoUrl = DetectRepoUrl(rootDir);
            if (string.IsNullOrEmpty(repoUrl))
            {
                Console.WriteLine("\n[!] Could not detect GitHub Repository URL.");
                Console.Write("Please enter your GitHub Repo URL (e.g. https://github.com/user/personalKb): ");
                repoUrl = Console.ReadLine().Trim();
                if (string.IsNullOrEmpty(repoUrl)) throw new Exception("Repository URL is required for updates.");
                SaveRepoUrl(rootDir, repoUrl);
            }

            Console.WriteLine(string.Format("\nSyncing from: {0}", repoUrl));

            // 1. Try Git Pull if .git exists
            if (Directory.Exists(Path.Combine(rootDir, ".git")))
            {
                Console.WriteLine("Executing 'git pull'...");
                RunCommand("git", "pull", rootDir);
            }
            else
            {
                Console.WriteLine("No .git folder found. Downloading master ZIP from GitHub...");
                DownloadAndExtractZip(repoUrl, rootDir);
            }

            Console.ForegroundColor = ConsoleColor.Green;
            Console.WriteLine("\nUpdate Successful!");
            Console.ResetColor();
        }
        catch (Exception ex)
        {
            Console.ForegroundColor = ConsoleColor.Red;
            Console.WriteLine("\nUpdate Failed:");
            Console.WriteLine(ex.Message);
            Console.ResetColor();
        }

        Console.WriteLine("\nPress any key to exit...");
        Console.ReadKey();
    }

    static string DetectRepoUrl(string rootDir)
    {
        // 1. Check for repo.url config
        string configPath = Path.Combine(rootDir, ".context", "repo.url");
        if (File.Exists(configPath)) return File.ReadAllText(configPath).Trim();

        // 2. Try git remote get-url origin (if git is installed)
        try
        {
            if (Directory.Exists(Path.Combine(rootDir, ".git")))
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
                if (p.ExitCode == 0 && !string.IsNullOrEmpty(output))
                {
                    SaveRepoUrl(rootDir, output);
                    return output;
                }
            }
        } catch {}

        return null;
    }

    static void SaveRepoUrl(string rootDir, string url)
    {
        string contextDir = Path.Combine(rootDir, ".context");
        if (!Directory.Exists(contextDir)) Directory.CreateDirectory(contextDir);
        File.WriteAllText(Path.Combine(contextDir, "repo.url"), url);
    }

    static void RunCommand(string cmd, string args, string workingDir)
    {
        Process p = new Process();
        p.StartInfo.FileName = cmd;
        p.StartInfo.Arguments = args;
        p.StartInfo.WorkingDirectory = workingDir;
        p.StartInfo.UseShellExecute = false;
        p.StartInfo.RedirectStandardError = true;
        p.StartInfo.RedirectStandardOutput = true;
        p.Start();

        string output = p.StandardOutput.ReadToEnd();
        string error = p.StandardError.ReadToEnd();
        p.WaitForExit();

        if (p.ExitCode != 0)
        {
            if (cmd == "git" && args == "pull")
            {
                if (error.Contains("local changes"))
                {
                    throw new Exception("Git Conflict: You have local uncommitted changes that would be overwritten by a pull.\n" +
                                        "Please COMMIT your changes or run 'git stash' before updating.");
                }
                if (error.Contains("unmerged files") || error.Contains("unresolved conflict"))
                {
                    throw new Exception("Git Conflict: You have unresolved merge conflicts from a previous attempt.\n" +
                                        "Please run 'git merge --abort' to reset your project state and try again.");
                }
            }
            throw new Exception(string.Format("Command '{0} {1}' failed.\nError: {2}", cmd, args, error));
        }
    }

    static void DownloadAndExtractZip(string repoUrl, string rootDir)
    {
        // Construct ZIP URL: https://github.com/user/repo/archive/refs/heads/master.zip
        string zipUrl = repoUrl.TrimEnd('/') + "/archive/refs/heads/master.zip";
        string tempZip = Path.Combine(Path.GetTempPath(), "pkb_update.zip");
        string tempDir = Path.Combine(Path.GetTempPath(), "pkb_update_extract");

        if (Directory.Exists(tempDir)) Directory.Delete(tempDir, true);
        Directory.CreateDirectory(tempDir);

        Console.WriteLine("Fetching latest content...");
        // Using powershell for download to keep C# 5 compatibility easy
        string psDownload = string.Format("Invoke-WebRequest -Uri \"{0}\" -OutFile \"{1}\"", zipUrl, tempZip);
        RunCommand("powershell", "-Command " + psDownload, rootDir);

        Console.WriteLine("Extracting...");
        string psExtract = string.Format("Expand-Archive -Path \"{0}\" -DestinationPath \"{1}\" -Force", tempZip, tempDir);
        RunCommand("powershell", "-Command " + psExtract, rootDir);

        // ZIP extraction usually creates a folder like 'personalKb-master' inside tempDir
        string extractedFolder = Directory.GetDirectories(tempDir).FirstOrDefault();
        if (extractedFolder != null)
        {
            RefreshFiles(extractedFolder, rootDir);
        }
    }

    static void RefreshFiles(string src, string dest)
    {
        // Items to refresh (overwrite)
        string[] toRefresh = { "scripts", "standards", ".agents", "Setup.exe" };
        
        foreach (string item in toRefresh)
        {
            string srcPath = Path.Combine(src, item);
            string destPath = Path.Combine(dest, item);

            if (Directory.Exists(srcPath))
            {
                Console.WriteLine(string.Format("Refreshing {0}...", item));
                if (Directory.Exists(destPath)) Directory.Delete(destPath, true);
                CopyDirectory(srcPath, destPath);
            }
            else if (File.Exists(srcPath))
            {
                File.Copy(srcPath, destPath, true);
            }
        }
    }

    static void CopyDirectory(string src, string dest)
    {
        Directory.CreateDirectory(dest);
        foreach (string file in Directory.GetFiles(src))
        {
            File.Copy(file, Path.Combine(dest, Path.GetFileName(file)), true);
        }
        foreach (string dir in Directory.GetDirectories(src))
        {
            CopyDirectory(dir, Path.Combine(dest, Path.GetFileName(dir)));
        }
    }
}
