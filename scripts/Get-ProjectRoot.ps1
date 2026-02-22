function Get-ProjectRoot {
    <#
    .SYNOPSIS
        Finds the root directory for Knowledge Base operations with strict isolation.
        Priority:
        1. Current or parent directory containing a '.context' folder.
        2. The global repository root (only if currently inside it).
        
        If neither is found, throws an error to prevent accidental writes to unrelated projects.
    #>
    param()

    $currentDir = Get-Location
    $globalRoot = "C:\Users\allen\repos\personalKb"

    # 1. Search upwards for .context
    $testDir = $currentDir.Path
    while ($null -ne $testDir -and $testDir -ne "") {
        $contextPath = Join-Path $testDir ".context"
        if (Test-Path $contextPath) {
            return $contextPath
        }
        $testDir = Split-Path $testDir -Parent
    }

    # 2. Check if inside the global repo
    if ($currentDir.Path -like "$globalRoot*") {
        return $globalRoot
    }

    # 3. Strict Isolation Error
    Write-Error "STRICT ISOLATION ERROR: No active Knowledge Base context found."
    Write-Error "Knowledge base operations are only permitted inside a project with a '.context/' directory or within the global repository at '$globalRoot'."
    Write-Error "To initialize a project, run: init-context"
    exit 1
}
