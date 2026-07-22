# Template sync contract

**Gold sources (pull FROM):**

| Gold | Repo / path |
|------|-------------|
| Product harness | [meeting_notes_workflow](https://github.com/Wade-O-Lution-Inc/meeting_notes_workflow) (`main` / `staging`) |
| Orchestrator runtime | [sdd-orchestrator](https://github.com/Wade-O-Lution-Inc/sdd-orchestrator) — **not** vendored here; document install only |

**This guide:** adoption copies under `templates/`. After any SDD harness PR lands in meeting_notes, resync the paths below and bump **Last synced**.

After syncing `global/hooks/workspace-skill-router*.sh` into this repo, **tell the team to refresh** `~/.cursor/hooks/` on each machine — templates are not live. See [../global-env.md](../global-env.md#live-routing-is-per-machine-team-must-refresh).

**Last synced:** 2026-07-22 (Company MCP skill + guide + skill-router company-mcp keywords)

## Path map

| Template path | Gold path |
|---------------|-----------|
| `spec-kit/sdd-workflow.yml` | `.specify/workflows/sdd/workflow.yml` |
| `spec-kit/sdd-remote-workflow.yml` | `.specify/workflows/sdd-remote/workflow.yml` |
| `spec-kit/workflow-registry.template.json` | `.specify/workflows/workflow-registry.json` |
| `spec-kit/orchestrator.json` | `.specify/orchestrator.json` |
| `spec-kit/sdd-user-guide.template.md` | `docs/agents/SDD_USER_GUIDE.md` |
| `spec-kit/confidence-template.md` | `.specify/templates/confidence-template.md` |
| `skills/sdd-entry/SKILL.md` | `.cursor/skills/sdd-entry/SKILL.md` |
| `skills/speckit-confidence/SKILL.md` | `.cursor/skills/speckit-confidence/SKILL.md` |
| `skills/speckit-confidence-improve/SKILL.md` | `.cursor/skills/speckit-confidence-improve/SKILL.md` |
| `skills/speckit-agent-context-update/SKILL.md` | `.cursor/skills/speckit-agent-context-update/SKILL.md` |
| `skills/company-mcp/*` | `.cursor/skills/company-mcp/*` |
| `../company-mcp-cursor-guide.md` (adoption copy) | `docs/getting-started/COMPANY_MCP_CURSOR_GUIDE.md` |
| `global/hooks/workspace-skill-router.sh` | `~/.cursor/hooks/workspace-skill-router.sh` (machine gold; keep in sync) |
| `global/hooks/workspace-skill-router.test.sh` | `~/.cursor/hooks/workspace-skill-router.test.sh` |

Pedagogy docs under `specify/` and root `*.md` are **authored in this repo** (not byte-copied). Keep them aligned with gold behavior, but they may summarize rather than duplicate.

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
# …other skill rows as needed

mkdir -p "$GUIDE/templates/skills/company-mcp"
cp "$MNW/.cursor/skills/company-mcp/"* "$GUIDE/templates/skills/company-mcp/"
cp "$MNW/docs/getting-started/COMPANY_MCP_CURSOR_GUIDE.md" "$GUIDE/company-mcp-cursor-guide.md"
# Re-apply adoption-hub preface / absolute links in company-mcp-cursor-guide.md after copy.

cp "${HOME}/.cursor/hooks/workspace-skill-router.sh" "$GUIDE/templates/global/hooks/workspace-skill-router.sh"
cp "${HOME}/.cursor/hooks/workspace-skill-router.test.sh" "$GUIDE/templates/global/hooks/workspace-skill-router.test.sh"

# Then edit Last synced date above and open a docs PR on cursor-setup-guide.
```

## Do not sync

- Full `sdd-orchestrator` tree into this repo
- Deprecated alias workflow YAML files (removed; use [deprecated-aliases.md](./spec-kit/deprecated-aliases.md))
- Product `app/` / `frontend/` code
