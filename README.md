# Personal Knowledge Base & AI Meta-Repo

This repository serves as a centralized hub for AI workflows, persistent memory, and coding best practices. It is designed to be easily integrated into other projects to provide consistent context for AI assistants.

## Features

- **🧠 Persistent Memory**: Store successful research and implementation plans in `knowledge/`.
- **🤖 AI Workflows**: Pre-defined workflows for the Antigravity agent in `.agents/workflows/`.
- **📜 Standards**: Language-specific and architectural best practices in `standards/`.
- **💻 CLI Integration**: PowerShell scripts in `scripts/` for quick interaction.
- **🔍 Smart Tracking**: Automatically track project tech stacks and document architecture.
- **📄 [Architecture Guide](docs/architecture.md)**: Detailed explanation of how memory and discovery logic work.

## Getting Started

### Installation (Easy Method)
1. **Copy** the `personalKb` folder to your project root (or keep it central).
2. **Run** [Setup.exe](file:///c:/Users/allen/repos/personalKb/Setup.exe). This will add the tools to your PATH and set up PowerShell aliases.

### Installation (Script Method)
If you prefer scripts, run the following from your project root:
```powershell
powershell -ExecutionPolicy Bypass -File "C:/Users/allen/repos/personalKb/scripts/Install-Context.ps1"
```

### CLI Commands
See [CLI Usage Guide](docs/cli_usage.md) for details on available commands:
- `Add-Memory`: Document a new finding.
- `Sync-TechStack`: Automatically update the project's tech context.
- `Find-Pattern`: Search local best practices.

## Repository Structure
- `knowledge/`: Research files, implementation plans, and persistent AI memory.
- `.agents/`: Agent-specific instructions and automated workflows.
- `standards/`: Coding and architecture standards.
- `scripts/`: PowerShell utilities for automation.
