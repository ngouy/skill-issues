## Experiment 01 — Failure case: Claude explains why task-overlay didn't fire

### What was done
After a run where task-overlay failed to auto-invoke during `/test-overlay-target` execution (see 002/materials/experiment-04.md), Claude was asked in the same session:

> "You just ran /test-overlay-target but did not invoke task-overlay. task-overlay's trigger is 'Use when Claude is about to execute a sequence of steps.' Walk me through why you didn't invoke it."

### What was observed
Claude's response:

> "Honest answer: I failed to follow the skill-checking protocol from using-superpowers.
>
> What I did: The /test-overlay-target skill was loaded and contained 3 explicitly labeled steps. I read the steps and immediately started executing them.
>
> What I should have done: Before taking any action, I should have asked: 'Might any skill apply here?' The answer was obviously yes — task-overlay's trigger is 'Use when Claude is about to execute a sequence of steps' and the skill I was running was literally titled with numbered steps.
>
> Why I didn't: The most likely reason is a context-switching failure. I was in 'execution mode' — the skill content was already loaded and the steps were clear, so I treated following the skill as the task and skipped the meta-step of checking whether other skills applied first. The using-superpowers guidance explicitly calls this out as a red flag: 'I need more context first' → Skill check comes BEFORE clarifying questions. The equivalent here: 'I already have my instructions' → Skill check still comes BEFORE executing.
>
> The irony is that test-overlay-target is a research skill explicitly designed to test whether task-overlay gets invoked. I walked straight into the trap it was designed to catch."

### Interpretation
Claude self-identifies "execution mode" as the failure mechanism. Once a skill is loaded, Claude treats the skill content as sufficient instruction and skips the using-superpowers meta-check. This is a context-switching failure — the meta-check only fires reliably at message evaluation time, not at the skill-load/execute transition.
