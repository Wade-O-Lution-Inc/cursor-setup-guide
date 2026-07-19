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
| analyze | Consistency report (no auto-edit preferred) | Binary + optional expert swarm |
| implement | App code + `[X]` in `tasks.md` | Binary (higher `repair_cap`) |
| confidence | `confidence.md`; re-compile `confidence-checks.md` | **1–5 axes** + effort checks; swarm + advocate |

Also: `.cursor/auto-context.md` Spec Progress on `NNN-*` branches (optional hook). Runlog: `.specify/orchestrator-runs/` (gitignored).

## Two different “gates”

| Kind | Where | Scoring | Owner |
|------|-------|---------|-------|
| **Phase exit** | End of each phase | Binary pass/fail | Worker checklist + **`sdd-ctl record`** appends `phase-exits.md` |
| **Workflow human gate** | Optional Spec Kit `type: gate` in YAML | Approve / reject | You (`specify workflow resume`) |
| **Orchestrator continue/repair/stop** | After verdict | Auto-continue by default | ctl + `.specify/orchestrator.json` `gate_mode` |
| **Terminal confidence** | After implement | Accuracy / complexity / performance 1–5 + effort checks | `speckit-confidence` + confidence swarm |

Complexity is **inverted**: over-engineering lowers the score.

## Constitution SDD quality gates (reference)

From meeting_notes `.specify/memory/constitution.md` pattern:

1. Clarify before plan (multi-boundary)
2. Analyze after tasks before implement (3+ boundaries)
3. No implement without validated `tasks.md`
4. Mark tasks `[X]` during implement
5. Confidence after implement (effort checks + static axes; escalate tags never block exit)
6. Binary phase-exit each non-terminal phase; orchestrator alone appends `phase-exits.md`; repair up to cap then stop — no silent deferral

## Who runs each phase

| Chat | CLI `sdd` step | Worker skill |
|------|----------------|--------------|
| `sdd-orchestrator` phase=X | Same preamble in workflow args | `speckit-X` (or `speckit-confidence`) |

Next: [orchestrator.md](./orchestrator.md) · [confidence-loop.md](./confidence-loop.md)
