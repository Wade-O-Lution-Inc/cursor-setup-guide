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
- Ops skills (`lab-host-ssh`, …) and `sdd-orchestrator-ctl` from a known-good machine

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

**Keep [sdd-user-guide.md](./sdd-user-guide.md) open while learning.** Reference: [meeting_notes_workflow](https://github.com/Wade-O-Lution-Inc/meeting_notes_workflow).

### Bootstrap

```bash
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@v0.10.2
cd your-repo
specify init . --integration cursor-agent --here --force --script sh
# Copy templates/spec-kit/sdd-workflow.yml → .specify/workflows/sdd/workflow.yml
# Copy templates/spec-kit/sdd-remote-workflow.yml → .specify/workflows/sdd-remote/workflow.yml
specify workflow list   # expect sdd + sdd-remote
```

Full checklist: [templates/spec-kit/init-checklist.md](templates/spec-kit/init-checklist.md)

### Run cycle (terminal)

```bash
specify workflow run sdd \
  -i spec="Add user-facing export for meeting summaries" \
  -i integration=cursor-agent

# RFC / stop early:
specify workflow run sdd -i spec="..." -i stop_at=plan

# Close laptop after tasks:
specify workflow run sdd-remote -i spec="..." -i remote_phase=implement -i interval=600
```

Engine pauses at **gates**. While paused:

```bash
specify workflow status
specify workflow resume <run_id>
```

### Chat (daily default)

```
Start SDD: Add user-facing export for meeting summaries
Continue SDD
```

`sdd-entry` → `sdd-orchestrator` per phase (not bare `speckit-*`). Optional NL flags: `scope=api`, `stop at plan`, `test-fix mode`.

### Resume after compact

```
Continue SDD
```

Optional: `.cursor/auto-context.md` shows **Spec Progress** on `NNN-*` branches (see [refresh-compact-context-sdd.patch](templates/hooks/refresh-compact-context-sdd.patch)).