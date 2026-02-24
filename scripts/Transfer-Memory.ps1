param (
    [string]$SourcePath = "$HOME\.gemini\antigravity\knowledge",
    [switch]$DryRun
)

$scriptDir = Split-Path $MyInvocation.MyCommand.Path
. (Join-Path $scriptDir "Get-ProjectRoot.ps1")
$rootPath = Get-ProjectRoot

$targetKiDir = Join-Path $rootPath "knowledge\ki"

if (-not (Test-Path $SourcePath)) {
    Write-Error "Source knowledge path not found: $SourcePath"
    return
}

Write-Host "Scanning for local knowledge items in: $SourcePath" -ForegroundColor Cyan

# Find all metadata.json files in the KI directories
$kiMetadataFiles = Get-ChildItem -Path $SourcePath -Filter "metadata.json" -Recurse

foreach ($metaFile in $kiMetadataFiles) {
    $kiDir = $metaFile.DirectoryName
    $meta = Get-Content -Raw $metaFile.FullName | ConvertFrom-Json
    
    # Locate the primary artifact (usually the first one, or most recent)
    $artifactsDir = Join-Path $kiDir "artifacts"
    if (-not (Test-Path $artifactsDir)) { continue }
    
    $artifacts = Get-ChildItem -Path $artifactsDir -Filter "*.md"
    foreach ($artifact in $artifacts) {
        $destFileName = "$($artifact.BaseName).md"
        $destPath = Join-Path $targetKiDir $destFileName
        
        Write-Host "Processing: $($artifact.Name) -> $destFileName" -ForegroundColor Gray
        
        $content = Get-Content -Raw $artifact.FullName
        
        # Build YAML Frontmatter
        $yaml = @"
---
type: knowledge-item
date: $((Get-Date).ToString("yyyy-MM-dd"))
tags: [$($meta.tags -join ", ")]
origin_source: "$($meta.source)"
---
"@
        
        $finalContent = "$yaml`n$content"
        
        if ($DryRun) {
            Write-Host "[DRY RUN] Would write to $destPath" -ForegroundColor Yellow
        }
        else {
            $finalContent | Out-File -FilePath $destPath -Encoding utf8
            Write-Host "Exported: $destPath" -ForegroundColor Green
        }
    }
}

Write-Host "`nTransfer complete!" -ForegroundColor Cyan
