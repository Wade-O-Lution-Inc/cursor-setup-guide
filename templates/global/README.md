# Global harness templates

Copy onto a developer machine under `~/.cursor/`:

| Source | Destination |
|--------|-------------|
| `hooks.json` | `~/.cursor/hooks.json` |
| `hooks/*.sh` | `~/.cursor/hooks/` (`chmod +x`) |
| `rules/*.mdc` | `~/.cursor/rules/` |

Also install (not fully vendored here — large / evolving):

- `~/.cursor/skills/sdd-orchestrator/`
- `~/.cursor/sdd-orchestrator-ctl/`
- Ops skills (`lab-host-ssh`, …) and Spec Kit pointer stubs as needed

See [../../global-env.md](../../global-env.md).
