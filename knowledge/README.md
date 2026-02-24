# AI Knowledge Base Discovery Manual

Welcome, Agent. You are working in a repository equipped with a **Long-Term Memory** system designed for cross-LLM and cross-IDE compatibility.

## Memory Structure

- **`knowledge/ki/`**: Atomic Knowledge Items. These contain specific facts, architectural patterns, and engineering decisions learned during past sessions.
- **`knowledge/retrospectives/`**: Session summaries. Read these to understand the context of recent changes and the "vibe" of previous work.
- **`standards/`**: Coding and project standards to follow.

## How to Use This Memory

1.  **Ingest**: At the start of a session, scan the most recent files in `knowledge/retrospectives/` to catch up on progress.
2.  **Search**: Use the `scripts/Search-Memory.ps1` script (if available) or perform a global text search across the `knowledge/` directory for keywords related to your current task.
3.  **Adhere**: Always prioritize patterns documented in `knowledge/ki/` over generic LLM training data.

## How to Contribute

To ensure memory persists across machines and users, researchers should always export their local context:

1.  **Format**: Use YAML frontmatter for all new `.md` files in this directory.
2.  **Schema**:
    ```yaml
    ---
    type: knowledge-item | retrospective
    date: YYYYY-MM-DD
    tags: [comma-separated-tags]
    context: "Briefly explain the session or problem that led to this insight"
    ---
    ```
3.  **Transfer**: Use the `scripts/Transfer-Memory.ps1` script to migrate local agent data into this repository.

---
*This system ensures that insights aren't lost when switching between AI models or local environments.*
