# Confidence loop & learning

Terminal phase after implement. Worker skill: **`speckit-confidence`** (org-owned, not Spec Kit managed). Orchestration: **confidence swarm** + mandatory advocate + merge via [orchestrator.md](./orchestrator.md). Optional follow-up: **`speckit-confidence-improve`**.

## Lifecycle of effort checks

1. **Plan** — draft `specs/NNN-*/confidence-checks.md` from FRs / success criteria + complexity ceiling (`confidence-checks-template.md`)
2. **Tasks** — every `in_authority` check maps to ≥1 task
3. **Confidence** — re-compile checks against the final diff; score:

| Axis | Scale | Note |
|------|-------|------|
| Accuracy | 1–5 | Spec / FR coverage |
| Complexity | 1–5 | **Inverted** — leaner wins |
| Performance | 1–5 | Hot-path / cost concerns |
| Effort checks | pass/fail | `in_authority` must pass; `escalate` → residual only |

Exit bar: all axes at 5 **and** all `in_authority` checks pass **and** lint/test green. Else loop findings back to plan/tasks/implement and re-score — **max 3 iterations**, then residual risk in `confidence.md`.

Artifact shape: CF-05 format contract on `confidence.md` (see meeting_notes confidence template). Passing confidence verdicts must include a decision (`HIGHLY_CONFIDENT` or `RESIDUAL_RISK_ACCEPTED`).

Wired optionally via `.specify/extensions.yml` `after_implement` → `speckit.confidence`. End of run: **`sdd-ctl report`**.

## Learning log

`docs/assessments/SDD_CONFIDENCE_LEARNING_LOG.md` (in meeting_notes) accumulates recurring findings.

`after_confidence` may prompt **`speckit-confidence-improve`**, which:

- Clusters the log into a **proposal only**
- **Never** edits skills, constitution, or Spec Kit templates itself
- Requires human review before any harness change

## Customization

| Surface | You can |
|---------|---------|
| `confidence-checks-template.md` | Change draft structure |
| `confidence-template.md` | Change score artifact shape (keep CF-05 contract) |
| `speckit-confidence` skill | Loop rules, axis definitions (repo-owned) |
| ctl confidence prompts / swarm roles | `prompts/confidence-*.md`, `phase-models.json` |
| Learning log path / tags | Repo docs convention |
| Extension hooks | Enable/disable optional prompts in `extensions.yml` |

Next: [phase-model.md](./phase-model.md) · [orchestrator.md](./orchestrator.md) · [managed-vs-custom.md](./managed-vs-custom.md)
