# integrity-company-context

Company-context skill only (`skills/company-mcp/`). Auth and URLs stay on **Team MCP** — this plugin ships **no** `mcp.json` with secrets, Bearer tokens, or API keys.

## Admin / seat setup (human)

1. In Cursor Dashboard → **Integrations & MCP**, connect **IntegrityKB** (company knowledge) for the Integrity Cursor Team.
2. Add this plugin to the **Team Marketplace**.
3. Set install mode to **Default On** (human dashboard action — not set from git).

See [docs/team-marketplace.md](../../docs/team-marketplace.md) for the full admin runbook.

## Do not

- Commit `mcp.json` with MCP URLs, tokens, or API keys into this plugin or repo.
- Treat SDD / `sdd-ctl` as an MCP server (orchestration is separate; see `integrity-sdd`).
