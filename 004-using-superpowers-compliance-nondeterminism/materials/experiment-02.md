## Experiment 02 — Success case: Claude explains why task-overlay fired

### What was done
After a run where task-overlay successfully auto-invoked during `/test-overlay-target` execution (see 002/materials/experiment-03.md and 002/materials/experiment-05.md), Claude was asked in the same session:

> "You just ran /test-overlay-target and invoked task-overlay before executing. Walk me through exactly why you decided to invoke task-overlay — what triggered that decision and at what point in your reasoning did it happen?"

### What was observed
Claude's response:

> "Trigger point: After the test-overlay-target skill loaded and I read its content — three labeled steps — I was at the moment of 'about to execute a sequence of steps.'
>
> What fired the decision: The task-overlay skill description reads: 'Use when Claude is about to execute a sequence of steps.' That description matched my situation precisely. The using-superpowers meta-skill establishes a hard rule: if there's even a 1% chance a skill applies, invoke it before taking any other action. This wasn't even ambiguous — it was an exact match.
>
> The sequence:
> 1. test-overlay-target loaded → I read it → saw 3 sequential steps
> 2. Before doing anything else, I asked: 'is there a skill that applies to what I'm about to do?'
> 3. task-overlay was right there in the available skills list, with a description that perfectly described my situation
> 4. Rule says invoke before acting → I invoked it
>
> What I did NOT do: I didn't reason 'task-overlay is probably just for complex tasks' or 'these steps are simple enough to skip it.' The using-superpowers skill explicitly lists those rationalizations as red flags.
>
> So the decision was essentially automatic — description matched situation, rule says invoke, I invoked."

### Interpretation
When the meta-check fires, the process is deterministic: trigger description matches → 1% rule applies → invoke. The non-determinism is entirely in whether Claude pauses to apply the meta-check at the skill-load/execute transition. When it does pause, the correct skill always fires. When it doesn't, no overlay can rescue it.
