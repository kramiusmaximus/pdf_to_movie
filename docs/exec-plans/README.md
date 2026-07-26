# Execution plans

Use a checked-in execution plan for complex, cross-cutting, risky, or multi-session work.

## Lifecycle

1. Create the plan in `active/`.
2. Keep its progress, discoveries, decisions, and verification evidence current during implementation.
3. Move it to `completed/` after the implementation and required verification are complete.
4. Record unresolved follow-up work explicitly rather than hiding it in prose.

## Plan template

```md
# <Outcome>

Status: active

## Context

## Goal

## Non-goals

## Acceptance criteria

- [ ] ...

## Plan

- [ ] ...

## Verification

- [ ] ...

## Decisions

## Progress log
```
