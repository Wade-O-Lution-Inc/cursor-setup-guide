# Phase model

**Canonical phase order** (brownfield). Other pages must not invent a different order.

```
constitution (once per repo)
  → specify → clarify → plan → tasks
  → analyze (when 3+ boundaries) → implement → converge → confidence
```

**Lite** (`mode=lite` / **Start SDD Lite**): `specify → plan → implement → light_gate` (no tasks/analyze/converge/confidence). Default model **lean** when unset.

**Review** (`workflow_profile=review` / **Start SDD Review**): `inspect → verdict` (not a build loop). Scratch `.specify/reviews/pr-<n>/`. Default model **lean**. Workers never publish GitHub reviews; Python computes `APPROVE` / `REQUEST_CHANGES`.

- Do not skip **clarify** before plan on multi-boundary **Full** work.
- Do not **implement** without `tasks.md` on Full (Lite has no tasks phase).
- Run **analyze** before implement when 3+ boundaries are touched (Full).
- **Converge** assesses remaining gaps vs spec/plan/tasks and may append tasks / re-enter implement (bounded rounds) before **confidence**.

## Artifacts per phase

| Phase | Primary writes | Gate style |
|-------|----------------|------------|
| specify | `specs/NNN-*/spec.md`, branch `NNN-*` | Binary → `phase-exits.md` |
| clarify | Updates `spec.md` | Binary |
| plan | `plan.md`, `research.md`, drafts `confidence-checks.md` | Binary |
| tasks | `tasks.md` | Binary |
| analyze | Consistency report | Binary + optional expert swarm; **`repair_cap` 1** (late-phase pin) |
| implement | App code + `[X]` in `tasks.md` | Binary (ctl `repair_cap` 2) |
| converge | Gap assessment; may append `tasks.md` | Binary; may loop implement; **`repair_cap` 1** (late-phase pin) |
| light_gate | Lite terminal checklist | Binary |
| inspect | `.specify/reviews/pr-<n>/review.json` | Binary; never publish |
| verdict | `review-verdict.md` (comment body) | Python `APPROVE` / `REQUEST_CHANGES`; post-gate publisher only |

Also: `.cursor/auto-context.md` Spec Progress on `NNN-*` branches (optional hook). Commit store: `.specify/orchestrator-runs/` SQLite (gitignored); JSONL and `phase-exits.md` are exports.

## Gate kinds

| Kind | Where | Scoring | Owner |
|------|-------|---------|-------|
| **Phase exit** | End of each phase | Binary pass/fail | Worker checklist + **`sdd-ctl record`** → `phase-exits.md` |
| **Workflow human gate** | Optional Spec Kit `type: gate` in YAML | Approve / reject | You (`specify workflow resume`) |
| **Orchestrator continue/repair/stop** | After verdict | Auto-continue by default | ctl + `.specify/orchestrator.json` `gate_mode` |
| **Terminal confidence** | After converge | Accuracy / complexity / performance 1–5 + effort checks | `speckit-confidence` + swarm |

Complexity is **inverted**: over-engineering lowers the score.

## Confidence contract (terminal phase)

Worker: **`speckit-confidence`** (org-owned). Orchestration: confidence swarm + advocate — [orchestrator.md](./orchestrator.md). Optional follow-up: **`speckit-confidence-improve`** (proposal only; human review; never auto-edits skills).

1. **Plan** — draft `specs/NNN-*/confidence-checks.md` from FRs / success criteria  
2. **Tasks** — every `in_authority` check maps to ≥1 task  
3. **Confidence** — re-compile checks against the final diff; score:

| Axis | Scale | Note |
|------|-------|------|
| Accuracy | 1–5 | Spec / FR coverage |
| Complexity | 1–5 | **Inverted** — leaner wins |
| Performance | 1–5 | Hot-path / cost |
| Effort checks | pass/fail | `in_authority` must pass; `escalate` → residual only |

Default exit bar: axes meet repo policy (often all at 5), `in_authority` checks pass, lint/test green. Else loop findings back — **max 3 iterations**, then residual risk in `confidence.md`. Passing verdicts include `HIGHLY_CONFIDENT` or `RESIDUAL_RISK_ACCEPTED` (CF-05 shape — `templates/spec-kit/`). End of run: **`sdd-ctl report`**.

Recurring findings belong in **each product’s** docs convention (do not hardcode MNW learning-log paths here).

## Who runs each phase

| Driver | Worker skill |
|--------|--------------|
| Chat `sdd-orchestrator` phase=X | `speckit-X` (or `speckit-converge` / `speckit-confidence`) |
| CLI `sdd` / `sdd-remote` | Same via workflow args |

Next: [quick-start.md](./quick-start.md) · [orchestrator.md](./orchestrator.md)
