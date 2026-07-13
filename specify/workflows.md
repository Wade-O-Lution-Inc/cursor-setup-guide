# Workflows reference

Definitions live in the consuming repo under `.specify/workflows/<id>/workflow.yml`. Org templates: [../templates/spec-kit/sdd-workflow.yml](../templates/spec-kit/sdd-workflow.yml), [sdd-remote-workflow.yml](../templates/spec-kit/sdd-remote-workflow.yml).

## Canonical IDs

### `sdd` (local)

**Full path (`mode=full`):**

1. `speckit.specify` (orchestrator) → **review-spec** gate  
2. `speckit.clarify`  
3. `speckit.plan` → **review-plan** gate  
4. If `stop_at=plan` → done prompt (no implement)  
5. Else `speckit.tasks` → `speckit.analyze` → **review-tasks** gate  
6. If `issues=true` → `speckit.taskstoissues` → stop  
7. Else if `stop_at=tasks` → done prompt  
8. Else lint (`continue_on_error`) → `speckit.implement` → pytest → `speckit.confidence` → handoff prompt  

**Test-fix path (`mode=test-fix`):** implement → pytest → while fail (max 5) fix+retest → confidence → handoff.

Every `speckit.*` command step includes the ALWAYS-ON ORCHESTRATOR preamble pointing at `~/.cursor/skills/sdd-orchestrator/SKILL.md`.

### `sdd-remote`

| Branch | Behavior |
|--------|----------|
| `transfer_only=false` | Laptop: same gated path through **review-tasks**, then **approve-transfer**, then shell handoff to Mac mini |
| `transfer_only=true` | Skip laptop phases; handoff only |

Inputs: `remote_phase`, `interval`, `model`, `scope`, optional `spec`.

Pairs with repo skill `remote-agent-handoff` and scripts under `scripts/handoff_to_mac_mini.sh`, `scripts/start_remote_sdd_handoff.sh`, etc. Details: [remote-handoff.md](./remote-handoff.md).

## Human gates vs orchestrator gates

| Gate | Mechanism | Resume |
|------|-----------|--------|
| `review-spec` / `review-plan` / `review-tasks` / `approve-transfer` | Spec Kit workflow `type: gate` | `specify workflow resume <run_id>` |
| Orchestrator `gate: hard` | After judge pass | Human go/no-go in chat (Task path) |
| Orchestrator `gate: soft` | After judge pass | Auto-continue to next phase |

## Upstream `speckit` workflow

Installed by `specify init`. Four phases, no clarify/analyze/confidence, no orchestrator preamble, `scope` uses `backend-only` (we use `api-only`). **Do not document it for daily use.**

## Deprecated aliases

Still registered in meeting_notes `workflow-registry.json` with `DEPRECATED` descriptions. Prefer flags on `sdd` / `sdd-remote` ([quick-start.md](./quick-start.md)).

## Run state

Gitignored: `.specify/workflows/runs/<run_id>/` (`workflow.yml`, `inputs.json`, `state.json`, `log.jsonl`).

```bash
specify workflow status
specify workflow resume <run_id>
```

Next: [quick-start.md](./quick-start.md) · [remote-handoff.md](./remote-handoff.md)
