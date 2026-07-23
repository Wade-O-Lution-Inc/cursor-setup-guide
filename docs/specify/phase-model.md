# Phase model

**Canonical phase order** (brownfield). Other pages must not invent a different order.

```
constitution (once per repo)
  → specify → clarify → plan → tasks
  → analyze (when 3+ boundaries) → implement → converge → confidence
```

- Do not skip **clarify** before plan on multi-boundary work.
- Do not **implement** without `tasks.md`.
- Run **analyze** before implement when 3+ boundaries are touched.
- **Converge** assesses remaining gaps vs spec/plan/tasks and may append tasks / re-enter implement (bounded rounds) before **confidence**.

## Artifacts per phase

| Phase | Primary writes | Gate style |
|-------|----------------|------------|
| specify | `specs/NNN-*/spec.md`, branch `NNN-*` | Binary → `phase-exits.md` |
| clarify | Updates `spec.md` | Binary |
| plan | `plan.md`, `research.md`, drafts `confidence-checks.md` | Binary |
| tasks | `tasks.md` | Binary |
| analyze | Consistency report | Binary + optional expert swarm |
| implement | App code + `[X]` in `tasks.md` | Binary (higher `repair_cap`) |
| converge | Gap assessment; may append `tasks.md` | Binary; may loop implement |
| confidence | `confidence.md`; re-compile checks | **1–5 axes** + effort checks; swarm + advocate |

Also: `.cursor/auto-context.md` Spec Progress on `NNN-*` branches (optional hook). Runlog: `.specify/orchestrator-runs/` (gitignored).

## Gate kinds

| Kind | Where | Scoring | Owner |
|------|-------|---------|-------|
| **Phase exit** | End of each phase | Binary pass/fail | Worker checklist + **`sdd-ctl record`** → `phase-exits.md` |
| **Workflow human gate** | Optional Spec Kit `type: gate` in YAML | Approve / reject | You (`specify workflow resume`) |
| **Orchestrator continue/repair/stop** | After verdict | Auto-continue by default | ctl + `.specify/orchestrator.json` `gate_mode` |
| **Terminal confidence** | After converge | Accuracy / complexity / performance 1–5 + effort checks | `speckit-confidence` + swarm |

Complexity is **inverted**: over-engineering lowers the score.

## Who runs each phase

| Driver | Worker skill |
|--------|--------------|
| Chat `sdd-orchestrator` phase=X | `speckit-X` (or `speckit-converge` / `speckit-confidence`) |
| CLI `sdd` / `sdd-remote` | Same via workflow args |

Next: [quick-start.md](./quick-start.md) · [orchestrator.md](./orchestrator.md) · [confidence-loop.md](./confidence-loop.md)
