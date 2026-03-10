## Experiment 11 — Mechanism B: always-on hook, slash command, multi-step skill

### What was done
Same always-on UserPromptSubmit hook as Experiments 09–10. Fresh session. User invoked skill via slash command: `/test-overlay-target`.

### What was observed
TaskCreate entries appeared immediately:
- List files in /tmp
- Create /tmp/overlay-test.txt
- Confirm file contents

### Interpretation
Always-on UserPromptSubmit hook works identically for slash command invocations. Parity confirmed between slash command and natural language paths. The hook does not need `/` prefix detection — the conditional instruction ("if skill has steps") handles both correctly.
