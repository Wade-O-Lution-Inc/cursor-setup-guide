# Company MCP in Cursor — Frontend / Sales / PM Guide

> **Gold source:** [meeting_notes_workflow `COMPANY_MCP_CURSOR_GUIDE.md`](https://github.com/Wade-O-Lution-Inc/meeting_notes_workflow/blob/main/docs/getting-started/COMPANY_MCP_CURSOR_GUIDE.md).  
> This file is the adoption-hub copy. After KB guide changes, resync per [templates/SYNC.md](./templates/SYNC.md).  
> Agent skill template: [templates/skills/company-mcp/](./templates/skills/company-mcp/).

**Audience:** Frontend engineers, sales, and PM using Cursor with the IntegrityKB **Company** MCP plugin  
**Server:** `IntegrityKB-Company` at `/mcp-company` (read-only company knowledge)  
**Not this guide:** the full ops MCP at `/mcp` (admin/search/chat/workspaces)

This surface exists so Cursor can pull **customer/company context from the knowledge base** — meetings, dossiers, Notion-ingested docs, graph neighbors — with citations, without inventing facts.

---

## 1. What you get

When the Company MCP plugin is enabled in the Cursor team environment, the agent can call tools that:

| Job | Prefer |
|-----|--------|
| One-shot company briefing (profile + meetings + docs + graph) | `get_company_context_pack` |
| Natural-language question with grounded answer | `ask_company_context` |
| Disambiguate / look up a company name | `find_companies` → `resolve_entity` |
| Drill into one area | leaf tools (`get_company_dossier`, `search_company_meetings`, …) |

Everything is **read-only**. Nothing writes to Linear, Notion, the KB, or the DB.

**Mental model:** resolve the company first → retrieve cited evidence → only then synthesize. The pack tool does the first two in one call; `ask_*` adds verified prose.

---

## 2. Prerequisites (team plugin)

Assumes the Company MCP is already plumbed as a Cursor team / org plugin (you do not need a personal `mcp.json` unless you are testing a different URL).

You still need:

1. **Access** — your Cursor team membership includes the IntegrityKB Company MCP plugin.
2. **API key** — the plugin is configured with `Authorization: Bearer <INTEGRITY_KB_API_KEY>` (or equivalent team secret). Without a valid key, every call returns 401 before any tool runs.
3. **Network** — Cursor can reach the configured host. **Team / Cloud Agents must use a public URL** (Railway staging or prod `…/mcp-company`). `kb.lab.integrityus.ai` is Tailscale-only and typically yields `fetch failed` from Cursor’s cloud.

If tools never appear: check Cursor **Settings → MCP** (or team plugin admin) that `integrity-kb-company` (or the team name for this plugin) is **enabled** and connected (green). Restart the MCP session after secret or URL changes.

**Agent skill (auto-routed):** copy [templates/skills/company-mcp/](./templates/skills/company-mcp/) into the product repo (gold: `meeting_notes_workflow/.cursor/skills/company-mcp/`). FE repos can use the thin pointer [`fe-pointer.SKILL.md`](./templates/skills/company-mcp/fe-pointer.SKILL.md).

**Auto-routing is per-machine.** Keyword routing for “context pack” / “customer context” runs from your local `~/.cursor/hooks/workspace-skill-router.sh`. Shipping the skill in git does **not** update teammates’ routers — each person (or Cloud Agent VM) must refresh hooks from this guide’s templates. Steps: [global-env.md → Live routing is per-machine](./global-env.md#live-routing-is-per-machine-team-must-refresh).

Reference shape (local / personal override only): [meeting_notes `.cursor/mcp.json.example`](https://github.com/Wade-O-Lution-Inc/meeting_notes_workflow/blob/main/.cursor/mcp.json.example).

---

## 3. When to use it (frontend workflows)

Use Company MCP when the UI work depends on **real customer/company knowledge**:

| You’re building… | Ask Cursor to… |
|------------------|----------------|
| Customer portal / account page | Pull the context pack for that company; mirror fields that exist in the dossier/card |
| Meeting-history UI | `search_company_meetings` or `get_company_timeline` for scoped meeting lists |
| “Who knows this account?” panel | `who_knows` |
| Doc / Notion-linked surfaces | `list_company_documents` or pack `sections.documents` |
| Relationship / network viz | `traverse_graph` or pack `sections.graph` |
| Copy / empty states / microcopy grounded in reality | `ask_company_context` with a narrow question |

Do **not** use it for:

- Deploying, migrating, or operating the platform (use ops MCP / runbooks)
- Inventing product requirements the KB never recorded
- Treating `ask_*` answers as source of truth without reading `citations[]`

---

## 4. Recommended agent workflow

Tell Cursor (or stick this in a project rule / AGENTS note) to follow this order:

```text
1. find_companies / resolve_entity   — if the name might be ambiguous
2. get_company_context_pack          — default first retrieval
3. leaf tools                        — only to deepen one section
4. ask_company_context               — last, for prose synthesis
```

### Prompt patterns that work well

**Pack-first (default):**

> Using the Company MCP, get the context pack for **Aligned Data Centers**. Summarize what’s solid for a customer overview UI (contacts, recent meetings, open asks). List citation ids you relied on. Do not invent fields missing from the pack.

**UI-shaped extraction:**

> From the Company MCP pack for **\<company\>**, propose a TypeScript type for the account header (name, stage, sentiment, last contact). Only include properties present in the dossier/card. Flag gaps in `warnings`.

**Grounded Q&A:**

> Ask the Company MCP: “What did we last discuss with \<company\> about uptime/SLA?” If the answer is ungrounded, say so and show citations only.

**Ambiguity handling:**

> Resolve **Acme**. If ambiguous, list candidates and stop — don’t pick one.

---

## 5. Tool cheat sheet

### Primary

| Tool | Args | Use for |
|------|------|---------|
| `get_company_context_pack` | `company`, optional `query`, `mode` (`customer` \| `platform`) | Default one-shot bundle |
| `ask_company_context` | `company`, `question` | Cited prose; may return `status=ungrounded` |

### Discovery

| Tool | Args | Use for |
|------|------|---------|
| `find_companies` | `query`, `limit?` | Fuzzy name search before resolve |
| `resolve_entity` | `name`, `entity_type?` (`company` \| `person`) | Fail-closed canonical id |

### Leaf (drill-down)

| Tool | Use for |
|------|---------|
| `get_company_dossier` | Meetings, contacts, topics, asks, cadence |
| `get_company_card` | Markdown knowledge-card rollup |
| `search_company_meetings` | Semantic meeting search **scoped to that company** |
| `get_company_timeline` | Chronological meetings |
| `list_company_documents` | Documents linked to the company |
| `search_documents` | Broader doc search (optional `source_type`) |
| `traverse_graph` | One-hop graph neighbors |
| `who_knows` | Internal people ranked by familiarity |
| `kb_read` | Read one meeting/document section by id |

### Resources (URI)

| URI | Content |
|-----|---------|
| `kb://company/{company_id}` | Dossier JSON |
| `kb://company/{company_id}/card` | Card JSON |
| `kb://company/{company_id}/documents` | Linked documents JSON |

---

## 6. Reading the response envelope

Tools return a **JSON string** envelope. Important fields:

```json
{
  "ok": true,
  "company_id": "…",
  "sections": { "card": {}, "dossier": {}, "documents": [], "graph": [], "who_knows": [] },
  "citations": [{ "type": "meeting", "id": "…", "title": "…" }],
  "warnings": ["documents_unavailable"],
  "orchestrator": { "route": "fast_pack", "rounds": 0, "cache_hit": false },
  "answer": "…",
  "groundedness": 0.85,
  "status": "ungrounded"
}
```

| Signal | Meaning | What you should do |
|--------|---------|-------------------|
| `ok: false`, `status: not_found` | No company match | Fix the name; try `find_companies` |
| `ok: false`, `status: ambiguous` | Multiple candidates | Pick an id from `candidates`; don’t guess |
| `ok: false`, `status: ungrounded` | Ask path refused or failed verification | Use pack/leaf evidence; don’t ship invented copy |
| `warnings[]` | Partial section failure | UI can still render other sections; note the gap |
| `citations[]` | Source ids for returned facts | Prefer these over free text when wiring UI |
| `cache.hit` / orchestrator `cache_hit` | Same-process pack cache | Repeat packs are faster; don’t assume cross-replica cache |

**Rule for FE agents:** if it isn’t in `sections` / `citations`, it isn’t in the KB for this call — don’t hardcode it into components as fact.

---

## 7. Example Cursor sessions

### A. Scaffold an account overview from the KB

> I’m building an account overview for **Aligned Data Centers**.  
> 1) `get_company_context_pack`  
> 2) Propose a React component tree (header, contacts, recent meetings, open asks) using only pack fields  
> 3) Call out `warnings` and missing sections  
> 4) Keep citation ids in comments above each data binding

### B. Meeting list filtered to one customer

> Use Company MCP `search_company_meetings` for **\<company\>** with query “integration”. Return a table model: `{ id, title, date, snippet }` from citations/results only.

### C. Safe microcopy

> Ask Company MCP whether we have evidence of an active MSA with **\<company\>**. If ungrounded, draft UI empty-state copy that says we don’t have that in the KB yet — do not claim we do.

---

## 8. Company MCP vs ops MCP

| | **Company MCP** `/mcp-company` | **Ops MCP** `/mcp` |
|--|-------------------------------|---------------------|
| Audience | FE / product context in Cursor | Platform operators & broad KB agents |
| Scope | One company at a time, resolve-first | Search, chat, workspaces, admin-style tools |
| Writes | None | Still treat as sensitive; prefer runbooks for mutations |
| Default tool | `get_company_context_pack` | Varies (`search_kb`, `chat_with_kb`, …) |

If both plugins are enabled, **prefer Company MCP for customer/FE context** so the agent doesn’t roam the whole KB or ops tools.

---

## 9. Troubleshooting

| Symptom | Likely cause | Fix |
|---------|--------------|-----|
| Tools missing in Cursor | Plugin disabled / MCP not connected | Enable plugin; reload window; check team MCP admin |
| `Invalid or missing API key` / 401 | Bad or missing bearer secret | Rotate/refresh team secret; reconnect MCP |
| `Session not found` | Multi-replica LB without sticky sessions | Use the team URL that points at a single serving unit (lab or current Railway `numReplicas=1` web) |
| Always `ambiguous` / `not_found` | Vague name | `find_companies`, then pass canonical name or UUID |
| Ask returns `ungrounded` | No supporting evidence | Fall back to pack; don’t invent; narrow the question |
| Empty documents / graph | Partial knowledge (`warnings`) | Render what’s present; graph/docs may be thin for that company |
| Stale-seeming pack | Process-local TTL cache | Wait for TTL or change `query` slightly; ingest lag is separate (worker/pipeline) |

Health (ops, not MCP): `GET /health/live` on the KB host should return `{"status":"ok"}`.

---

## 10. Environments

| Environment | Typical URL | Use |
|-------------|-------------|-----|
| Railway staging | `https://web-staging-56c0.up.railway.app/mcp-company` | **Team MCP / Cloud Agents default** (public) |
| Lab | `https://kb.lab.integrityus.ai/mcp-company` | Desktop only (Tailscale); not for Team/Cloud |
| Railway production | production web host + `/mcp-company` | Prod-parity checks only |
| Local | `http://localhost:8000/mcp-company` | Backend via `doppler run -- uv run uvicorn …` |

Team plugin URL is controlled by Cursor org/plugin config — you usually **don’t** edit this per machine.

---

## 11. Related docs

- Architecture: [ARCHITECTURE.md §5.1](https://github.com/Wade-O-Lution-Inc/meeting_notes_workflow/blob/main/docs/platform/ARCHITECTURE.md)
- API / MCP table: [API_REFERENCE.md](https://github.com/Wade-O-Lution-Inc/meeting_notes_workflow/blob/main/docs/platform/API_REFERENCE.md)
- Local development: [DEVELOPMENT.md](https://github.com/Wade-O-Lution-Inc/meeting_notes_workflow/blob/main/docs/getting-started/DEVELOPMENT.md)
- Spec: [`specs/084-kb-company-mcp/`](https://github.com/Wade-O-Lution-Inc/meeting_notes_workflow/tree/main/specs/084-kb-company-mcp)
- Deploy / replicas: [DEPLOYMENT.md](https://github.com/Wade-O-Lution-Inc/meeting_notes_workflow/blob/main/docs/operations/DEPLOYMENT.md)
- Skill template: [templates/skills/company-mcp/](./templates/skills/company-mcp/)
