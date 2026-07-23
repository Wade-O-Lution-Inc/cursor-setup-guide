# Managed vs custom — what you can change

## Mental model

| Layer | Owned by | Upgrade risk |
|-------|----------|--------------|
| `specify` CLI | Upstream Spec Kit | `specify self upgrade` |
| Hash-tracked managed files | Spec Kit manifests | `specify integration upgrade --force` may overwrite |
| Org workflows / custom skills / constitution / repo policy | You (product repo) | Safe; not in upstream manifest |
| Global orchestrator ctl | [sdd-orchestrator](https://github.com/Wade-O-Lution-Inc/sdd-orchestrator) | `git pull` in `~/.cursor/sdd-orchestrator-ctl` |
| This guide’s templates | Adoption copies | Sync from meeting_notes — [SYNC.md](../../templates/SYNC.md) |

## Manifest-tracked (managed)

### `cursor-agent` integration (skills)

Tracked under `.cursor/skills/`:

`speckit-specify`, `clarify`, `plan`, `tasks`, `analyze`, `implement`, `constitution`, `checklist`, `taskstoissues`

Gold (meeting_notes) may show `specify integration status` **WARNING** for org Phase Exit Gate edits on managed skills — expected. Workers must **not** write `phase-exits.md`; the orchestrator does.

### Shared `speckit` infrastructure

Scripts + templates under `.specify/`. Org often patches `plan-template.md` (Confidence Checks). After upstream bumps:

```bash
specify integration status
specify integration upgrade --force   # review diffs first
# Re-apply org deltas — [speckit-managed-deltas.md](../../templates/skills/speckit-managed-deltas.md)
```

## Fully custom (safe to own)

| Asset | Notes |
|-------|-------|
| `.specify/workflows/sdd/`, `sdd-remote/` | Local registry — [workflow-registry.template.json](../../templates/spec-kit/workflow-registry.template.json) |
| `.specify/orchestrator.json` | Repo policy for ctl — [orchestrator.json](../../templates/spec-kit/orchestrator.json) |
| `.cursor/skills/sdd-entry/` | Chat front door — [templates/skills/sdd-entry/](../../templates/skills/sdd-entry/) |
| `speckit-confidence`, `speckit-confidence-improve`, `speckit-agent-context-update` | Not in Spec Kit manifest |
| `remote-agent-handoff` | Mini ops — copy from meeting_notes if needed |
| `.specify/memory/constitution.md` | Compiled from rules |
| Orchestrator snippet / `specify-rules.mdc` | Repo harness |
| `.specify/templates/phase-exits-template.md`, `confidence-*.md` | Org-added |
| `.specify/extensions.yml`, `agent-context-config.yml` | Hook wiring |
| `~/.cursor/sdd-orchestrator-ctl` | Clone of GitHub; not product git |

## Customization surfaces

| Want to change… | Edit |
|-----------------|------|
| Flags / stop points / remote flow | Workflow YAML + registry |
| Lint/test commands | Workflow shells **and** `.specify/orchestrator.json` `implement_hooks` |
| Auto-continue vs pause-after-pass | `gate_mode` in `.specify/orchestrator.json` |
| Phase order / quality bars | Constitution + orchestrator snippet + `sdd-entry` |
| Binary exit criteria | Phase sections in `speckit-*` + ctl `checklists/` |
| Models / swarms / shadow_rate / repair_cap | ctl `phase-models.json` (+ optional repo `phases` overrides) |
| Judge/worker/expert prompts | ctl `prompts/` |
| Agent context file target | `.specify/extensions/agent-context/agent-context-config.yml` |
| Chat discovery | Skill `description` + global skill router keywords |

## Do not fork / do not enable casually

- Spec Kit CLI / manifest hash scheme  
- Daily use of upstream `speckit` workflow  
- Letting `confidence-improve` auto-edit skills or constitution  
- Treating `specs/` as durable product docs or Agent OS memory  
- Vendoring a second copy of the orchestrator into a product repo  

Shadow / epsilon / swarm knobs: follow the **live** ctl README after `git pull` — do not freeze stale “Slice D GO” folklore from old guide revisions.

## Global stub pattern

```
~/.cursor/skills/speckit-plan/SKILL.md   # stub: "read meeting_notes_workflow/.../speckit-plan"
meeting_notes_workflow/.cursor/skills/speckit-plan/SKILL.md  # canonical body
```

Next: [bootstrap.md](./bootstrap.md) · [troubleshooting.md](./troubleshooting.md)
