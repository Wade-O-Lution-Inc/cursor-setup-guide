# Phase model

Locked order (brownfield):

```
constitution (once)
  → specify → clarify → plan → tasks → analyze → implement → confidence
```

Do not skip **clarify** before plan on multi-boundary work. Do not **implement** without `tasks.md`. Run **analyze** before implement when 3+ boundaries are touched.

## Artifacts per phase

| Phase | Primary writes | Gate style |
|-------|----------------|------------|
| specify | `specs/NNN-*/spec.md`, branch `NNN-*` | Binary phase-exit → `phase-exits.md` |
| clarify | Updates `spec.md` | Binary phase-exit |
| plan | `plan.md`, `research.md`, drafts `confidence-checks.md` | Binary phase-exit |
| tasks | `tasks.md` (effort checks mapped) | Binary phase-exit |
| analyze | Consistency report (no auto-edit preferred) | Binary phase-exit |
| implement | App code + `[X]` in `tasks.md` | Binary phase-exit (repair_cap 2) |
| confidence | `confidence.md`; re-compile `confidence-checks.md` | **1–5 axes** + effort checks; max 3 loops |

Also always: `.cursor/auto-context.md` Spec Progress on `NNN-*` branches (optional hook).

## Two different “gates”

| Kind | Where | Scoring | Owner |
|------|-------|---------|-------|
| **Phase exit** | End of specify…implement | Binary pass/fail only | Worker checklist + **orchestrator** appends `phase-exits.md` |
| **Workflow human gate** | `review-spec` / `review-plan` / `review-tasks` in YAML | Approve / reject | You (CLI resume) |
| **Orchestrator hard/soft** | After judge verdict | pass → continue or pause | `phase-models.json` `gate` field |
| **Terminal confidence** | After implement | Accuracy / complexity / performance 1–5 + effort checks | `speckit-confidence` |

Complexity is **inverted**: over-engineering lowers the score.

## Constitution SDD quality gates (reference)

From meeting_notes `.specify/memory/constitution.md` (v1.2.0 pattern):

1. Clarify before plan (multi-boundary)
2. Analyze after tasks before implement (3+ boundaries)
3. No implement without approved `tasks.md`
4. Mark tasks `[X]` during implement
5. Confidence after implement (effort checks + static axes; escalate tags never block exit)
6. Binary phase-exit each non-terminal phase; log to `phase-exits.md`; self-repair 1× (2× implement)

## Who runs each phase

| Chat | CLI `sdd` step | Worker skill |
|------|----------------|--------------|
| `sdd-orchestrator` phase=X | Same preamble in workflow args | `speckit-X` (or `speckit-confidence`) |

Next: [orchestrator.md](./orchestrator.md) · [confidence-loop.md](./confidence-loop.md)
