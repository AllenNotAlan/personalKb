param (
    [int]$CommitCount = 5,
    [int]$RecentHours = 24,
    [switch]$Save
)

$scriptFilePath = $MyInvocation.MyCommand.Path
$scriptDir = Split-Path $scriptFilePath
. (Join-Path $scriptDir "Get-ProjectRoot.ps1")
$rootPath = Get-ProjectRoot

$date = Get-Date -Format "yyyy-MM-dd"
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

$contextOutput = New-Object System.Collections.Generic.List[string]
$contextOutput.Add("---")
$contextOutput.Add("type: retrospective")
$contextOutput.Add("date: $date")
$contextOutput.Add("commit_count: $CommitCount")
$contextOutput.Add("---")
$contextOutput.Add("# Project Retrospective: $timestamp")
$contextOutput.Add("")
$contextOutput.Add("## Recent Context")

# 1. Recent Git History
$contextOutput.Add("### Recent Git Commits")
if (Test-Path (Join-Path $rootPath ".git")) {
    $commits = git -C $rootPath log -n $CommitCount --pretty=format:"* %h - %s (%cr)"
    foreach ($c in $commits) { $contextOutput.Add($c) }
}
else {
    $contextOutput.Add("No git repository detected.")
}

# 2. Recently Modified Files
$contextOutput.Add("`n### Recently Modified Files (Last $RecentHours hours)")
$sinceDate = (Get-Date).AddHours(-$RecentHours)
$files = Get-ChildItem -Path $rootPath -Recurse | 
Where-Object { 
    $_.LastWriteTime -gt $sinceDate -and 
    $_.PSIsContainer -eq $false -and
    $_.FullName -notlike "*\.git\*" -and
    $_.FullName -notlike "*\node_modules\*" -and
    $_.FullName -notlike "*\.gemini\*"
} | 
Select-Object -First 20

foreach ($f in $files) {
    $contextOutput.Add("* $($f.LastWriteTime.ToString('HH:mm')) - $($f.FullName.Replace($rootPath, ''))")
}

$finalMarkdown = $contextOutput -join "`n"

if ($Save) {
    $title = "Retrospective-$((Get-Date).ToString('yyyyMMdd-HHmm'))"
    $targetDir = Join-Path $rootPath "knowledge\retrospectives"
    if (-not (Test-Path $targetDir)) { New-Item -ItemType Directory -Path $targetDir -Force | Out-Null }
    $targetPath = Join-Path $targetDir "$title.md"
    $finalMarkdown | Out-File -FilePath $targetPath -Encoding utf8
    Write-Host "Retrospective saved to: $targetPath" -ForegroundColor Green
}
else {
    Write-Output $finalMarkdown
}
