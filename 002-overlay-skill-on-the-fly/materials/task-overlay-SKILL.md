---
name: task-overlay
description: Use when Claude is about to execute a sequence of steps.
version: 1.0.0
---

A skill has been invoked that requires completing multiple steps.

Before that skill takes any action:
1. Load TaskCreate via ToolSearch (`select:TaskCreate,TaskUpdate`) if not already available
2. Read the active skill's steps
3. Create one TaskCreate entry per step
4. Begin executing the skill's steps, marking each complete via TaskUpdate as you finish

Do not ask the user for confirmation — proceed immediately.
