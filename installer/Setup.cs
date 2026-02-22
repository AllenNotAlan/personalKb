using System;
using System.IO;
using System.Linq;

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

            string scriptsDir = Path.Combine(rootDir, "scripts");
            if (!Directory.Exists(scriptsDir))
            {
                throw new DirectoryNotFoundException(string.Format("Could not find scripts directory at: {0}", scriptsDir));
            }

            Console.WriteLine(string.Format("Project Root: {0}", rootDir));

            // 1. Update PATH
            Console.Write("Updating User PATH... ");
            string path = Environment.GetEnvironmentVariable("Path", EnvironmentVariableTarget.User);
            if (!path.Split(';').Contains(scriptsDir))
            {
                string newPath = path + (path.EndsWith(";") ? "" : ";") + scriptsDir;
                Environment.SetEnvironmentVariable("Path", newPath, EnvironmentVariableTarget.User);
                Console.ForegroundColor = ConsoleColor.Green;
                Console.WriteLine("Done.");
            }
            else
            {
                Console.ForegroundColor = ConsoleColor.Yellow;
                Console.WriteLine("Already present.");
            }
            Console.ResetColor();

            // 2. Add PS Aliases
            Console.Write("Updating PowerShell Profile... ");
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
                Console.WriteLine("Done.");
            }
            else
            {
                Console.ForegroundColor = ConsoleColor.Yellow;
                Console.WriteLine("Already present.");
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
}
