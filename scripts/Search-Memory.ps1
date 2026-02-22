param (
    [Parameter(Mandatory = $true)]
    [string]$Query
)

$scriptDir = Split-Path $MyInvocation.MyCommand.Path
. (Join-Path $scriptDir "Get-ProjectRoot.ps1")
$rootPath = Get-ProjectRoot

$knowledgeDir = Join-Path $rootPath "knowledge"

Write-Host "Searching Knowledge Base for: '$Query'..." -ForegroundColor Cyan

Get-ChildItem -Path $knowledgeDir -Filter "*.md" -Recurse | Select-String -Pattern $Query | ForEach-Object {
    Write-Host "`nMatch in: $($_.FileName)" -ForegroundColor Yellow
    Write-Host "Line $($_.LineNumber): $($_.Line.Trim())"
}

if (-not (Get-ChildItem -Path $knowledgeDir -Filter "*.md" -Recurse | Select-String -Pattern $Query)) {
    Write-Host "No matches found." -ForegroundColor Red
}
