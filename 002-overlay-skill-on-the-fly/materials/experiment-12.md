## Experiment 12 — Mechanism B: always-on hook, slash command, control skill (no steps)

### What was done
Same always-on UserPromptSubmit hook. Fresh session. User invoked control skill via slash command: `/test-overlay-control`.

### What was observed
No TaskCreate entries appeared. Skill executed cleanly (single `date` action).

### Interpretation
Conditional instruction correctly suppresses task creation for slash command invocations of no-step skills. Full parity confirmed: always-on UserPromptSubmit hook behaves correctly across all four combinations (slash/natural × multi-step/no-step).
