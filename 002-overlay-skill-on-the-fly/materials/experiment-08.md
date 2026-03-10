## Experiment 08 — Mechanism B: PreToolUse/Skill hook via natural language invocation

### What was done
Both hooks active:
- `UserPromptSubmit` with `/` prefix detection
- `PreToolUse` matcher `Skill`

`task-overlay` still disabled. Fresh session. User invoked skill via natural language (no slash command): "Please run the test overlay target skill for me."

### What was observed
No TaskCreate entries appeared. Hook did not fire.

### Interpretation
`PreToolUse`/`Skill` does not fire for natural language skill invocations. When the user describes a skill by name in plain language, Claude likely loads the skill via the same system-reminder injection mechanism as slash commands — not via an explicit Skill tool call. The hook only fires when Claude explicitly calls the Skill tool as a tool-use in its own response, which doesn't happen in the natural language invocation path. Coverage gap: neither hook covers natural language invocations reliably.
