# Templates

Copy sources for adopting the Wade-O-Lution Cursor harness. Prefer reading **[../specify/](../specify/)** first so you know *why* each file exists.

**Sync contract:** [SYNC.md](./SYNC.md)  
**Live product reference:** [meeting_notes_workflow](https://github.com/Wade-O-Lution-Inc/meeting_notes_workflow)  
**Orchestrator runtime:** [sdd-orchestrator](https://github.com/Wade-O-Lution-Inc/sdd-orchestrator) (clone — not vendored here)

## Spec Kit (`spec-kit/`)

| File | Purpose |
|------|---------|
| [sdd-workflow.yml](./spec-kit/sdd-workflow.yml) | Canonical local workflow → `.specify/workflows/sdd/workflow.yml` |
| [sdd-remote-workflow.yml](./spec-kit/sdd-remote-workflow.yml) | Laptop + remote handoff → `.specify/workflows/sdd-remote/workflow.yml` |
| [workflow-registry.template.json](./spec-kit/workflow-registry.template.json) | Registry: `sdd` + `sdd-remote` only |
| [orchestrator.json](./spec-kit/orchestrator.json) | Repo policy for ctl (`gate_mode`, `implement_hooks`, …) |
| [extensions.yml.template](./spec-kit/extensions.yml.template) | Post-phase hooks |
| [agent-context-config.yml.template](./spec-kit/agent-context-config.yml.template) | Target rule file for SPECKIT block |
| [phase-exits-template.md](./spec-kit/phase-exits-template.md) | Append-only binary gate log (orchestrator writes) |
| [confidence-template.md](./spec-kit/confidence-template.md) | Terminal confidence report |
| [confidence-checks-template.md](./spec-kit/confidence-checks-template.md) | Effort checks drafted at plan |
| [plan-template-confidence-section.patch](./spec-kit/plan-template-confidence-section.patch) | Merge into managed `plan-template.md` |
| [deprecated-aliases.md](./spec-kit/deprecated-aliases.md) | Flag mapping for removed workflow IDs |
| [init-checklist.md](./spec-kit/init-checklist.md) | Short bootstrap checklist → [../specify/bootstrap.md](../specify/bootstrap.md) |
| [sdd-user-guide.template.md](./spec-kit/sdd-user-guide.template.md) | Repo `docs/agents/SDD_USER_GUIDE.md` (synced from gold) |
| [constitution-bootstrap-prompt.md](./spec-kit/constitution-bootstrap-prompt.md) | Compile constitution from rules |
| [specify-rules-override.mdc](./spec-kit/specify-rules-override.mdc) | Glob-gated SDD rule |

Replace `{LINT_CMD}`, `{TEST_CMD}`, `{CONTEXT_FILE}` after copy when present. **Exemplar (meeting_notes):** `uv run ruff check` and `doppler run -- uv run python -m pytest tests/ -x -q`.

## Skills & rules

| Path | Purpose |
|------|---------|
| [skills/sdd-entry/](./skills/sdd-entry/) | Chat front door (Start/Continue SDD) |
| [skills/speckit-confidence/](./skills/speckit-confidence/) | Terminal reflect-and-loop phase |
| [skills/speckit-confidence-improve/](./skills/speckit-confidence-improve/) | Human-gated harness improvement proposals |
| [skills/speckit-agent-context-update/](./skills/speckit-agent-context-update/) | Agent-context extension wrapper |
| [skills/speckit-managed-deltas.md](./skills/speckit-managed-deltas.md) | Re-apply Phase Exit Gate deltas after Spec Kit upgrade |
| [rules/sdd-orchestrator-snippet.mdc](./rules/sdd-orchestrator-snippet.mdc) | Merge into repo orchestrator |
| Core `*.mdc` in this folder | Project rules starters |

## Global machine (`global/`)

| Path | Purpose |
|------|---------|
| [global/hooks.json](./global/hooks.json) + [hooks/](./global/hooks/) | Skill router `beforeSubmitPrompt` |
| [global/rules/](./global/rules/) | Always-on cross-repo safety rules |

Install ctl via [../day1-setup.md](../day1-setup.md) — do not copy from another laptop as the primary path.

## Hooks (project security)

[hooks/](./hooks/) — detect-secrets, block-no-verify, block-sensitive-reads, refresh-compact-context.

**SDD progress:** apply [hooks/refresh-compact-context-sdd.patch](./hooks/refresh-compact-context-sdd.patch) to your repo's `refresh-compact-context.sh` when present.
