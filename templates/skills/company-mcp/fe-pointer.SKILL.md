---
name: company-mcp
description: >-
  Thin pointer to IntegrityKB Company MCP skill. Use when building customer UI
  or needing grounded company/customer context from the knowledge base.
---

# Company MCP (FE pointer)

**Canonical skill (read this first):**

`../meeting_notes_workflow/.cursor/skills/company-mcp/SKILL.md`

If that path is unavailable in this workspace, open the sibling clone:

`Wade-O-Lution-Inc/meeting_notes_workflow/.cursor/skills/company-mcp/SKILL.md`

Human guide in the KB repo: `docs/getting-started/COMPANY_MCP_CURSOR_GUIDE.md`

## Install in an FE repo

1. Copy this file to `.cursor/skills/company-mcp/SKILL.md` in the FE repo
   (adjust the relative path to the KB clone if needed).
2. Ensure Team MCP `Integrity-kb-company` is enabled (public staging/prod URL).
3. Do not duplicate the full procedure here — always follow the canonical skill.

## One-line rule

Resolve → `get_company_context_pack` → cite; never invent company facts.
