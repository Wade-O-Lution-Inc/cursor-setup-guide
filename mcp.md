# MCP (Model Context Protocol)

MCP lets the Cursor agent connect to your running services — querying data, calling tools, and reading resources without writing ad-hoc scripts.

## When to Use MCP

Add an MCP connection when your app exposes an MCP server that provides data or actions the agent would otherwise need to construct manually. Common use cases:

- **Search your app's data** without writing raw SQL
- **Call internal APIs** through a structured tool interface
- **Read live state** (config, feature flags, metrics)

If your app doesn't have an MCP server, you don't need `mcp.json`.

## Configuration

Create `.cursor/mcp.json` in your repo:

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

## Real Example

Our knowledge base API exposes an MCP server (built with FastMCP, mounted at `/mcp` in FastAPI). The agent can search meetings, look up people and companies, and query the knowledge graph through it.

```json
{
  "mcpServers": {
    "integrity-kb": {
      "url": "http://localhost:8000/mcp",
      "type": "streamableHttp"
    }
  }
}
```

With this config, the agent can do things like `search_kb("quarterly revenue")` instead of constructing database queries or API calls.

## MCP + Rules

If your app has an MCP server, mention it in `project.mdc` as an entry point so the agent knows it exists:

```markdown
## Entry Points

- **MCP server**: `app/mcp/server.py` (FastMCP, mounted at `/mcp`)
```

And in your `git-workflow.mdc` or equivalent, list MCP queries as a safe operation:

```markdown
## Safe Operations (No Approval Needed)

- Query MCP server (read resources, `search_kb`)
```

## Third-Party MCP Servers

Cursor also supports MCP servers from plugins (like the Supabase plugin). These are configured in `.cursor/settings.json`:

```json
{
  "plugins": {
    "supabase": {
      "enabled": true
    }
  }
}
```

Plugin MCP servers are managed by Cursor — you just enable them. They provide tools like database queries, auth management, etc. specific to that service.

## Security Notes

- `mcp.json` should only contain `localhost` URLs or URLs that don't embed credentials
- If an MCP server requires authentication, it should use environment variables or OAuth — never inline tokens in `mcp.json`
- The file is safe to commit to git as long as it contains no secrets
