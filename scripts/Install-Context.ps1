param (
    [string]$DestPath = ".",
    [switch]$SkipRules
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

# Generate IDE-specific rule files for automated AI bootstrapping
if (-not $SkipRules) {
    $ruleContent = @"
# AI Project Rules
Always refer to the Knowledge Base in `.context/knowledge/` and the AI Discovery Manual in `.context/knowledge/README.md` before performing tasks.
Prioritize project-specific patterns documented in `.context/knowledge/ki/`.
Follow the session context stored in `.context/knowledge/retrospectives/`.
"@

    $ruleFiles = @(".cursorrules", ".clinerules", ".windsurfrules")
    foreach ($file in $ruleFiles) {
        $rulePath = Join-Path $DestPath $file
        if (-not (Test-Path $rulePath)) {
            $ruleContent | Out-File -FilePath $rulePath -Encoding utf8
            Write-Host "Generated: $file" -ForegroundColor Gray
        }
    }
}

Write-Host "Context installed successfully!" -ForegroundColor Green
Write-Host "AI assisted IDEs (Cursor/Windsurf) will now auto-load project context." -ForegroundColor Cyan
Write-Host "To initialize, run: .\.context\scripts\init.ps1 (if available)" -ForegroundColor Gray
