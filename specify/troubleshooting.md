# Troubleshooting

## `specify integration status` shows WARNING

**Expected** on meeting_notes while org edits to managed `speckit-*` skills / `plan-template.md` remain. Counts (live reference): 6 cursor-agent skills + 1 plan template modified; 0 missing.

Before `specify integration upgrade --force`, diff those files and plan to re-apply Phase Exit Gate / confidence-checks deltas.

## Workflow paused

```bash
specify workflow status
specify workflow resume <run_id>
```

Reject on a gate **aborts** the run (per YAML `on_reject: abort`).

## Agent jumped straight to `speckit-specify`

Chat front door must be **`sdd-entry`**. Confirm:

1. Global skill router fired (`MANDATORY SKILL ROUTING` lists `sdd-entry` + `sdd-orchestrator`)
2. Orchestrator rule SDD block matches [../templates/rules/sdd-orchestrator-snippet.mdc](../templates/rules/sdd-orchestrator-snippet.mdc)
3. You said `Start SDD` / `Continue SDD` (or Spec this feature)

## Skipped clarify / implemented without tasks

Constitution + `sdd-entry` forbid this. Say `Continue SDD` and name the correct phase; do not “just implement.”

## Tests fail after implement

```bash
specify workflow run sdd -i spec="Continue from tasks.md" -i mode=test-fix
```

Or fix in chat with Continue → implement/confidence under orchestrator.

## Remote loop won’t start

```bash
bash scripts/remote_agent_preflight.sh --remote
```

Usual cause: missing `CURSOR_API_KEY` in Doppler `mac_mini`.

## Orchestrator / JSONL / phase-exits missing

- Task path writes `phase-exits.md` after verdict validation  
- SDK `sdd-run` logs JSONL under `~/.cursor/sdd-orchestrator-ctl/runs/`; it may not write `phase-exits.md` (known path split — prefer Task path in chat for exits)  
- Confirm `~/.cursor/skills/sdd-orchestrator/SKILL.md` and ctl dir exist  

## Wrong `scope` enum

Upstream `speckit` uses `backend-only`. Org standard is **`api-only`**. Use `sdd`, not `speckit`.

## Context full mid-feature

```
compact
```

Handoff should include `tasks.md` progress (completed/total). Resume with `Continue SDD`.

## Anti-patterns checklist

- [ ] Bare `speckit-*` as chat entry  
- [ ] Using upstream `speckit` workflow for product work  
- [ ] Enabling shadow/epsilon without Slice D GO  
- [ ] `scp` to Mac mini instead of git pull  
- [ ] Committing `.specify/workflows/runs/` or presets cache  
- [ ] Putting secrets in skills or this guide  

Next: [quick-start.md](./quick-start.md) · [managed-vs-custom.md](./managed-vs-custom.md)
