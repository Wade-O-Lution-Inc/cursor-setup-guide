# Troubleshooting

## `specify integration status` shows WARNING

**Expected** on meeting_notes while org edits to managed `speckit-*` skills / `plan-template.md` remain. Before `specify integration upgrade --force`, diff those files and re-apply Phase Exit Gate deltas ([speckit-managed-deltas.md](../templates/skills/speckit-managed-deltas.md)).

## Workflow paused

```bash
specify workflow status
specify workflow resume <run_id>
```

Reject on a Spec Kit YAML gate **aborts** the run (per `on_reject: abort`). Orchestrator-level failures at repair cap **stop** without a workflow resume — fix the phase and Continue / re-run.

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

Or fix in chat with Continue → implement/confidence under orchestrator. Ensure `.specify/orchestrator.json` has matching `implement_hooks` + `allow_repo_commands: true`.

## Remote loop won’t start

```bash
bash scripts/remote_agent_preflight.sh --remote
```

Usual causes: missing `CURSOR_API_KEY` in Doppler `mac_mini`; handoff **Resume Prompt** does not name `specs/NNN-*`; Mac mini Actions runner offline.

## Orchestrator / JSONL / phase-exits missing

- Only **`sdd-ctl record`** writes `phase-exits.md`  
- Runlog: `.specify/orchestrator-runs/*.jsonl` in the **product repo** (gitignored)  
- Confirm symlink `~/.cursor/skills/sdd-orchestrator` → ctl skill  
- Confirm ctl exists: `python3 ~/.cursor/sdd-orchestrator-ctl/bin/sdd-ctl plan-phase --help`  
- Update ctl: `git -C ~/.cursor/sdd-orchestrator-ctl pull --ff-only`

## `sdd-ctl record` returns exit 3

Action was `stop` (repair cap exhausted). Read the printed JSON / report; fix evidence; re-run the phase with a fresh repair counter only after a recorded pass or a new feature phase.

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
- [ ] Expecting per-phase hard-gate pauses from the orchestrator (default is auto-continue)  
- [ ] Copying ctl from another machine instead of cloning GitHub  
- [ ] `scp` to Mac mini instead of git pull  
- [ ] Committing `.specify/workflows/runs/` or `.specify/orchestrator-runs/`  
- [ ] Putting secrets in skills or this guide  

Next: [quick-start.md](./quick-start.md) · [managed-vs-custom.md](./managed-vs-custom.md)
