# Confidence loop & learning

Terminal phase after implement. Worker skill: **`speckit-confidence`** (org-owned, not Spec Kit managed). Optional follow-up: **`speckit-confidence-improve`**.

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

Wired optionally via `.specify/extensions.yml` `after_implement` → `speckit.confidence`.

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
| `confidence-template.md` | Change score artifact shape |
| `speckit-confidence` skill | Loop rules, axis definitions (repo-owned) |
| Learning log path / tags | Repo docs convention |
| Extension hooks | Enable/disable optional prompts in `extensions.yml` |
| Orchestrator confidence phase | Models / repair_cap in `phase-models.json` |

Next: [phase-model.md](./phase-model.md) · [managed-vs-custom.md](./managed-vs-custom.md)
