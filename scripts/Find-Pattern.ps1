param (
    [Parameter(Mandatory = $true)]
    [string]$Query
)

$scriptDir = Split-Path $MyInvocation.MyCommand.Path
. (Join-Path $scriptDir "Get-ProjectRoot.ps1")
$rootPath = Get-ProjectRoot

$standardsDir = Join-Path $rootPath "standards"

Write-Host "Searching Standards for: '$Query'..." -ForegroundColor Cyan

Get-ChildItem -Path $standardsDir -Filter "*.md" -Recurse | Select-String -Pattern $Query | ForEach-Object {
    Write-Host "`nMatch in: $($_.FileName)" -ForegroundColor Yellow
    Write-Host "Line $($_.LineNumber): $($_.Line.Trim())"
}

if (-not (Get-ChildItem -Path $standardsDir -Filter "*.md" -Recurse | Select-String -Pattern $Query)) {
    Write-Host "No local matches found. Try running 'standards-web' for a broader search." -ForegroundColor Red
}
