## Experiment 06 — Mechanism B: PreToolUse/Skill hook

### What was done
Added a `PreToolUse` hook with matcher `"Skill"` to `settings.json`. Hook script output an injection instruction: "read the skill's steps, create one TaskCreate entry per step, mark each complete via TaskUpdate."

`task-overlay` was disabled (trigger changed to `DISABLED-FOR-EXPERIMENT`) to isolate the hook effect.

Fresh session. User ran `/test-overlay-target` (3-step skill, no embedded Checklist).

### What was observed
No TaskCreate entries appeared in the sidebar. Hook appeared to have no effect. Token count: ~25k total / ~10.5k messages — consistent with a plain skill execution (no task creation overhead).

### Interpretation
The `PreToolUse` hook on `"Skill"` does not fire when the user invokes a skill via a slash command (e.g. `/test-overlay-target`). The slash command path in Claude Code appears to inject skill content directly as a system reminder, bypassing the Skill tool invocation entirely. The hook only fires when Claude itself calls the Skill tool (e.g. when Claude decides mid-conversation to invoke a skill). This means the hook matcher needs to change — `UserPromptSubmit` is the correct event to intercept slash command invocations.
