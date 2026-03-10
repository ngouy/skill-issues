## Experiment 05

### What was done
Same setup as experiments 03 and 04. Third run to establish pattern. Fresh session. Pre-run: 14k tokens.

### What was observed
- task-overlay WAS invoked
- TaskCreate fired — 3 tasks created in sidebar
- Post-run: 28k tokens — Messages: 11.7k
- Delta: ~14k tokens

### Interpretation
B3 trigger fired on this run. Combined with experiments 03–05: fires 2/3 times (67%). Behavior is non-deterministic — same setup, same trigger, variable outcome. Not reliable enough for production use as a task injection mechanism without additional enforcement.
