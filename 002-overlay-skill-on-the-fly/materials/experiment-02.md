## Experiment 02

### What was done
Invoked `/test-overlay-target` in a fresh Claude Code session. The skill had NO embedded Checklist block. The `task-overlay` skill was present in the skills list with trigger: "Use when any skill needs to complete a list of tasks or steps." No explicit user instruction to invoke task-overlay.

Pre-run context: 14k/200k tokens (7%).

### What was observed
- task-overlay was NOT invoked
- TaskCreate did NOT fire
- Post-run context: 25k/200k tokens (12%) — Messages: 10.5k
- Delta: ~11k tokens consumed (8k cheaper than baseline — no task management overhead)

### Interpretation
Mechanism A (standalone overlay skill with matching trigger) does not work. Claude does not auto-invoke a skill based on trigger description alone when executing another skill. Skills are only invoked when explicitly requested by the user or instructed by another active skill. Trigger descriptions are pattern-matched against user messages, not against the context of other running skills.
