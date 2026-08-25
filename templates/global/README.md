# Global templates → `~/.cursor/`

```bash
cd /path/to/cursor-setup-guide
./bin/cursor-setup install-global
./bin/cursor-setup refresh-global   # after router / global-hook PRs
./bin/cursor-setup doctor
```

| Source | Destination |
|--------|-------------|
| `hooks.json` | `~/.cursor/hooks.json` (router + `sdd-specify-preflight`) |
| `hooks/*.sh` | `~/.cursor/hooks/` (executable) |
| `rules/*.mdc` | `~/.cursor/rules/` |

Also clone ctl (if missing):

```bash
gh repo clone Wade-O-Lution-Inc/sdd-orchestrator ~/.cursor/sdd-orchestrator-ctl
python3 ~/.cursor/sdd-orchestrator-ctl/bin/sdd-ctl sync
```

**Team-wide until Cursor fixes Default marketplace import:** every named seat runs `install-global` from this guide — [team-marketplace.md](../../docs/team-marketplace.md#team-wide-path-until-cursor-fixes-default).

Docs: [../../docs/day1.md](../../docs/day1.md) · [../../docs/ownership.md](../../docs/ownership.md#machine-scope-cursor)
