# Specify Workflow & Customizations

Canonical documentation for how Wade-O-Lution uses GitHub [Spec Kit](https://github.com/github/spec-kit) (`specify` CLI v0.13.0) — what upstream gives you, what we customized, and what you can still change.

| Source of truth | Link |
|-----------------|------|
| Live product harness | [meeting_notes_workflow](https://github.com/Wade-O-Lution-Inc/meeting_notes_workflow) |
| Orchestrator runtime | [sdd-orchestrator](https://github.com/Wade-O-Lution-Inc/sdd-orchestrator) |
| Copy-paste templates | [../templates/](../templates/) — [SYNC.md](../templates/SYNC.md) |
| Day-1 machine | [../day1-setup.md](../day1-setup.md) |

| Doc | Read when |
|-----|-----------|
| [overview.md](./overview.md) | What Spec Kit is vs our layers |
| [quick-start.md](./quick-start.md) | Daily Start/Continue + CLI one-liners |
| [bootstrap.md](./bootstrap.md) | Adopting SDD in a new repo / machine |
| [phase-model.md](./phase-model.md) | Phases, artifacts, exit gates vs confidence |
| [workflows.md](./workflows.md) | `sdd` / `sdd-remote` flags and gates |
| [orchestrator.md](./orchestrator.md) | `sdd-ctl`, auto-continue, swarms |
| [remote-handoff.md](./remote-handoff.md) | Mac mini implement/confidence loops |
| [confidence-loop.md](./confidence-loop.md) | Terminal scoring + learning log |
| [managed-vs-custom.md](./managed-vs-custom.md) | What you can change; upgrade warnings |
| [troubleshooting.md](./troubleshooting.md) | Status WARNING, resume, anti-patterns |

## Template inventory

| Category | Files in `templates/` |
|----------|----------------------|
| Workflows | `sdd-workflow.yml`, `sdd-remote-workflow.yml`, `workflow-registry.template.json` |
| Repo policy | `orchestrator.json` |
| Hooks wiring | `extensions.yml.template`, `agent-context-config.yml.template` |
| Artifacts | `phase-exits-template.md`, `confidence-template.md`, `confidence-checks-template.md` |
| Skills | `sdd-entry`, `speckit-confidence`, `speckit-confidence-improve`, `speckit-agent-context-update` |
| Managed deltas | `speckit-managed-deltas.md`, `plan-template-confidence-section.patch` |
| Rules | `specify-rules-override.mdc`, `sdd-orchestrator-snippet.mdc` |
| User guide | `sdd-user-guide.template.md` |
| Alias migration | `deprecated-aliases.md` |

Related: [../global-env.md](../global-env.md) · [../scope.md](../scope.md) · [../templates/README.md](../templates/README.md)
