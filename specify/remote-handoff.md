# Remote handoff (Mac mini)

Use when implement/confidence loops would keep a laptop awake. Laptop still owns specify → clarify → plan → tasks (orchestrated).

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
| 1 | Laptop | Orchestrated phases through tasks (unless `transfer_only`) |
| 2 | Laptop | Approve transfer if the workflow still defines a YAML gate |
| 3 | Mini | Headless loop via handoff scripts / `nohup` |
| 4 | Anywhere | `bash scripts/handoff_to_mac_mini.sh --status` |
| 5 | Laptop | `git pull` + read `.cursor/session-handoff.md` |

## Resume Prompt (required)

SDD modes on the mini **must not** guess a specs directory (`find specs/…`). The handoff’s `## Resume Prompt` must name the exact feature, e.g.:

```
Continue specs/053-my-feature through the sdd-orchestrator implement phase.
```

Without that, `scripts/remote_agent_loop.sh` fails closed for `sdd-implement` / `sdd-confidence`.

## Repo skill + scripts

| Asset | Role |
|-------|------|
| `.cursor/skills/remote-agent-handoff/SKILL.md` | Procedure + Doppler `mac_mini` / `CURSOR_API_KEY` |
| `scripts/remote_agent_preflight.sh` | `--local` / `--remote` checks |
| `scripts/handoff_to_mac_mini.sh` | Push branch, start/stop/status |
| `scripts/remote_agent_loop.sh` | Tick loop on mini (`--resume`) |
| `scripts/start_remote_sdd_handoff.sh` | Invoked by workflow shell step |

Runtime on mini (gitignored): `.cursor/remote-agent.pid`, `.cursor/remote-agent-state.json`, `.cursor/session-handoff.md`, `logs/remote-agent.log`.

Mini also needs `~/.cursor/sdd-orchestrator-ctl` (clone of [sdd-orchestrator](https://github.com/Wade-O-Lution-Inc/sdd-orchestrator)) and a working self-hosted Actions runner for pipeline Mac mini gates.

## Auth

- Remote Cursor agent: **`CURSOR_API_KEY`** in Doppler config `mac_mini` (subscription key)
- App secrets for eval scripts the agent may run: separate Doppler keys — do not conflate

## Customization

| Knob | How |
|------|-----|
| Tick interval / phase / model | `sdd-remote` inputs |
| Preflight checks | Edit `remote_agent_preflight.sh` |
| What runs on mini | `remote_phase` + Resume Prompt + orchestrator |

Do **not** `scp` application trees to the mini — git pull only.

Next: [workflows.md](./workflows.md) · [orchestrator.md](./orchestrator.md)
