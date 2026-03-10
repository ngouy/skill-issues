## Experiment 10 — Mechanism B: always-on hook, natural language, control skill (no steps)

### What was done
Same always-on UserPromptSubmit hook as Experiment 09. Fresh session. User invoked control skill via natural language: "Please run the test overlay control skill for me."

`test-overlay-control` contains a single action (`date`) with no sequential steps.

### What was observed
No TaskCreate entries appeared. Skill loaded and executed cleanly:
```
Skill(test-overlay-control) → Successfully loaded skill
Bash(date) → Tue 10 Mar 2026 09:46:25 EDT
```

Token count: ~18k total / 3.5k messages.

### Interpretation
The conditional instruction correctly suppresses task creation when a no-step skill is invoked. Claude loaded the skill, detected no sequential steps, and ignored the task-creation instruction. Zero false positives. Token overhead negligible (~3.5k messages vs ~3.3k for a plain "What time is it?" — essentially identical).
