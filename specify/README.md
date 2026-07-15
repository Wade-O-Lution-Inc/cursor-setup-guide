# Specify Workflow & Customizations

This section is the **canonical documentation** for how Wade-O-Lution uses GitHub [Spec Kit](https://github.com/github/spec-kit) (`specify` CLI v0.10.2) — what upstream gives you, what we customized, and what you can still change.

**Live reference implementation:** [meeting_notes_workflow](https://github.com/Wade-O-Lution-Inc/meeting_notes_workflow) (branch `staging`).

**Copy-paste templates:** [../templates/spec-kit/](../templates/spec-kit/) and [../templates/skills/](../templates/skills/) — synced from meeting_notes SDD harness v2.0.0.

| Doc | Read when |
|-----|-----------|
| [overview.md](./overview.md) | What Spec Kit is vs our layers |
| [quick-start.md](./quick-start.md) | Daily Start/Continue + CLI one-liners |
| [bootstrap.md](./bootstrap.md) | Adopting SDD in a new repo / machine |
| [phase-model.md](./phase-model.md) | Phases, artifacts, exit gates vs confidence |
| [workflows.md](./workflows.md) | `sdd` / `sdd-remote` flags, gates, aliases |
| [orchestrator.md](./orchestrator.md) | Always-on multi-model phase router |
| [remote-handoff.md](./remote-handoff.md) | Mac mini implement/confidence loops |
| [confidence-loop.md](./confidence-loop.md) | Terminal scoring + learning log |
| [managed-vs-custom.md](./managed-vs-custom.md) | What you can change; upgrade warnings |
| [troubleshooting.md](./troubleshooting.md) | Status WARNING, resume, anti-patterns |

## Template inventory (canonical)

| Category | Files in `templates/` |
|----------|----------------------|
| Workflows | `sdd-workflow.yml`, `sdd-remote-workflow.yml`, `workflow-registry.template.json` |
| Hooks wiring | `extensions.yml.template`, `agent-context-config.yml.template` |
| Artifacts | `phase-exits-template.md`, `confidence-template.md`, `confidence-checks-template.md` |
| Skills | `sdd-entry`, `speckit-confidence`, `speckit-confidence-improve`, `speckit-agent-context-update` |
| Managed deltas | `speckit-managed-deltas.md`, `plan-template-confidence-section.patch` |
| Rules | `specify-rules-override.mdc`, `sdd-orchestrator-snippet.mdc` |
| User guide | `sdd-user-guide.template.md` |

When meeting_notes harness changes materially, sync templates here before claiming org canonicalization is current.

Related (non-specify): [../global-env.md](../global-env.md) · [../scope.md](../scope.md) · [../templates/README.md](../templates/README.md)
