# CLI Usage Guide

All scripts are located in the `scripts/` directory and are designed for PowerShell on Windows.

## Core Commands

### `Add-Memory.ps1`
Adds a new entry to the knowledge base.
- **Parameters**: `-Title`, `-Content`, `-Category` (optional, default: "memory").
- **Example**:
  ```powershell
  .\scripts\Add-Memory.ps1 -Title "Django Middleware Fix" -Content "Place WhiteNoise above all other middleware for static files."
  ```

### `Sync-TechStack.ps1`
Scans the current project to detect the tech stack and update the architecture documentation.
- **Parameters**: `-ProjectPath` (optional, default: ".").
- **Example**:
  ```powershell
  .\scripts\Sync-TechStack.ps1
  ```

### `Search-Memory.ps1` / `Find-Pattern.ps1`
Searches through `knowledge/` or `standards/` for specific text.
- **Parameters**: `-Query`.
- **Example**:
  ```powershell
  .\scripts\Find-Pattern.ps1 -Query "DRY"
  ```

### `Install-Context.ps1`
Clones the knowledge base structure into a project's `.context/` folder.
- **Example**:
  ```powershell
  .\scripts\Install-Context.ps1 -DestPath "C:\path\to\your\project"
  ```

## AI Integration
These scripts are also used by the AI workflows in `.agents/workflows/`. When working in an IDE, the agent can trigger these automatically to keep your project documentation up to date.
