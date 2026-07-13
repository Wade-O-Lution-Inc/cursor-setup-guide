# Quick start

**Keep this open** while running SDD. Live copy in meeting_notes: `docs/agents/SDD_USER_GUIDE.md`.

## Chat (daily default)

```
Start SDD: <what and why — no tech stack yet>
Continue SDD
I've reviewed spec.md — proceed to plan
Revise spec: <feedback>
compact
Stop SDD; switch to normal fix mode for <narrow bug>
```

Optional natural-language flags: `scope=api`, `stop at plan`, `emit issues`, `remote after tasks`, `test-fix mode`.

Flow: **`sdd-entry` → `sdd-orchestrator` → `speckit-*` worker**.

## CLI

```bash
# Status
specify integration status
specify workflow list          # expect sdd + sdd-remote (+ deprecated aliases)

# Full local cycle
specify workflow run sdd -i spec="..." -i integration=cursor-agent \
  -i scope=full -i stop_at=confidence -i issues=false -i mode=full

# Stop early (RFC-style)
specify workflow run sdd -i spec="..." -i stop_at=plan

# Issues only
specify workflow run sdd -i spec="..." -i issues=true -i stop_at=tasks

# Test-fix finish
specify workflow run sdd -i spec="..." -i mode=test-fix

# Laptop → Mac mini
specify workflow run sdd-remote -i spec="..." -i remote_phase=implement -i interval=600

# Transfer only (already past tasks)
specify workflow run sdd-remote -i transfer_only=true -i remote_phase=confidence -i interval=600

# While paused at a gate
specify workflow status
specify workflow resume <run_id>

# Headless Continue (global)
~/.cursor/sdd-orchestrator-ctl/bin/sdd-run \
  --cwd /path/to/repo --feature-dir specs/NNN-name \
  --from-phase specify --to-phase tasks
```

## Flags at a glance

| Flag | Workflow | Values | Meaning |
|------|----------|--------|---------|
| `scope` | `sdd`, `sdd-remote` | `full` \| `api-only` \| `frontend-only` | Allowed layers |
| `stop_at` | `sdd` | `confidence` \| `tasks` \| `plan` | Early exit |
| `issues` | `sdd` | `true` \| `false` | Emit GitHub issues after tasks, then stop |
| `mode` | `sdd` | `full` \| `test-fix` | Skip to implement + pytest retry + confidence |
| `transfer_only` | `sdd-remote` | `true` \| `false` | Skip laptop specify→tasks |
| `remote_phase` | `sdd-remote` | `implement` \| `confidence` \| `test-fix` | Mini loop entry |
| `interval` | `sdd-remote` | seconds (default `600`) | Tick spacing on mini |
| `model` | `sdd-remote` | Cursor model id | Optional override |
| `integration` | both | `cursor-agent` / `auto` | Agent integration |

## Deprecated aliases → flags

| Old ID | Use instead |
|--------|-------------|
| `sdd-full` | `sdd` |
| `sdd-api` | `sdd -i scope=api-only` |
| `sdd-rfc` | `sdd -i stop_at=tasks` (or `plan`) |
| `sdd-test-fix` | `sdd -i mode=test-fix` |
| `sdd-issues` | `sdd -i issues=true -i stop_at=tasks` |
| `sdd-full-remote` | `sdd-remote` |
| `sdd-remote-handoff` | `sdd-remote -i transfer_only=true` |

Upstream workflow **`speckit`**: installed, not for daily use.

Next: [workflows.md](./workflows.md) · [phase-model.md](./phase-model.md)
