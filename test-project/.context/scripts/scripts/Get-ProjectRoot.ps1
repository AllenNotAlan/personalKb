function Get-ProjectRoot {
    <#
    .SYNOPSIS
        Finds the root directory for Knowledge Base operations.
        Priority:
        1. Current or parent directory containing a '.context' folder.
        2. The global repository root (C:\Users\allen\repos\personalKb).
    #>
    param()

    $currentDir = Get-Location
    $globalRoot = "C:\Users\allen\repos\personalKb"

    # 1. Search upwards for .context
    Write-Debug "Current location: $currentDir"
    $testDir = $currentDir.Path
    while ($null -ne $testDir -and $testDir -ne "") {
        $contextPath = Join-Path $testDir ".context"
        if (Test-Path $contextPath) {
            return $contextPath
        }
        $testDir = Split-Path $testDir -Parent
    }

    # 2. Fallback to global root
    return $globalRoot
}
