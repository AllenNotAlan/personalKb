param (
    [Parameter(Mandatory = $true)]
    [string]$Title,
    
    [Parameter(Mandatory = $true)]
    [string]$Content,
    
    [string]$Category = "memory"
)

$date = Get-Date -Format "yyyy-MM-dd"
$safeTitle = $Title -replace '[^a-zA-Z0-9]', '-' -replace '-+', '-'
$fileName = "$date-$safeTitle.md"

$scriptFilePath = $MyInvocation.MyCommand.Path
$scriptDir = Split-Path $scriptFilePath
. (Join-Path $scriptDir "Get-ProjectRoot.ps1")
$rootPath = Get-ProjectRoot

$targetDir = Join-Path $rootPath "knowledge"
$targetDir = Join-Path $targetDir $Category
if (-not (Test-Path $targetDir)) {
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
}

$targetPath = Join-Path $targetDir $fileName

$markdownContent = @"
# $Title

- **Date**: $date
- **Category**: $Category

## Content

$Content
"@

$markdownContent | Out-File -FilePath $targetPath -Encoding utf8
Write-Host "Memory added successfully to $targetPath" -ForegroundColor Green
