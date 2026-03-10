# Why This Matters

The `using-superpowers` skill is the foundation of the entire skill auto-invocation system. It establishes the 1% rule: if there is even a 1% chance a skill applies, Claude must invoke it before taking any other action. Every user skill's ability to auto-invoke depends on this protocol firing at the right moment.

If this protocol is non-deterministic — firing sometimes but not always — then no skill trigger description can be relied upon to auto-invoke consistently. This has direct consequences for overlay skill design, skill-progressify v2, and any skill that depends on automatic invocation without explicit user instruction.

# Question

Does Claude reliably apply the using-superpowers skill-checking protocol at the transition between skill-load and skill-execution — and if not, what determines whether it fires?

# Setup

During investigation 002 (overlay-skill-on-the-fly), a standalone overlay skill (`task-overlay`) with trigger "Use when Claude is about to execute a sequence of steps" was tested against a target skill (`test-overlay-target`) with 3 explicit steps and no embedded Checklist.

The same setup was run 3 times with fresh sessions. task-overlay fired on 2 of 3 runs. After each outcome, Claude was asked to explain its reasoning.

# Findings

**When it fired (2/3 runs):**

Claude described the reasoning chain as:
1. test-overlay-target loaded → content read → 3 sequential steps identified
2. Before executing, Claude asked: "is there a skill that applies to what I'm about to do?"
3. task-overlay description matched exactly
4. using-superpowers 1% rule: match found → invoke before acting
5. task-overlay invoked → TaskCreate fired → execution began

Claude described this as "essentially automatic — description matched situation, rule says invoke, I invoked."

**When it failed (1/3 runs):**

Claude described the failure as a "context-switching failure":
> "I was in execution mode — the skill content was already loaded and the steps were clear, so I treated following the skill as the task and skipped the meta-step of checking whether other skills applied first."

Claude explicitly identified this as a violation of the using-superpowers protocol and acknowledged the red flag it walked into: "I already have my instructions" → skill check still comes BEFORE executing.

# Answer

The using-superpowers skill-checking protocol is **non-deterministic at the skill-load/execute transition**. It fires reliably when Claude evaluates a user message, but inconsistently when Claude transitions from loading a skill to executing it. The failure mode is "execution mode" — Claude treats the loaded skill content as sufficient instruction and skips the meta-check.

Observed reliability: 2/3 (67%) across 3 controlled runs.

# Implications

1. **No trigger wording can guarantee reliable overlay invocation.** The bottleneck is not the trigger description but whether the meta-check fires. A perfectly-worded trigger only helps when Claude pauses to check — which it doesn't always do.

2. **The embedded Checklist approach (skill-progressify v1) is more reliable precisely because it eliminates the meta-check dependency.** The instruction is inside the execution context, not outside it.

3. **For a true runtime overlay without file edits, the using-superpowers protocol needs to explicitly enforce a skill-check after every skill load**, not just at message evaluation time. This would require a change to the using-superpowers skill itself.

4. **Hook-based injection (firing before Claude's reasoning begins) is the only mechanism that fully bypasses this non-determinism.**

# Limitations

- 3 runs is a small sample. True failure rate could differ.
- Only one trigger wording was tested at this level of analysis. Other wordings might shift the rate but are unlikely to eliminate the non-determinism entirely given the root cause.
- The "execution mode" failure is self-reported by Claude — it may not accurately reflect the underlying mechanism.

# Tags

using-superpowers, skill-invocation, auto-invoke, overlay, non-determinism, meta-check, execution-mode, skill-progressify, trigger-reliability
