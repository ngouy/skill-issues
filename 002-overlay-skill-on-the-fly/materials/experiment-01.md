## Experiment 01

### What was done
Invoked `/test-overlay-target` in a fresh Claude Code session. The skill had an embedded `## Checklist` block with 3 tasks. The `task-overlay` skill was present in the skills list with trigger: "Use when any skill needs to complete a list of tasks or steps." No explicit user instruction to invoke task-overlay.

Pre-run context: 14k/200k tokens (7%) — System prompt: 3.5k, System tools: 7.7k, Skills: 1.6k, Messages: 1.5k.

### What was observed
- TaskCreate fired automatically — tasks appeared in the sidebar (3 tasks matching the Checklist block)
- task-overlay was NOT invoked
- Post-run context: 33k/200k tokens (17%) — Messages: 17k
- Delta: ~19k tokens consumed

### Interpretation
Embedded Checklist works reliably as a task injection mechanism. task-overlay did not auto-invoke despite its trigger description matching the scenario — Claude did not treat the trigger description as a reason to auto-invoke the skill unprompted. This is an early signal that trigger-based auto-invocation (Mechanism A) may not work.
