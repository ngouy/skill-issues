# skill-issue

A collection of field notes on how Claude Code actually behaves — skills, context windows, token economics, and whatever else turns out to be worth documenting.

Each paper follows the same structure: **question → discovery → answer.**

---

## Papers

| # | Date | Question | Tags |
|---|------|----------|------|
| [01](./01-skills-vs-loaded-files.md) | 2026-03-09 | Are router sub-skills and flat skills equivalent in memory footprint and isolation? | `skills` `context-window` `token-economics` `router-pattern` |
| [002](./002-overlay-skill-on-the-fly/README.md) | 2026-03-10 | Can task-tracking be injected into any multi-step skill at runtime without touching its SKILL.md? | `overlay-skill` `hooks` `UserPromptSubmit` `execution-mode` `non-determinism` `task-tracking` |
| [004](./004-using-superpowers-compliance-nondeterminism/README.md) | 2026-03-10 | Does Claude reliably apply the using-superpowers skill-checking protocol at the skill-load/execute transition? | `using-superpowers` `execution-mode` `non-determinism` `meta-skill` |

---

## Format

Each paper lives in a numbered subdirectory: `NNN-name/README.md`. Raw experiment logs and artifacts are in `NNN-name/materials/`.

Each paper covers one question. New findings = new paper. `index.md` is the machine-readable index (owned by the `research-idea` skill).
