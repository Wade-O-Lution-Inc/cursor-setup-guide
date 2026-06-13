---
name: sdd-entry
description: >-
  Entry point for Spec-Driven Development. Use when starting SDD, speckit,
  sdd-full, or a multi-step spec-driven feature loop.
disable-model-invocation: true
---

# SDD Entry

**Read first:** `docs/agents/SDD_USER_GUIDE.md` (keep open while learning).

## Default path

1. Confirm `.specify/` exists (`specify integration status`).
2. Read `.specify/memory/constitution.md`.
3. Chat Mode A: `Spec this feature: <what/why>`
4. Terminal Mode B: `specify workflow run sdd-full -i spec="..." -i integration=cursor-agent`

## Pipelines

| ID | When |
|----|------|
| `sdd-full` | Default new feature |
| `sdd-api` | API/service only |
| `sdd-rfc` | Plan only, no code |
| `sdd-test-fix` | Implement + test/fix loop |
| `sdd-issues` | Spec → GitHub issues |

## Phase skills

`speckit-specify` → `speckit-clarify` → `speckit-plan` → `speckit-tasks` → `speckit-analyze` → `speckit-implement`

## Handoff

On compact/checkpoint: include `tasks.md` progress. Read `.cursor/auto-context.md` Spec Progress on `NNN-*` branches.

Deep reference: `docs/agents/SPEC_DRIVEN_DEVELOPMENT.md` (add after bootstrap).

Org templates: [cursor-setup-guide](https://github.com/Wade-O-Lution-Inc/cursor-setup-guide)
