---
description: how to transfer local AI brain memory to the repository for long-term storage
---
1.  **Reflect and Summarize**: Run the `/retrospective` command or manually run `Invoke-Retrospective.ps1 -Save` to capture the current session's context.
2.  **Export Local Knowledge**:
// turbo
3.  Run the transfer script: `powershell -File scripts/Transfer-Memory.ps1`
4.  **Review and Commit**:
    - Check the `knowledge/ki/` and `knowledge/retrospectives/` directories for new files.
    - Stage the files: `git add knowledge/`
    - Commit with a descriptive message like `docs(memory): sync local knowledge to repository`.
5.  **Verify**: Confirm that the new memories are searchable via `scripts/Search-Memory.ps1`.
