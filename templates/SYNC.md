# Template sync contract

**Gold sources (pull FROM):**

| Gold | Repo / path |
|------|-------------|
| Product harness | [meeting_notes_workflow](https://github.com/Wade-O-Lution-Inc/meeting_notes_workflow) (`main` / `staging`) |
| Orchestrator runtime | [sdd-orchestrator](https://github.com/Wade-O-Lution-Inc/sdd-orchestrator) — **not** vendored here; document install only |
| Machine router | `~/.cursor/hooks/workspace-skill-router*.sh` after local improvements |

**This guide:** adoption copies under `templates/`. Machine-readable map: [sync-manifest.json](./sync-manifest.json).

```bash
# Maintainer tool (not day-1)
./bin/cursor-setup sync-check --mnw /path/to/meeting_notes_workflow
```

After syncing `global/hooks/workspace-skill-router*.sh` into this repo, **tell the team to** `./bin/cursor-setup refresh-global` on each machine.

**Last synced:** 2026-07-22 (revamp: product/ tree, orchestrator hooks, on-demand global rules, sync-manifest)

## Path map

See `sync-manifest.json` `paths` array (authoritative for `sync-check`). Human summary:

| Template path | Gold path |
|---------------|-----------|
| `spec-kit/sdd*.yml`, registry, orchestrator.json, confidence template | MNW `.specify/…` |
| `spec-kit/sdd-user-guide.template.md` | MNW `docs/agents/SDD_USER_GUIDE.md` |
| `skills/sdd-entry`, confidence*, company-mcp | MNW `.cursor/skills/…` |
| `product/hooks/orchestrator-*.sh` | MNW `.cursor/hooks/…` |
| `global/hooks/workspace-skill-router*.sh` | `~/.cursor/hooks/…` |

Company MCP **deep guide** SSOT stays in MNW; this guide ships [../docs/company-mcp.md](../docs/company-mcp.md) as a thin pointer (not byte-synced).

## Resync commands

```bash
MNW=/path/to/meeting_notes_workflow
GUIDE=/path/to/cursor-setup-guide

cp "$MNW/.specify/workflows/sdd/workflow.yml" "$GUIDE/templates/spec-kit/sdd-workflow.yml"
cp "$MNW/.specify/workflows/sdd-remote/workflow.yml" "$GUIDE/templates/spec-kit/sdd-remote-workflow.yml"
cp "$MNW/.specify/workflows/workflow-registry.json" "$GUIDE/templates/spec-kit/workflow-registry.template.json"
cp "$MNW/.specify/orchestrator.json" "$GUIDE/templates/spec-kit/orchestrator.json"
cp "$MNW/docs/agents/SDD_USER_GUIDE.md" "$GUIDE/templates/spec-kit/sdd-user-guide.template.md"
cp "$MNW/.cursor/skills/sdd-entry/SKILL.md" "$GUIDE/templates/skills/sdd-entry/SKILL.md"
# …other skill rows from sync-manifest.json

mkdir -p "$GUIDE/templates/skills/company-mcp"
cp "$MNW/.cursor/skills/company-mcp/"* "$GUIDE/templates/skills/company-mcp/"

cp "$MNW/.cursor/hooks/orchestrator-pre-shell.sh" "$GUIDE/templates/product/hooks/"
cp "$MNW/.cursor/hooks/orchestrator-post-tool.sh" "$GUIDE/templates/product/hooks/"

cp "${HOME}/.cursor/hooks/workspace-skill-router.sh" "$GUIDE/templates/global/hooks/"
cp "${HOME}/.cursor/hooks/workspace-skill-router.test.sh" "$GUIDE/templates/global/hooks/"

# Bump last_synced in SYNC.md + sync-manifest.json; open a docs PR.
```

## Do not sync

- Full `sdd-orchestrator` tree into this repo
- Deprecated alias workflow YAML files
- Product `app/` / `frontend/` code
- Deep Company MCP guide body (keep thin pointer in `docs/company-mcp.md`)
