# 002 - overlay-skill-on-the-fly

## Question
Can an overlay skill (like skill-progressify) be invoked automatically at skill-start — parsing steps, spinning up a TodoWrite task list, and yielding — and if so, which invocation approach is most token-efficient?

## Motivation
skill-progressify currently requires explicit invocation. If it (or a lightweight variant) could be wired as an automatic overlay triggered on any skill invocation, every skill would get live progress tracking for free — but the token cost of parsing + task-creation on every invocation is unknown.

## Hypotheses
none

## Notes
none
