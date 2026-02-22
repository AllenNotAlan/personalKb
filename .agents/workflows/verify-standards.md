---
description: Verify code against local standards and supplement with web search if needed.
---

1. Receive a coding question or code snippet for review.
2. Search local standards using `Search-Memory.ps1` or `Find-Pattern.ps1`.
3. If local information is found:
    - Apply the local standards to the solution.
4. If local information is missing or outdated:
    - Perform a targeted web search for industry best practices.
    - Summarize the findings.
5. Present the final recommendation to the user.
6. **Optional**: Propose saving the new findings into `standards/` or `knowledge/memory/` using `Add-Memory.ps1` to avoid future web searches.
