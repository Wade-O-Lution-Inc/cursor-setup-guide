# Global templates → `~/.cursor/`

```bash
cd /path/to/cursor-setup-guide
./bin/cursor-setup install-global
./bin/cursor-setup refresh-global   # after router PRs
./bin/cursor-setup doctor
```

| Source | Destination |
|--------|-------------|
| `hooks.json` | `~/.cursor/hooks.json` |
| `hooks/*.sh` | `~/.cursor/hooks/` (executable) |
| `rules/*.mdc` | `~/.cursor/rules/` |

Also clone ctl (if missing):

```bash
gh repo clone Wade-O-Lution-Inc/sdd-orchestrator ~/.cursor/sdd-orchestrator-ctl
python3 ~/.cursor/sdd-orchestrator-ctl/bin/sdd-ctl sync
```

Docs: [../../docs/day1.md](../../docs/day1.md) · [../../docs/ownership.md](../../docs/ownership.md#machine-scope-cursor)
