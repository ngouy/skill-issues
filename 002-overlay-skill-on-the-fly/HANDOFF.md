# Investigation 002 — Handoff

## Where we are

Mechanism A (trigger-based overlay) is done. Mechanism B (hooks) is next and not started.

## Current skill states

- `~/.claude/skills/task-overlay/SKILL.md` — trigger is currently "Use when Claude is about to execute a sequence of steps." (B3 variant)
- `~/.claude/skills/test-overlay-target/SKILL.md` — no embedded Checklist (clean)

Both skills should be cleaned up / removed after the investigation is done.

## Mechanism B plan

Configure a Claude Code hook that fires before skill content loads and injects task-setup instructions. This bypasses Claude's reasoning entirely — the non-determinism found in Mechanism A doesn't apply here.

Check current hooks config first, then add a test hook, run the experiment, reverse the hook after.

## Key prior finding to keep in mind

Mechanism A non-determinism is caused by Claude skipping the using-superpowers meta-check at the skill-load/execute transition ("execution mode"). This is documented in paper 004. Mechanism B is the cleaner test because it doesn't depend on that meta-check at all.
