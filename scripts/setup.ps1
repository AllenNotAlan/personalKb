# setup.ps1 - Global Environment Integration

$scriptDir = "C:\Users\allen\repos\personalKb\scripts"

Write-Host "Setting up Personal Knowledge Base globally..." -ForegroundColor Cyan

# 1. Add to User PATH
Write-Host "Adding scripts directory to User PATH..." -ForegroundColor Gray
$currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($currentPath -notlike "*$scriptDir*") {
    $newPath = "$currentPath;$scriptDir"
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    $env:Path = "$env:Path;$scriptDir"
    Write-Host "Added to PATH." -ForegroundColor Green
}
else {
    Write-Host "Already in PATH." -ForegroundColor Yellow
}

# 2. Add Aliases to PowerShell Profile
Write-Host "Adding aliases to PowerShell Profile..." -ForegroundColor Gray
$profileDir = Split-Path $PROFILE
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}
if (-not (Test-Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force | Out-Null
}

$aliases = @"

# --- Personal Knowledge Base Aliases ---
function mem-add { & "$scriptDir\Add-Memory.ps1" @args }
function mem-search { & "$scriptDir\Search-Memory.ps1" @args }
function analyze-stack { & "$scriptDir\Sync-TechStack.ps1" @args }
function standards-search { & "$scriptDir\Find-Pattern.ps1" @args }
function standards-web { & "$scriptDir\Search-WebBestPractices.ps1" @args }
function init-context { & "$scriptDir\Install-Context.ps1" @args }
# --- End PKB Aliases ---
"@

$currentProfile = Get-Content $PROFILE -Raw
if ($currentProfile -notlike "*# --- Personal Knowledge Base Aliases ---*") {
    Add-Content -Path $PROFILE -Value $aliases
    Write-Host "Aliases added to your PowerShell Profile ($PROFILE)." -ForegroundColor Green
    Write-Host "Please restart your terminal or run: . `$PROFILE" -ForegroundColor Yellow
}
else {
    Write-Host "Aliases already present in Profile." -ForegroundColor Yellow
}

Write-Host "`nSetup Complete! You can now use commands like 'mem-add' or 'analyze-stack' from anywhere." -ForegroundColor Green
