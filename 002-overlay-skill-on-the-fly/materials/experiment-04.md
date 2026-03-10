## Experiment 04

### What was done
Same setup as experiment 03: `task-overlay` with B3 trigger ("Use when Claude is about to execute a sequence of steps"), `test-overlay-target` with no embedded Checklist. Fresh session. Pre-run: 14k tokens.

### What was observed
- task-overlay did NOT fire
- TaskCreate did NOT fire
- Post-run: 25k tokens — Messages: 8.9k
- Delta: ~11k tokens

### Interpretation
B3 trigger failed on this run despite identical setup to experiment 03 where it succeeded. Suggests non-deterministic behavior — trigger-based auto-invocation is probabilistic, not reliable.
