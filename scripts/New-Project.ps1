param (
    [Parameter(Mandatory = $true)]
    [string]$Name,
    
    [string]$Path = ".",
    
    [switch]$NoGit,
    
    [switch]$SkipRules
)

$scriptFilePath = $MyInvocation.MyCommand.Path
$scriptDir = Split-Path $scriptFilePath
. (Join-Path $scriptDir "Get-ProjectRoot.ps1")

$targetPath = Join-Path (Resolve-Path $Path) $Name

Write-Host "Scaffolding new project: $Name" -ForegroundColor Cyan
Write-Host "Target location: $targetPath" -ForegroundColor Gray

if (Test-Path $targetPath) {
    Write-Error "Target directory already exists: $targetPath"
    return
}

# 1. Create directory
New-Item -ItemType Directory -Path $targetPath -Force | Out-Null

# 2. Initialize Git
if (-not $NoGit) {
    Write-Host "Initializing Git repository..." -ForegroundColor Gray
    git init $targetPath | Out-Null
}

# 3. Install AI Context
Write-Host "Initializing AI Context..." -ForegroundColor Gray
$installContextScript = Join-Path $scriptDir "Install-Context.ps1"
$params = @{
    DestPath = $targetPath
}
if ($SkipRules) { $params.SkipRules = $true }

& $installContextScript @params

# 4. Create baseline README
$readmePath = Join-Path $targetPath "README.md"
$readmeContent = @"
# $Name

This project was bootstrapped using the AI Meta-Repo.

## Getting Started

1. Open this folder in your favorite AI-assisted IDE (Cursor, Windsurf, etc.).
2. The AI will automatically detect the context in `.context/`.

## Structure

- `.context/`: Project-specific AI brain, standards, and research.
"@

$readmeContent | Out-File -FilePath $readmePath -Encoding utf8

Write-Host "`nProject '$Name' created successfully!" -ForegroundColor Green
Write-Host "Next Step: cd $Name" -ForegroundColor Cyan
