# Overlay Skill On The Fly — Research Paper

## Section 1: Why This Matters

Skills in Claude Code are static instruction files. When you want a skill to track its own progress — creating task entries in the sidebar, marking steps complete — the standard approach is to embed a `## Checklist` block directly in the skill's SKILL.md. This works, but it couples the behavior to the file: every skill that needs progress tracking must be individually modified.

The practical consequence: if you want to add task tracking to an existing skill, you edit the skill file. If you want to add it to a dozen skills, you edit a dozen files. If you later decide the task-tracking pattern should work differently, you update every file that contains it. This is the embedded approach, and it's the current default in the superpowers ecosystem via `skill-progressify`.

The question this paper investigates is whether task-tracking behavior can be injected at runtime — applied to any multi-step skill without touching its SKILL.md — using either a trigger-based overlay skill or a Claude Code hook. If either mechanism works reliably, it enables a single point of control for cross-cutting behavior like progress tracking, logging, or pre/post-step validation across all skills.

The answer has implications for how skill authors design behavioral overlays, and for how the superpowers plugin ecosystem could evolve to support more composable, non-destructive skill enhancements.

## Section 2: Question

Can task-tracking behavior be injected into an arbitrary multi-step skill at runtime — without embedding it in the skill's SKILL.md — using a trigger-based overlay skill (Mechanism A) or a Claude Code hook (Mechanism B), and how do the two mechanisms compare in reliability and token cost?

## Section 3: Setup

**Target skill:** `test-overlay-target` — a 3-step skill with no embedded Checklist block. Steps: list `/tmp`, create a file, confirm contents.

**Control skill:** `test-overlay-control` — a single-action skill (run `date`), no steps. Used to verify no false-positive task creation.

**Mechanism A — trigger-based overlay:** A skill (`task-overlay`) whose trigger description is designed to auto-invoke when Claude is about to execute another skill's steps. Two trigger variants tested:
- Original: "Use when any skill needs to complete a list of tasks or steps"
- B3 variant: "Use when Claude is about to execute a sequence of steps"

**Mechanism B — hooks:** A `UserPromptSubmit` hook (`skill-task-injector.sh`) that detects skill invocations and injects a task-creation instruction into Claude's context before the skill loads. Two sub-variants tested:
- Slash-command detection only (`/` prefix filter)
- Always-on with conditional instruction ("if skill has steps, create tasks; otherwise ignore")

All Mechanism B experiments disabled `task-overlay` to isolate the hook effect. Fresh session per experiment. Token counts measured from the context usage display.

Materials: `~/.claude/skill-issues/002-overlay-skill-on-the-fly/materials/`

## Section 4: Findings

### Mechanism A: Trigger-based overlay

**Experiment 01 (baseline):** Embedded Checklist in target skill. Tasks created reliably. Delta: ~19k tokens. Confirms baseline behavior works.

**Experiment 02 (original trigger, no Checklist):** `task-overlay` with trigger "Use when any skill needs to complete a list of tasks or steps." Did not fire. Tasks not created. Delta: ~11k tokens. Descriptive trigger language aimed at the skill's purpose does not cause auto-invocation.

**Experiments 03–05 (B3 trigger, three runs):** `task-overlay` with trigger "Use when Claude is about to execute a sequence of steps." Results: fired (✅), did not fire (❌), fired (✅). Rate: 2/3 (67%). Delta when fired: ~14k tokens. Delta when not fired: ~11k tokens.

| Exp | Trigger | Fired | Delta |
|-----|---------|-------|-------|
| 01 | Embedded Checklist (baseline) | ✅ | ~19k |
| 02 | Original trigger | ❌ | ~11k |
| 03 | B3 trigger | ✅ | ~14k |
| 04 | B3 trigger | ❌ | ~11k |
| 05 | B3 trigger | ✅ | ~14k |

**Root cause of non-determinism (from investigation 004):** When Claude loads a skill and sees its steps, it enters "execution mode" — treating the skill content as sufficient instruction and skipping the meta-check that would otherwise evaluate whether any overlay skill applies. When the meta-check fires, auto-invocation is deterministic and correct. When it doesn't, no overlay can rescue it. This is a model behavior gap at the skill-load/execute transition — not a trigger language problem.

### Mechanism B: Hooks

**Experiment 06 (PreToolUse/Skill, slash command):** No tasks created. Slash commands inject skill content directly as a system reminder, bypassing the Skill tool. `PreToolUse`/`Skill` never fires for slash command invocations.

**Experiment 07 (UserPromptSubmit with `/` prefix, slash command):** Tasks created immediately. Deterministic. Delta: ~11.7k messages.

**Experiment 08 (PreToolUse/Skill, natural language):** Shell logging confirmed the hook fired. However, `PreToolUse` stdout does not reach Claude's reasoning context — it is UI-only output. Tasks not created. `PreToolUse` can block or allow tool execution but cannot inject behavioral instructions.

**Experiments 09 + 11 (always-on UserPromptSubmit, multi-step skill):** Conditional instruction ("if skill has steps, create tasks; otherwise ignore"). Both slash command and natural language invocations created tasks. Deterministic. Claude's self-report confirmed the chain: hook output seen as system-reminder → skill loaded → steps detected → tasks created.

**Experiments 10 + 12 (always-on UserPromptSubmit, control skill — no steps):** No tasks created for either invocation type. The conditional instruction correctly suppressed task creation. Token overhead minimal (~3.5k messages, same as a plain no-skill message).

| Exp | Hook event | Invocation | Skill type | Tasks? |
|-----|-----------|------------|------------|--------|
| 06 | PreToolUse/Skill | slash cmd | multi-step | ❌ |
| 07 | UserPromptSubmit /prefix | slash cmd | multi-step | ✅ |
| 08 | PreToolUse/Skill | natural language | multi-step | ❌ (fired, not injected) |
| 09 | UserPromptSubmit always-on | natural language | multi-step | ✅ |
| 10 | UserPromptSubmit always-on | natural language | no steps | ✅ (0 tasks — correct) |
| 11 | UserPromptSubmit always-on | slash cmd | multi-step | ✅ |
| 12 | UserPromptSubmit always-on | slash cmd | no steps | ✅ (0 tasks — correct) |

**Key architecture finding:** Only `UserPromptSubmit` can inject behavioral instructions into Claude's context. `PreToolUse` stdout is UI-only. This is a fundamental constraint of the Claude Code hook system as tested.

## Section 5: Answer

**Mechanism A (trigger-based overlay):** Does not work reliably. The B3 trigger fires ~67% of the time but is non-deterministic. The root cause is not the trigger language — it is a model behavior gap: Claude skips the meta-check at the skill-load/execute transition. Any trigger-based overlay depends on this check firing reliably, and it does not. Mechanism A cannot be trusted for production use.

**Mechanism B (hooks):** Works deterministically across both slash command and natural language invocations using an always-on `UserPromptSubmit` hook with a conditional instruction. Reliable as a technical mechanism.

However, Mechanism B has two practical problems that limit its value as general-purpose overlay infrastructure: (1) there is no install path — hooks require manual `settings.json` surgery, and a skill cannot ship its own hook; (2) an always-on hook that reads instruction content from a file is an injection surface — anything that can write to that file can influence Claude's behavior on every message.

**The deeper finding:** Both mechanisms route around the same root problem — the model behavior gap at the skill-load/execute transition. Hooks are the more reliable workaround today, but the right fix is not a better workaround. It is ensuring that the meta-check fires reliably after every skill loads, before execution begins. That gap is in how Claude handles the transition from loading skill content to acting on it — not in any specific skill or hook configuration.

## Section 6: Limitations

**Sample size for Mechanism A:** Non-determinism observed over 3 runs (2 fires, 1 miss). A larger sample would sharpen the rate estimate and might reveal conditions that predict the miss.

**PreToolUse finding is inferred:** The conclusion that `PreToolUse` stdout is UI-only and not injected into Claude's context was inferred from behavior (hook fired per log, tasks not created). Not verified against Claude Code source or documentation.

**Always-on hook conditional relies on Claude's judgment:** The "if no skill with steps, ignore" guard worked in all tested cases but is soft enforcement. Edge cases (prompts containing step-like language that aren't skill invocations) were not tested.

**No install path explored:** Hook deployment was done manually. Whether a plugin or skill could declare and auto-install its own hook was not investigated.

**Single target skill:** All experiments used `test-overlay-target`, a minimal 3-step skill. Behavior with longer or more structurally complex skills was not tested.

## Section 7: Tags

overlay skill, runtime injection, task tracking, hooks, UserPromptSubmit, PreToolUse, skill composition, execution mode, meta-skill check, non-determinism, using-superpowers, task-overlay, Mechanism A, Mechanism B, Claude Code hooks, skill-progressify, cross-cutting behavior, token efficiency
