# Managed vs custom — what you can change

## Mental model

| Layer | Owned by | Upgrade risk |
|-------|----------|--------------|
| `specify` CLI | Upstream Spec Kit | `specify self upgrade` |
| Hash-tracked managed files | Spec Kit manifests | `specify integration upgrade --force` may overwrite |
| Org workflows / custom skills / constitution content | You | Safe; not in upstream manifest |
| Global orchestrator ctl | You (machine) | Not in repo; sync machines deliberately |

## Manifest-tracked (managed)

### `cursor-agent` integration (skills)

Tracked under `.cursor/skills/`:

`speckit-specify`, `clarify`, `plan`, `tasks`, `analyze`, `implement`, `constitution`, `checklist`, `taskstoissues`

**Currently modified in meeting_notes (expected WARNING):** specify, clarify, plan, tasks, analyze, implement — Phase Exit Gate sections + confidence-checks drafting / effort-check mapping / implement micro-gates.

### Shared `speckit` infrastructure

Scripts + templates under `.specify/`. **Modified:** `.specify/templates/plan-template.md` (Confidence Checks draft section).

```bash
specify integration status          # WARNING with modified_managed_files is OK for reference repo
# After upstream bump:
specify integration upgrade --force
# Then re-apply org deltas (phase exits, confidence-checks, plan section)
```

## Fully custom (safe to own)

| Asset | Notes |
|-------|-------|
| `.specify/workflows/sdd/`, `sdd-remote/` (+ aliases) | Local registry entries |
| `.cursor/skills/sdd-entry/` | Chat front door |
| `speckit-confidence`, `speckit-confidence-improve` | Not in Spec Kit manifest |
| `speckit-agent-context-update` | Wrapper over extension |
| `remote-agent-handoff` | Mini ops |
| `.specify/templates/phase-exits-template.md`, `confidence-checks-template.md` | Org-added |
| `.specify/memory/constitution.md` | Compiled from rules |
| `.specify/extensions.yml` | Hook wiring |
| `.cursor/rules/00-orchestrator.mdc` SDD block, `specify-rules.mdc` | Repo harness |
| `~/.cursor/sdd-orchestrator*` | Global control plane |
| Global `speckit-*` **stubs** | Pointers only |

## Customization surfaces (without forking Spec Kit)

| Want to change… | Edit |
|-----------------|------|
| Flags / stop points / remote flow | Workflow YAML + registry |
| Lint/test commands | `{LINT_CMD}` / `{TEST_CMD}` in workflow shells |
| Phase order / quality bars | Constitution + orchestrator snippet + `sdd-entry` |
| Binary exit criteria | Phase sections in `speckit-*` skills + orchestrator checklists |
| Models / hard vs soft gates | `~/.cursor/sdd-orchestrator-ctl/phase-models.json` |
| Judge/worker prompts | `sdd-orchestrator-ctl/prompts/` |
| Agent context file target | `.specify/extensions/agent-context/agent-context-config.yml` |
| Post-phase prompts | `.specify/extensions.yml` |
| Chat discovery | Skill `description` + global skill router keywords |
| Presets | `.specify/presets/` (upstream catalog cached; local presets optional) |

## Do not fork / do not enable casually

- Spec Kit CLI / manifest hash scheme  
- Daily use of upstream `speckit` workflow  
- Orchestrator `shadow` / `epsilon` without Slice D GO  
- Letting `confidence-improve` auto-edit skills or constitution  
- Treating `specs/` as durable product docs or Agent OS memory  

## Global stub pattern

```
~/.cursor/skills/speckit-plan/SKILL.md   # stub: "read meeting_notes_workflow/.../speckit-plan"
meeting_notes_workflow/.cursor/skills/speckit-plan/SKILL.md  # canonical body
```

Keeps router discovery working across workspaces without duplicating large managed files.

Next: [bootstrap.md](./bootstrap.md) · [troubleshooting.md](./troubleshooting.md)
