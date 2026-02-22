param (
    [string]$ProjectPath = "."
)

$fullPath = Resolve-Path $ProjectPath
$scriptDir = Split-Path $MyInvocation.MyCommand.Path
. (Join-Path $scriptDir "Get-ProjectRoot.ps1")
$rootPath = Get-ProjectRoot

$archDoc = Join-Path $rootPath "knowledge"
$archDoc = Join-Path $archDoc "project_architecture.md"

Write-Host "Analyzing Tech Stack in: $fullPath" -ForegroundColor Cyan

$stack = @()

# Detect Python/Django
if (Test-Path (Join-Path $fullPath "manage.py")) { $stack += "Django" }
if (Test-Path (Join-Path $fullPath "requirements.txt")) { $stack += "Python (pip)" }
if (Test-Path (Join-Path $fullPath "pyproject.toml")) { $stack += "Python (Poetry/Flit)" }

# Detect Node.js
if (Test-Path (Join-Path $fullPath "package.json")) { $stack += "Node.js" }
if (Test-Path (Join-Path $fullPath "yarn.lock")) { $stack += "Yarn" }

# Detect Go
if (Test-Path (Join-Path $fullPath "go.mod")) { $stack += "Go" }

# Detect Heroku
if (Test-Path (Join-Path $fullPath "Procfile")) { $stack += "Heroku" }

$detectedStack = $stack -join ", "
Write-Host "Detected Stack: $detectedStack" -ForegroundColor Green

$archContent = @"
# Project Architecture: $(Split-Path $fullPath -Leaf)

- **Date**: $(Get-Date -Format "yyyy-MM-dd")
- **Tech Stack**: $detectedStack

## Components

Auto-detected during stack sync.

## Documentation References

Pending AI analysis of file structure.
"@

$archContent | Out-File -FilePath $archDoc -Encoding utf8
Write-Host "Architecture document updated: $archDoc" -ForegroundColor Green
