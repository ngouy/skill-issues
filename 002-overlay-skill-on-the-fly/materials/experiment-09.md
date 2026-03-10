## Experiment 09 — Mechanism B: always-on UserPromptSubmit hook, natural language, multi-step skill

### What was done
Updated hook to always-on (removed `/` prefix filter). Conditional instruction: "If you are about to execute a skill that contains sequential steps, create tasks. If no skill with steps is being invoked, ignore this instruction."

`task-overlay` still disabled. Fresh session. User invoked skill via natural language: "Please run the test overlay target skill for me."

### What was observed
TaskCreate entries appeared in the sidebar before execution:
- List files in /tmp
- Create /tmp/overlay-test.txt
- Confirm file contents

Steps executed in order, each marked complete. Claude's self-report on why it created tasks:

> "1. You asked me to run test-overlay-target
> 2. Your hook fired on message submission and added that instruction
> 3. I invoked the Skill tool, which loaded the skill — it had 3 sequential steps
> 4. The hook condition matched ('skill with sequential steps'), so I fetched TaskCreate/TaskUpdate schemas via ToolSearch
> 5. I created one task per step, then executed them in order, marking each complete as I went"

Token count: ~28k total / 17.7k messages.

### Interpretation
Always-on UserPromptSubmit hook works for natural language skill invocations. The conditional instruction ("if no skill with steps... ignore") is correctly interpreted — Claude loads the skill, detects sequential steps, and applies the task-creation behavior. Mechanism is deterministic.
