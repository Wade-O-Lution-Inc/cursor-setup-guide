# Examples — concrete patterns

Copy-paste-oriented snippets for Wade-O-Lution Cursor setups. Conceptual background is in [README.md](README.md), [hooks.md](hooks.md), [mcp.md](mcp.md), [rules.md](rules.md), [skills.md](skills.md), [agents.md](agents.md), and [scope.md](scope.md).

## 1. Extended `hooks.json` (security trio + orchestrator hooks + context refresh)

Reference implementation: [meeting_notes_workflow](https://github.com/Wade-O-Lution-Inc/meeting_notes_workflow) `.cursor/hooks.json` — includes optional scripts that enforce git workflow policy, post-subagent checks, and session-handoff context refresh:

```json
{
  "hooks": [
    {
      "event": "beforeSubmitPrompt",
      "script": ".cursor/hooks/detect-secrets.sh",
      "description": "Scan prompts for leaked API keys and secrets"
    },
    {
      "event": "beforeShellExecution",
      "script": ".cursor/hooks/block-no-verify.sh",
      "description": "Prevent --no-verify in git commands"
    },
    {
      "event": "beforeTabFileRead",
      "script": ".cursor/hooks/block-sensitive-reads.sh",
      "description": "Block reading .env, .key, .pem, and credential files"
    },
    {
      "event": "beforeShellExecution",
      "script": ".cursor/hooks/orchestrator-pre-shell.sh",
      "description": "Observe git operations and enforce staging-first workflow policies"
    },
    {
      "event": "subagentStop",
      "script": ".cursor/hooks/orchestrator-post-tool.sh",
      "description": "Detect mixed-concern working tree after agent tasks and suggest orchestrator"
    },
    {
      "event": "afterFileEdit",
      "script": ".cursor/hooks/refresh-compact-context.sh",
      "description": "Refresh .cursor/auto-context.md after every file edit"
    },
    {
      "event": "stop",
      "script": ".cursor/hooks/refresh-compact-context.sh",
      "description": "Refresh .cursor/auto-context.md when the agent stops"
    }
  ]
}
```

**Test a hook without Cursor** — stdin is what the hook receives:

```bash
echo "sk-ant-api03-XXXXXXXXXXXXXXXX" | bash .cursor/hooks/detect-secrets.sh
echo $?   # expect 1 = blocked
```

## 2. Rule frontmatter (`project.mdc` pattern)

```markdown
---
description: Project identity, entry points, key commands, and documentation index
alwaysApply: true
---

# Your Project Name
...
```

Use `alwaysApply: true` unless the rule should only attach when its description matches a niche task.

## 3. Skill frontmatter (`search-first` style)

From [templates/search-first-skill/SKILL.md](templates/search-first-skill/SKILL.md):

```markdown
---
name: search-first
description: >-
  Adopt / Extend / Compose / Build decision matrix. Use before writing any
  custom code to check if existing solutions handle the requirement.
---

# Search-First: Adopt / Extend / Compose / Build
```

The `description` field is how agents discover the skill — include trigger terms.

## 4. Backend with secrets (Doppler + `uv`)

Example:

```bash
doppler run -- uv run uvicorn app.main:app --reload --port 8000
```

Prefer **`uv run`** over bare `python` when `python` may not be on `PATH` (common on macOS).

## 5. Cloud Agent placeholders (no secret manager in VM)

In root **`AGENTS.md`**, list minimum env vars with **obviously fake** values — never real secrets:

```
SUPABASE_URL=https://fake.supabase.co
SUPABASE_SERVICE_KEY=fake-service-key
```

## 6. `mcp.json` (localhost app MCP)

Safe to commit when the URL is localhost and contains no credentials:

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

## 7. Plugin MCP via `settings.json`

Example (Notion workspace plugin):

```json
{
  "plugins": {
    "notion-workspace": {
      "enabled": true
    }
  }
}
```

## 8. Global skills (machine-specific, not in git)

Per [scope.md](scope.md), cross-repo SSH or host-specific runbooks can live under `~/.cursor/skills/<name>/SKILL.md`. Do **not** store API keys there.

## 9. Vendoring this guide inside a repo

Some teams copy these markdown files into **`your-repo/.cursor/guide/`** (plus a short `README.md` that points back here) so agent docs sit next to `.cursor/rules/` and `.cursor/skills/`. **Templates** still come from this repository’s [templates/](templates/) directory when bootstrapping new files.

## 10. Where new material belongs

| Kind of content | Put it in |
|-----------------|-----------|
| Cloud Agent commands and fake env | Repo root **`AGENTS.md`** |
| Always-on agent behavior | **`.cursor/rules/*.mdc`** |
| Multi-step runbooks | **`.cursor/skills/<skill>/SKILL.md`** |
| Hard blocks | **`.cursor/hooks/`** + **`hooks.json`** |
| Organization templates | **This repo** — [cursor-setup-guide](https://github.com/Wade-O-Lution-Inc/cursor-setup-guide) |
