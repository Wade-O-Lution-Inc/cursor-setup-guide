---
name: company-mcp
description: >-
  Retrieve grounded company/customer context via IntegrityKB Company MCP
  (get_company_context_pack, ask_company_context, find_companies, leaf tools).
  Use for frontend customer UI, account pages, meeting history, contacts,
  relationship graphs, sales/PM briefings, prep notes, or when the user mentions
  company context, dossiers, context packs, who-knows, or named customers
  (e.g. Aligned). Prefer Company MCP over the ops /mcp server for this work.
  Do not invent company facts; follow this skill's resolve → pack → cite flow.
---

# Company MCP (IntegrityKB)

Read-only company knowledge for Cursor via the **IntegrityKB-Company** MCP
(`Integrity-kb-company` / `integrity-kb-company` / `user-integrity-kb-company`).
Auth and URL live in Cursor Team MCP (or local `mcp.json`) — not in this skill.

Human guide: `docs/getting-started/COMPANY_MCP_CURSOR_GUIDE.md`  
FE install pointer: [fe-pointer.SKILL.md](fe-pointer.SKILL.md)

**Do not freestyle company facts.** Resolve → retrieve cited evidence → then synthesize.

---

## Prerequisites

1. Company MCP connected (green) in Cursor Customize → MCPs.
2. Team / Cloud Agents: use a **public** URL (`…railway.app/mcp-company`), not
   `kb.lab.integrityus.ai` (Tailscale-only → `fetch failed` from Cursor cloud).
3. If tools missing / 401 / fetch failed → stop; tell the user to fix MCP auth/URL.
   Do not invent dossier fields.

---

## Default workflow

```
1. Name unclear?     → find_companies / resolve_entity  (stop if ambiguous)
2. Default retrieve  → get_company_context_pack
3. Deepen one area   → leaf tool only
4. Prose Q&A         → ask_company_context  (last)
```

| Need | Tool |
|------|------|
| One-shot briefing / UI scaffold | `get_company_context_pack` |
| Disambiguate name | `find_companies` → `resolve_entity` |
| Meetings / timeline / docs / graph / who-knows | leaf tools |
| Cited natural-language answer | `ask_company_context` |

---

## Hard rules

1. **Company MCP only** for customer/company context. Do not use ops `/mcp` for this.
2. **Read-only.** No writes to Linear, Notion, KB, or DB from this surface.
3. **Fail closed:** `ok: false`, `status: not_found` / `ambiguous` / `ungrounded` →
   report to the user; do not pick a candidate or invent an answer.
4. **Citations:** every claim used in UI copy, types, or briefings must map to
   `citations[]` or pack `sections`. If it isn’t there, it isn’t a KB fact.
5. **Warnings are gaps**, not errors — render what exists; call out missing sections.
6. Prefer **pack-first**; use `ask_*` only when the user wants prose synthesis.

---

## Audience playbooks

### Frontend / product UI

- Pack → propose component tree / TypeScript types **only** from pack fields.
- Keep citation ids in comments above data bindings.
- Empty states when `ungrounded` or section missing — never fake MSA/stage/contacts.
- Example ask: “Scaffold account overview for **\<company\>** from the context pack.”

### Sales / PM / prep briefing

- Pack → short brief: stage/sentiment, open asks, decision-makers, last substantive meetings.
- Lead with citations; flag `warnings` (e.g. thin docs/graph).
- For a yes/no factual question, use `ask_company_context`; if ungrounded, say so.
- Example ask: “Brief me on **\<company\>** for tomorrow’s call — asks, contacts, last topics.”

---

## Envelope cheat sheet

| Signal | Action |
|--------|--------|
| `ok: true` + pack sections | Use as source of truth |
| `status: ambiguous` + `candidates` | List candidates; stop |
| `status: not_found` | Retry with `find_companies` or fix spelling |
| `status: ungrounded` | Fall back to pack/leaf; don’t invent |
| `warnings[]` | Note gaps; continue with other sections |
| `orchestrator.coverage_score` | Soft quality signal, not permission to invent |

Prompt patterns → [prompt-patterns.md](prompt-patterns.md)

---

## Out of scope

- Platform ops, deploys, migrations, admin MCP tools
- Secret management (Team MCP header / Doppler `API_SECRET_KEY`)
- Treating `ask_*` prose as stronger than citations

## Related

- Guide: `docs/getting-started/COMPANY_MCP_CURSOR_GUIDE.md`
- Architecture: `docs/platform/ARCHITECTURE.md` (§ Company MCP)
- Spec: `specs/084-kb-company-mcp/`
