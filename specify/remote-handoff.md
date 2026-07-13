# Remote handoff (Mac mini)

Use when implement/confidence loops would keep a laptop awake. Laptop still owns gated specify → clarify → plan → tasks.

## Workflow

```bash
specify workflow run sdd-remote \
  -i spec="Your feature" \
  -i integration=cursor-agent \
  -i remote_phase=implement \
  -i interval=600

# Already past tasks:
specify workflow run sdd-remote \
  -i transfer_only=true \
  -i remote_phase=confidence \
  -i interval=600
```

| Step | Where | Action |
|------|-------|--------|
| 1 | Laptop | Orchestrated phases through **review-tasks** (unless `transfer_only`) |
| 2 | Laptop | Approve **approve-transfer** gate |
| 3 | Mini | Headless loop via handoff scripts / `nohup` |
| 4 | Anywhere | `bash scripts/handoff_to_mac_mini.sh --status` |
| 5 | Laptop | `git pull` + read `.cursor/session-handoff.md` |

## Repo skill + scripts

| Asset | Role |
|-------|------|
| `.cursor/skills/remote-agent-handoff/SKILL.md` | Procedure + Doppler `mac_mini` / `CURSOR_API_KEY` |
| `scripts/remote_agent_preflight.sh` | `--local` / `--remote` checks |
| `scripts/handoff_to_mac_mini.sh` | Push branch, start/stop/status |
| `scripts/remote_agent_loop.sh` | Tick loop on mini (`--resume`) |
| `scripts/start_remote_sdd_handoff.sh` | Invoked by workflow shell step |

Runtime on mini (gitignored): `.cursor/remote-agent.pid`, `.cursor/remote-agent-state.json`, `.cursor/session-handoff.md`, `logs/remote-agent.log`.

## Auth

- Remote Cursor agent: **`CURSOR_API_KEY`** in Doppler config `mac_mini` (subscription key)
- App secrets for eval scripts the agent may run: separate Doppler keys — do not conflate

## Customization

| Knob | How |
|------|-----|
| Tick interval / phase / model | `sdd-remote` inputs |
| Preflight checks | Edit `remote_agent_preflight.sh` |
| What runs on mini | `remote_phase` + loop prompt in handoff skill |

Do **not** `scp` application trees to the mini — git pull only.

Next: [workflows.md](./workflows.md) · [orchestrator.md](./orchestrator.md)
