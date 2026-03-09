# Skills vs Loaded Files: Token Economics and Isolation

## Why This Matters

Skills in Claude Code are powerful — they let you package reusable instructions that load on demand. The natural next step is organizing them: grouping related skills into a collection, versioning that collection as a git repository, sharing it across machines.

The problem: **Claude Code only discovers skills exactly one level deep** inside `~/.claude/skills/`. A git repo of skills would look like `my-skill-group/skill-one/SKILL.md` — two levels deep. Claude never finds it.

The workaround is a **router pattern**: place a `SKILL.md` at depth 1 (`my-skill-group/SKILL.md`) that intercepts the right triggers and delegates to the deeper files via `Read`. This makes git-repo-style organization possible — but it's a workaround, not a first-class feature.

The question is: **does this workaround cost anything?** In token usage, in isolation, in correctness?

---

## Question

When a skill at depth 1 routes to sub-skills (loaded via the `Read` tool) versus invoking a flat skill directly via the `Skill` tool — are the memory footprint and isolation behavior equivalent? What are the real trade-offs?

---

## Setup

Three flat skills and three sub-skills (behind a router) were created with identical content (~400 tokens of lore per skill). Token usage was measured at three points using `/context`:

1. Session start (no invocations)
2. After invoking 1 skill
3. After invoking all 3 skills

Both approaches were tested independently in fresh sessions.

---

## Discovery

### Finding 1: Skills are description-only at session start

Regardless of depth or approach, the `Skills` section in `/context` only loads the **frontmatter description** of each skill at session start — not the full content.

| Skill | Tokens at start |
|---|---|
| `flat-skill-one` | 13 tokens |
| `flat-skill-two` | 13 tokens |
| `flat-skill-three` | 14 tokens |
| `group-alpha` (router) | 30 tokens |

Full content is never pre-loaded. It only hits context on invocation.

### Finding 2: Depth-1 is the only discovery boundary

Skills are discovered at session start **only if their `SKILL.md` is exactly one level deep** inside `~/.claude/skills/`. Depth 2+ (`group/skill/SKILL.md`) is ignored unless a depth-1 router exists.

| Path | Discovered? |
|---|---|
| `~/.claude/skills/my-skill/SKILL.md` | ✅ |
| `~/.claude/skills/group/skill/SKILL.md` | ❌ |
| `~/.claude/skills/group/SKILL.md` | ✅ (router) |

### Finding 3: Token cost on invocation — flat is cheaper

| State | Messages tokens | Delta |
|---|---|---|
| Baseline | 1.3k | — |
| Flat: 1 skill invoked | 3k | +1.7k |
| Flat: 3 skills invoked | 4.1k | +2.8k total (+~0.93k each) |
| Router: 1 sub-skill | 3.5k | +2.2k |
| Router: 3 sub-skills | 5.3k | +4k total (+~1.33k each) |

**Flat skills cost ~500 tokens less per invocation.** The router overhead comes from: loading the router's own content + the `Read` tool call to fetch the sub-skill file.

### Finding 4: Invoked content lands in Messages, not Skills

When a flat skill is invoked via the `Skill` tool, its content appears in **Messages**, not the Skills section. Same for router sub-skills loaded via `Read`. Both approaches add tokens to the same bucket.

### Finding 5: Isolation works — with caveats

Sub-skills are **not pre-loaded** when their router is invoked. Only the triggered sub-skill is read. Siblings stay out of context.

However: if the router's content lists sibling paths, Claude will proactively fetch a sibling if asked about it. Isolation is behavioral, not enforced.

**Fix:** Instruct the router explicitly: *"Read and follow ONLY the matching sub-skill. Do not reference or load any other sub-skills."*

After this change: asking about a sibling's content returned "I don't know" with no `Read` call.

---

## Answer

**Are router sub-skills and flat skills equivalent in memory behavior?**
Mostly yes — both are description-only at session start, both load full content into Messages on invocation.

**What are the real trade-offs?**

| | Flat skills | Router pattern |
|---|---|---|
| Discovery | ✅ Automatic | ❌ Requires depth-1 router |
| Token cost per invocation | ~1.7k | ~2.2k (+~500 overhead) |
| Organization | Flat namespace | Git-repo-style grouping |
| Sibling isolation | N/A | Behavioral (instruction-dependent) |
| Invocation mechanism | `Skill` tool (proper) | `Read` tool (workaround) |

**When to use flat skills:** Default. Cheaper, discoverable, no overhead.

**When to use the router pattern:** When organizing skills as git repositories (one repo = one group of related skills). Accept the ~500 token overhead per invocation in exchange for structured organization.

---

*Tested on Claude Sonnet 4.6 — March 2026*
