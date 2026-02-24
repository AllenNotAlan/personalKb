---
description: Automatically analyze successes/failures and document as memory.
---

1. Execute: `powershell -File "C:\Users\allen\repos\personalKb\scripts\Invoke-Retrospective.ps1"`
2. Analyze the output gathered from the script above.
3. Perform a self-reflection on the current session:
    - **Goal**: What was the user trying to achieve?
    - **Result**: What was actually accomplished?
    - **Successes**: What worked well? (e.g., efficient code, correct pattern detection)
    - **Challenges**: What did not work? Where did you pivot?
    - **Key Learning**: What is the most important takeaway for future AI agents working on this project?
4. Automatically create a new memory entry using the `mem-add` command:
    - **Title**: Descriptive title (e.g., "Retrospective: [Feature Name]")
    - **Content**: Summarize the reflection points above.
    - **Category**: `retrospectives`
5. Inform the user that the retrospective has been documented automatically.
