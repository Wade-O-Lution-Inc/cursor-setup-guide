# Confidence loop

Terminal phase after **converge**. Worker: **`speckit-confidence`** (org-owned). Orchestration: confidence swarm + advocate — [orchestrator.md](./orchestrator.md). Optional follow-up: **`speckit-confidence-improve`**.

## Lifecycle of effort checks

1. **Plan** — draft `specs/NNN-*/confidence-checks.md` from FRs / success criteria  
2. **Tasks** — every `in_authority` check maps to ≥1 task  
3. **Confidence** — re-compile checks against the final diff; score:

| Axis | Scale | Note |
|------|-------|------|
| Accuracy | 1–5 | Spec / FR coverage |
| Complexity | 1–5 | **Inverted** — leaner wins |
| Performance | 1–5 | Hot-path / cost |
| Effort checks | pass/fail | `in_authority` must pass; `escalate` → residual only |

Default exit bar (portable contract): axes meet repo policy (often all at 5), `in_authority` checks pass, lint/test green. Else loop findings back to plan/tasks/implement — **max 3 iterations**, then residual risk in `confidence.md`.

Passing verdicts include a decision (`HIGHLY_CONFIDENT` or `RESIDUAL_RISK_ACCEPTED`). Artifact shape: CF-05 on `confidence.md` (see template under `templates/spec-kit/`).

End of run: **`sdd-ctl report`**.

## Learning log (product-specific)

Recurring findings belong in **each product’s** docs convention (meeting_notes uses `docs/assessments/SDD_CONFIDENCE_LEARNING_LOG.md`). Do not hardcode that path in other repos.

`after_confidence` may prompt **`speckit-confidence-improve`**: proposal only; never edits skills/templates itself; human review required.

## Customization

| Surface | You can |
|---------|---------|
| `confidence-*-template.md` | Draft / score artifact shape (keep CF-05) |
| `speckit-confidence` skill | Loop rules (repo-owned) |
| ctl confidence prompts / swarm | ctl `prompts/`, `phase-models.json` |
| Learning log path | Your repo’s docs convention |
| `extensions.yml` | Optional after_implement / after_confidence hooks |

Next: [phase-model.md](./phase-model.md) · [orchestrator.md](./orchestrator.md)
