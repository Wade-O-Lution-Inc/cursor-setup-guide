# Product templates → `repo/.cursor/`

```bash
./bin/cursor-setup scaffold-repo /path/to/repo
```

| Path | Notes |
|------|-------|
| `*.mdc` | Pedagogy starters → `.cursor/rules/` (**not** MNW gold names — see docs/ownership.md) |
| `rules/sdd-orchestrator-snippet.mdc` | Merge when adopting SDD |
| `hooks.json` | Security trio + compact-context refresh |
| `hooks/*.sh` | Scripts for those events |
| `hooks/orchestrator-pre-shell.sh` | **Optional** — not wired in default `hooks.json` |
| `hooks/orchestrator-post-tool.sh` | **Optional** — wire like MNW gold when needed |
| `mcp.json` | Placeholder |
| `example-skill/`, `search-first-skill/` | Pedagogy only — not required in production |

Edit `project.mdc` before committing. Docs: [../../docs/product-repo.md](../../docs/product-repo.md).
