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

## 8. Global harness (machine-local)

See [global-env.md](./global-env.md) and [scope.md](scope.md). Install:

- Skill router: [templates/global/hooks/](templates/global/hooks/) + [templates/global/hooks.json](templates/global/hooks.json)
- Always-on rules: [templates/global/rules/](templates/global/rules/)
- Ops skills (`lab-host-ssh`, …)
- Orchestrator: `gh repo clone Wade-O-Lution-Inc/sdd-orchestrator ~/.cursor/sdd-orchestrator-ctl` + skill symlink — [day1-setup.md](./day1-setup.md)

```bash
# Deterministic smoke (no API key)
python3 ~/.cursor/sdd-orchestrator-ctl/bin/sdd-ctl plan-phase --help

# Headless range (needs ctl venv + CURSOR_API_KEY for non-mock)
~/.cursor/sdd-orchestrator-ctl/.venv/bin/python \
  ~/.cursor/sdd-orchestrator-ctl/bin/sdd-run \
  --cwd /path/to/repo --feature-dir specs/NNN-name \
  --from-phase specify --to-phase tasks \
  --feature-description "what and why" --mock
```

Do **not** store API keys in skills.

## 9. Vendoring this guide inside a repo

Some teams copy these markdown files into **`your-repo/.cursor/guide/`** (plus a short `README.md` that points back here) so agent docs sit next to `.cursor/rules/` and `.cursor/skills/`. **Templates** still come from this repository’s [templates/](templates/) directory when bootstrapping new files.

## 10. Where new material belongs

| Kind of content | Put it in |
|-----------------|-----------|
| Cloud Agent commands and fake env | Repo root **`AGENTS.md`** |
| Always-on agent behavior | **`.cursor/rules/*.mdc`** |
| Multi-step runbooks | **`.cursor/skills/<skill>/SKILL.md`** |
| Hard blocks | **`.cursor/hooks/`** + **`hooks.json`** |
| Cross-repo routing / SDD orchestrator | **`~/.cursor/`** — [global-env.md](./global-env.md) |
| Session handoff (compact / checkpoint) | **`.cursor/rules/compact-handoff.mdc`**, optional **`.cursor/auto-context.md`** (hook-generated) and **`.cursor/session-handoff.md`** (on explicit save) — see [hooks.md](hooks.md#session-handoff-pattern-compact--checkpoint) |
| Organization templates | **This repo** — [cursor-setup-guide](https://github.com/Wade-O-Lution-Inc/cursor-setup-guide) |

## 11. Spec-Driven Development (`sdd` / `sdd-remote`)

**Canonical docs:** [specify/quick-start.md](./specify/quick-start.md) · [specify/workflows.md](./specify/workflows.md).

```bash
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@v0.10.2
specify workflow run sdd -i spec="..." -i integration=cursor-agent
specify workflow run sdd -i spec="..." -i stop_at=plan
specify workflow run sdd-remote -i spec="..." -i remote_phase=implement -i interval=600
specify workflow status && specify workflow resume <run_id>
```

Chat:

```
Start SDD: Add user-facing export for meeting summaries
Continue SDD
```

Bootstrap: [specify/bootstrap.md](./specify/bootstrap.md) · templates: [templates/spec-kit/](templates/spec-kit/).
