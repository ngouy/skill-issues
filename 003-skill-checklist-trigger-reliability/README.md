> # ⚠️ STATUS: TODO
> **This is a research stub, not a published paper. Investigation has not started yet.**

---

# 003 - skill-checklist-trigger-reliability

## Question
Why does the `## Checklist` / REQUIRED block in skills fail to trigger TaskCreate when progressifying multiple skills in one request, but works reliably for single-skill invocations — and what are the trade-offs of making the instruction more aggressive?

## Motivation
skill-progressify's first iteration didn't reliably fire TaskCreate when asked to progressify multiple skills at once. The fix required more forceful language ("REQUIRED", "MUST", "before any other action"), but that introduces costs: more tokens consumed, harder to read, less intuitive for humans scanning the skill file. The tension between reliability and readability is worth understanding systematically.

## Hypotheses
none

## Notes
none
