#!/bin/bash
# Research hook — investigation 002/Mechanism B (final: always-on with conditional)
# Used on UserPromptSubmit. Fires on every prompt; conditional instruction lets
# Claude decide whether to create tasks based on whether a skill with steps is invoked.
#
# Also had a PreToolUse/Skill variant (see experiment-08) — that hook fires correctly
# but its stdout is UI-only and does NOT reach Claude's reasoning context.

LOG="/tmp/skill-task-injector.log"
echo "[$(date '+%H:%M:%S')] hook fired" >> "$LOG"

INPUT=$(cat)
echo "[$(date '+%H:%M:%S')] input: $INPUT" >> "$LOG"

IS_PROMPT=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print('yes' if 'prompt' in d else 'no')" 2>/dev/null)
IS_TOOL=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print('yes' if 'tool_name' in d else 'no')" 2>/dev/null)

if [[ "$IS_PROMPT" == "yes" ]]; then
  PROMPT=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('prompt',''))" 2>/dev/null)
  echo "[$(date '+%H:%M:%S')] branch=UserPromptSubmit prompt=$PROMPT" >> "$LOG"
  echo "[$(date '+%H:%M:%S')] injecting (always-on)" >> "$LOG"
  echo "RESEARCH HOOK (002/B): If you are about to execute a skill that contains sequential steps, read those steps and create one TaskCreate entry per step via ToolSearch(select:TaskCreate,TaskUpdate). Then execute the steps, marking each complete via TaskUpdate as you finish. If no skill with steps is being invoked, ignore this instruction."
elif [[ "$IS_TOOL" == "yes" ]]; then
  TOOL=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_name',''))" 2>/dev/null)
  echo "[$(date '+%H:%M:%S')] branch=PreToolUse tool=$TOOL" >> "$LOG"
  # NOTE: PreToolUse stdout does NOT reach Claude's reasoning context.
  # This branch is retained for documentation but has no effect on Claude's behavior.
  echo "[$(date '+%H:%M:%S')] skipping injection (PreToolUse stdout is UI-only)" >> "$LOG"
else
  echo "[$(date '+%H:%M:%S')] branch=unknown (no matching keys)" >> "$LOG"
fi

exit 0
