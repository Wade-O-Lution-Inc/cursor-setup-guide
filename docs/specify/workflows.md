# Workflows reference

Definitions live in the consuming repo under `.specify/workflows/<id>/workflow.yml`. Org templates: [../templates/spec-kit/sdd-workflow.yml](../../templates/spec-kit/sdd-workflow.yml), [sdd-remote-workflow.yml](../../templates/spec-kit/sdd-remote-workflow.yml).

Registered workflows in the gold repo: **`sdd`**, **`sdd-remote`**, plus upstream **`speckit`** (undocumented for daily use).

## Canonical IDs

### `sdd` (local)

Each named phase invokes the orchestrator in **`single_phase`** mode; this workflow owns sequencing and `stop_at`. Passing phases do **not** require a human go/no-go from the orchestrator — they auto-continue inside the workflow’s next step. Exhausted repair caps stop the run.

**Full path (`mode=full`):**

1. Orchestrator **specify** (optional Spec Kit human `review-spec` if present in YAML)  
2. **clarify** → **plan** (optional `review-plan`)  
3. Optional `model_profile=lean|balanced|frontier` (session override; default from repo policy / ctl)  
4. If `stop_at=plan` → end report (`sdd-ctl report`)  
4. Else **tasks** → **analyze** (optional `review-tasks`)  
5. If `issues=true` → `speckit.taskstoissues` → stop  
6. Else if `stop_at=tasks` → end report  
7. Else implement hooks / **implement** → **confidence** → end report  

**Test-fix path (`mode=test-fix`):** implement → pytest retry loop → confidence → end report.

Every `speckit.*` command step includes the ALWAYS-ON ORCHESTRATOR preamble pointing at `~/.cursor/skills/sdd-orchestrator/SKILL.md`.

### `sdd-remote`

| Branch | Behavior |
|--------|----------|
| `transfer_only=false` | Laptop: orchestrated path through tasks (and any YAML transfer gate), then shell handoff to Mac mini |
| `transfer_only=true` | Skip laptop phases; handoff only |

Inputs: `remote_phase`, `interval`, `model`, `scope`, optional `spec`.

Pairs with repo skill `remote-agent-handoff` and scripts under `scripts/handoff_to_mac_mini.sh`, `scripts/start_remote_sdd_handoff.sh`. Details: [remote-handoff.md](./remote-handoff.md).

## Human workflow gates vs orchestrator

| Gate | Mechanism | Resume |
|------|-----------|--------|
| Spec Kit `type: gate` steps (if any remain in YAML) | Workflow pause | `specify workflow resume <run_id>` |
| Orchestrator pass | `continue` / return to workflow | Automatic (default `gate_mode: automatic`) |
| Orchestrator fail under repair cap | `repair` | Automatic re-worker |
| Orchestrator fail at repair cap | `stop` | Human intervention |
| Orchestrator `gate_mode: interactive` | `pause` after pass | Human Continue |

## Upstream `speckit` workflow

Installed by `specify init`. Four phases, no clarify/analyze/confidence, no orchestrator preamble, `scope` uses `backend-only` (we use `api-only`). **Do not document it for daily use.**

## Deprecated aliases (migration only)

Removed from the meeting_notes registry. Prefer flags on `sdd` / `sdd-remote` — [deprecated-aliases.md](../../templates/spec-kit/deprecated-aliases.md) · [quick-start.md](./quick-start.md).

## Run state

Gitignored: `.specify/workflows/runs/<run_id>/`, `.specify/orchestrator-runs/`.

```bash
specify workflow status
specify workflow resume <run_id>
```

Next: [quick-start.md](./quick-start.md) · [remote-handoff.md](./remote-handoff.md)
