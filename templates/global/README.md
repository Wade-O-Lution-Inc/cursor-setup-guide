# Global harness templates

Copy onto a developer machine under `~/.cursor/`:

| Source | Destination |
|--------|-------------|
| `hooks.json` | `~/.cursor/hooks.json` |
| `hooks/*.sh` | `~/.cursor/hooks/` (`chmod +x`) |
| `rules/*.mdc` | `~/.cursor/rules/` |

Also install (not vendored here):

```bash
gh repo clone Wade-O-Lution-Inc/sdd-orchestrator ~/.cursor/sdd-orchestrator-ctl
ln -sfn ~/.cursor/sdd-orchestrator-ctl/skills/sdd-orchestrator ~/.cursor/skills/sdd-orchestrator
```

Plus ops skills (`lab-host-ssh`, …) and Spec Kit pointer stubs as needed.

See [../../day1-setup.md](../../day1-setup.md) · [../../global-env.md](../../global-env.md).
