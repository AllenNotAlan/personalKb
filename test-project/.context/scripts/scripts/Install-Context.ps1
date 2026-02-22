param (
    [string]$DestPath = "."
)

$scriptFilePath = $MyInvocation.MyCommand.Path
$scriptDir = Split-Path $scriptFilePath
$sourceDir = Split-Path $scriptDir -Parent

$destContextDir = Join-Path $DestPath ".context"

Write-Host "Installing Knowledge Base context into: $destContextDir" -ForegroundColor Cyan

if (-not (Test-Path $destContextDir)) {
    New-Item -ItemType Directory -Path $destContextDir -Force | Out-Null
}

# Copy structure but exclude the .git and other internal files
$itemsToCopy = @("knowledge", "standards", ".agents", "scripts")

foreach ($item in $itemsToCopy) {
    $src = Join-Path $sourceDir $item
    $dest = Join-Path $destContextDir $item
    if (Test-Path $src) {
        Copy-Item -Path $src -Destination $dest -Recurse -Force
    }
}

Write-Host "Context installed successfully!" -ForegroundColor Green
Write-Host "To initialize, run: .\.context\scripts\init.ps1 (if available)" -ForegroundColor Gray
