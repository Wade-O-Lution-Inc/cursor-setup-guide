# MCP (Model Context Protocol)

MCP lets the Cursor agent connect to your running services — querying data, calling tools, and reading resources without writing ad-hoc scripts.

## When to Use MCP

Add an MCP connection when your app exposes an MCP server that provides data or actions the agent would otherwise need to construct manually. Common use cases:

- **Search your app's data** without writing raw SQL
- **Call internal APIs** through a structured tool interface
- **Read live state** (config, feature flags, metrics)

If your app doesn't have an MCP server, you don't need `mcp.json`.

## Configuration

Create `.cursor/mcp.json` in your repo. A generic stub ships as [templates/mcp.json](templates/mcp.json).

```json
{
  "mcpServers": {
    "your-service-name": {
      "url": "http://localhost:8000/mcp",
      "type": "streamableHttp"
    }
  }
}
```

| Field | Purpose |
|-------|---------|
| `your-service-name` | Display name the agent sees — use something descriptive |
| `url` | The MCP endpoint. Usually your local dev server |
| `type` | Transport type. `streamableHttp` for HTTP-based MCP servers |

## Real Example (FastAPI + FastMCP)

A typical Wade-O-Lution service exposes an MCP server (e.g. FastMCP mounted at `/mcp` in FastAPI). The display name is arbitrary — examples in the wild include `integrity-kb`, `knowledge-base`, etc.

```json
{
  "mcpServers": {
    "knowledge-base": {
      "url": "http://localhost:8000/mcp",
      "type": "streamableHttp"
    }
  }
}
```

Start the backend before relying on MCP tools. More snippets: [EXAMPLES.md](EXAMPLES.md).

## MCP + Rules

If your app has an MCP server, mention it in `project.mdc` as an entry point so the agent knows it exists:

```markdown
## Entry Points

- **MCP server**: `app/mcp/server.py` (FastMCP, mounted at `/mcp`)
```

And in your `git-workflow.mdc` or equivalent, list MCP queries as a safe operation:

```markdown
## Safe Operations (No Approval Needed)

- Query MCP server (read resources, e.g. `search_kb`)
```

## Third-Party MCP Servers

Cursor also supports MCP servers from Cursor **plugins**. These are configured in `.cursor/settings.json`, separate from `mcp.json`.

Enable only what you need — for example Supabase:

```json
{
  "plugins": {
    "supabase": {
      "enabled": true
    }
  }
}
```

Or the Notion workspace plugin:

```json
{
  "plugins": {
    "notion-workspace": {
      "enabled": true
    }
  }
}
```

Plugin MCP servers are managed by Cursor; you toggle them in `settings.json`.

## IntegrityKB Company MCP (team)

Read-only company/customer context for FE + sales/PM. Full guide: **[company-mcp-cursor-guide.md](./company-mcp-cursor-guide.md)**.  
Agent skill template: [templates/skills/company-mcp/](./templates/skills/company-mcp/).

### Team account (preferred)

1. Doppler: `API_SECRET_KEY` for the target env (`stg` / `prd`).
2. Cursor Dashboard → **Integrations & MCP** → add remote server:
   - **URL:** `https://web-staging-56c0.up.railway.app/mcp-company` (public; **not** lab)
   - **Header:** `Authorization: Bearer <API_SECRET_KEY>`
3. **Add to Team Marketplace** so IDE / CLI can install it.
4. Teammates: Customize → MCPs → enable (green).

`kb.lab.integrityus.ai` is Tailscale + internal TLS — Team/Cloud Agents get **fetch failed**. Lab is Desktop-only.

### Local / repo override

```json
{
  "mcpServers": {
    "integrity-kb-company": {
      "url": "https://web-staging-56c0.up.railway.app/mcp-company",
      "headers": {
        "Authorization": "Bearer ${env:INTEGRITY_KB_API_KEY}"
      }
    }
  }
}
```

`INTEGRITY_KB_API_KEY` is a **client alias** — value must equal Doppler `API_SECRET_KEY`. Do not add a separate Doppler secret with that name.

### Agent procedure

Do not freestyle company facts. Skill + router encode: resolve → `get_company_context_pack` → cite. Keywords route via `workspace-skill-router.sh` → `meeting_notes_workflow/.cursor/skills/company-mcp/`.

## Security Notes

- `mcp.json` should only contain `localhost` URLs or URLs that don't embed credentials
- If an MCP server requires authentication, it should use environment variables or OAuth — never inline tokens in `mcp.json`
- The file is safe to commit to git as long as it contains no secrets
- Team MCP Bearer secrets live in the Cursor dashboard, not in git
