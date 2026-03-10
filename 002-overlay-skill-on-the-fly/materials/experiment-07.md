## Experiment 07 — Mechanism B: UserPromptSubmit hook with slash-command detection

### What was done
Moved hook from `PreToolUse`/`Skill` to `UserPromptSubmit`. Hook script reads prompt from stdin JSON, checks if it starts with `/`, and outputs the task injection instruction only for slash commands.

`task-overlay` still disabled. Fresh session. User ran `/test-overlay-target` (3-step skill, no embedded Checklist).

### What was observed
TaskCreate entries appeared in the sidebar before execution began:
- List files in /tmp
- Create /tmp/overlay-test.txt
- Confirm file contents

Tasks were marked complete as each step finished. Hook fired deterministically.

Token count: ~28k total / 11.7k messages / 1.6k skills.

### Interpretation
`UserPromptSubmit` with slash-command detection works for user-invoked skills. The hook fires before the skill content loads, injecting the instruction into Claude's context. Claude then reads the skill content and creates tasks accordingly. This is deterministic — no reliance on the using-superpowers meta-check. Delta vs. baseline (Mechanism A no-task run ~11k messages): ~+0.7k messages for task creation overhead.
