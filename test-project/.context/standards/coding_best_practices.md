# General Coding Best Practices

This document outlines the core coding standards to be followed across all projects.

## Core Principles

1.  **Readability Over Cleverness**: Code should be easy to read and understand. Favor explicit logic over implicit "magic".
2.  **DRY (Don't Repeat Yourself)**: Extract common logic into reusable functions or components, but avoid over-engineering.
3.  **Single Responsibility Principle**: Each function, class, or module should have one clear purpose.
4.  **Meaningful Naming**: Use descriptive names for variables, functions, and files. Avoid cryptic abbreviations.
5.  **Small, Frequent Commits**: Commit logically related changes frequently with clear, descriptive messages.

## Language Specifics

*For specific language best practices, see the dedicated files:*
- [Python Standards](coding/python.md)
- [JavaScript/TypeScript Standards](coding/javascript.md)
- [Go Standards](coding/go.md)

## Error Handling

- **Fail Loudly**: Errors should be handled explicitly and logged with meaningful context.
- **Graceful Degradation**: If an optional feature fails, the core application should continue to function.

## Documentation

- **Inline Comments**: Use comments to explain the "why" of complex logic, not the "what" of obvious code.
- **Docstrings**: Maintain up-to-date docstrings for all public APIs and complex functions.
