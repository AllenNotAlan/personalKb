# Agent Instructions: Knowledge Base Operations

These instructions guide how the AI agent should interact with this repository and its integrated projects.

## Core Directives

1.  **Prioritize Local Context**: Always check the `.context/` or `knowledge/` directory for existing project patterns, research, and memory before suggesting new approaches.
2.  **Maintain Memory**: After successfully solving a complex problem or completing extensive research, proactively suggest creating a new entry in `knowledge/memory/`.
3.  **Mandatory Retrospective**: Before finishing a task (calling `notify_user` or marking a task as complete), the agent **MUST** perform a retrospective. Use the `/retrospective` workflow to analyze the session outcome and document findings.
4.  **Use Workflows**: Utilize the workflows defined in `.agents/workflows/` for consistent task execution (e.g., tracking architecture or verifying standards).
5.  **Stay Context-Aware**: When integrated into a project, use the `project_architecture.md` file to understand the current tech stack and architectural constraints.
6.  **Strict Context Isolation**: Never attempt to read, write, or suggest changes to files outside the project's discovered root. If no `.context/` directory or global repository root is explicitly identified by the system, halt and inform the user.

## Knowledge Management Protocol

- **Research**: Store in `knowledge/research/` as markdown files with descriptive titles.
- **Memory**: Use `knowledge/memory/` for bite-sized "lessons learned".
- **KIs (Knowledge Items)**: For long-standing, curated knowledge, use the KNOWLEDGE SUBAGENT protocol in `knowledge/ki/`.

## Standards Compliance

- Before proposing code changes, cross-reference with `standards/coding/` and `standards/architecture/`.
- If a specific standard is missing, use the `verify-standards` workflow to search the web and then propose adding it to this repo.
