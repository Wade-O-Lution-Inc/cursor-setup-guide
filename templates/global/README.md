# Global harness templates

Copy onto a developer machine under `~/.cursor/`:

| Source | Destination |
|--------|-------------|
| `hooks.json` | `~/.cursor/hooks.json` |
| `hooks/*.sh` | `~/.cursor/hooks/` (`chmod +x`) |
| `rules/*.mdc` | `~/.cursor/rules/` |

**Live skill auto-routing** uses `~/.cursor/hooks/workspace-skill-router.sh` on that machine. Updating these templates in git does not change other laptops until they re-copy — see [../../global-env.md](../../global-env.md#live-routing-is-per-machine-team-must-refresh).

Also install (not vendored here):

```bash
gh repo clone Wade-O-Lution-Inc/sdd-orchestrator ~/.cursor/sdd-orchestrator-ctl
python3 ~/.cursor/sdd-orchestrator-ctl/bin/sdd-ctl sync
python3 ~/.cursor/sdd-orchestrator-ctl/bin/sdd-ctl preflight
```

Plus ops skills (`lab-host-ssh`, …) and Spec Kit pointer stubs as needed.

See [../../day1-setup.md](../../day1-setup.md) · [../../global-env.md](../../global-env.md).
