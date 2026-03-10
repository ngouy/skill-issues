## Experiment 03

### What was done
Updated `task-overlay` trigger from "Use when any skill needs to complete a list of tasks or steps" to "Use when Claude is about to execute a sequence of steps." Invoked `/test-overlay-target` (no embedded Checklist) in a fresh Claude Code session.

Pre-run context: 14k/200k tokens (7%).

### What was observed
- task-overlay WAS invoked (Skill tool called, skill loaded successfully)
- TaskCreate fired — tasks appeared in the sidebar
- Post-run context: 28k/200k tokens (14%) — Messages: 11.8k
- Delta: ~14k tokens consumed

### Interpretation
Trigger language is the determining factor. Behavioral/self-referential trigger language ("Claude is about to execute") successfully causes auto-invocation, while descriptive language ("skill needs to complete tasks") does not. The overlay mechanism works when the trigger describes Claude's internal state rather than the skill's purpose.

Token delta (14k) is ~5k cheaper than the embedded Checklist baseline (19k), suggesting the overlay approach is more token-efficient when it works.
