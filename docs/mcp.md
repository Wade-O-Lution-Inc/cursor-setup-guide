# MCP

Connect Cursor to live tools. Prefer **Team** or **repo** MCP for shared services; keep `~/.cursor/mcp.json` minimal and personal.

## When to use MCP

- Live tools the agent should call (not invent): DB, docs, company knowledge, …
- IntegrityKB Company MCP → [company-mcp.md](./company-mcp.md) (deep guide SSOT in meeting_notes)

## Personal vs Team vs repo

| Placement | Use for |
|-----------|---------|
| Cursor **Team** MCP | Shared org servers (preferred for IntegrityKB) |
| `repo/.cursor/mcp.json` (or example) | App-specific servers checked in as examples |
| `~/.cursor/mcp.json` | Personal only; avoid long-lived tokens in git |

`templates/product/mcp.json` is a placeholder. Gold pattern: `meeting_notes_workflow/.cursor/mcp.json.example`.

## Safety

Only enable servers your team trusts. Do not install new MCP servers without explicit approval (`supply-chain-defense` global rule).
