# Managed speckit-* deltas (after Spec Kit upgrade)

These six **managed** skills are hash-tracked by `cursor-agent` integration. Wade-O-Lution adds a **`## Phase Exit Gate`** section (binary checklist; workers must **not** append `phase-exits.md` — that is **`sdd-ctl record`**). Re-apply deltas after every `specify integration upgrade --force`.

**Reference implementation:** [meeting_notes_workflow `.cursor/skills/`](https://github.com/Wade-O-Lution-Inc/meeting_notes_workflow/tree/main/.cursor/skills)

| Skill | Org delta |
|-------|-----------|
| `speckit-specify` | Phase Exit Gate checklist (no self-write of phase-exits) |
| `speckit-clarify` | Phase Exit Gate |
| `speckit-plan` | Phase Exit Gate + draft `confidence-checks.md` from plan template section |
| `speckit-tasks` | Phase Exit Gate |
| `speckit-analyze` | Phase Exit Gate |
| `speckit-implement` | Phase Exit Gate + implement micro-gates |

## Managed plan template delta

After upgrade, merge the **Confidence Checks (draft)** section into `.specify/templates/plan-template.md`:

See [../spec-kit/plan-template-confidence-section.patch](../spec-kit/plan-template-confidence-section.patch).

## Re-apply procedure

```bash
specify integration upgrade --force   # upstream bump
specify integration status            # expect WARNING on modified_managed_files

# For each skill above: diff meeting_notes canonical copy vs your repo
# Re-merge ## Phase Exit Gate sections and plan-template confidence section
```

## Global stub pattern

Keep thin pointer stubs under `~/.cursor/skills/speckit-*/` that say "read canonical body in owning repo" — see [managed-vs-custom.md](../../specify/managed-vs-custom.md).
