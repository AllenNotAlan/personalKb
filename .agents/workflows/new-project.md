---
description: Start a new project from scratch with AI context pre-initialized
---
1.  **Define Project Scope**: Ask the user for the project name and its primary goal.
2.  **Scaffold Project**:
// turbo
3.  Run the scaffolding command: `powershell -File scripts/New-Project.ps1 -Name <ProjectName>`
4.  **Initial Research**:
    - Research the best tech stack for the project goal.
    - Create a baseline `.context/knowledge/project_architecture.md`.
    - Document initial implementation thoughts in `.context/knowledge/research/`.
5.  **Bootstrap Coding**:
    - Start creating the initial file structure (e.g., `src/`, `tests/`, `index.html`).
    - After the first meaningful code additions, run `/retrospective` to capture the "Day 0" context.
