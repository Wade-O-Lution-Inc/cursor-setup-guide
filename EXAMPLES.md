# Examples — concrete patterns

Copy-paste-oriented snippets for Wade-O-Lution Cursor setups. Conceptual background is in [README.md](README.md), [orchestration.md](orchestration.md), [context-budget.md](context-budget.md), [hooks.md](hooks.md), [mcp.md](mcp.md), [rules.md](rules.md), [skills.md](skills.md), [agents.md](agents.md), and [scope.md](scope.md).

## Canonical Example: meeting_notes_workflow

The patterns in this guide are deployed in production in [`meeting_notes_workflow`](https://github.com/Wade-O-Lution-Inc/meeting_notes_workflow). The `.cursor/` tree there is a full working reference — orchestrator + consolidated specialists + glob-gated rules + hooks + skills.

**Introduced by PR:** [#266 — docs(cursor): add orchestrator rule + README for .cursor/](https://github.com/Wade-O-Lution-Inc/meeting_notes_workflow/pull/266)

### `.cursor/` shape

```
.cursor/
├── README.md                                  # Self-documents the orchestration layer
├── CONTEXT_BUDGET.md                          # Before/after context-size snapshot (~50% reduction)
├── rules/
│   ├── 00-orchestrator.mdc                    # always-on — implicit routing
│   ├── project.mdc                            # always-on — identity, pattern catalog, doc index
│   ├── engineering-discipline.mdc             # always-on — think/scope/surgical/simple/done
│   ├── environment-and-commands.mdc           # always-on — Doppler, uv run python, Supabase CLI
│   ├── security-and-git.mdc                   # always-on — security, staging-first git, OSS intake
│   ├── testing-conventions.mdc                # always-on — AAA, naming, conftest, markers
│   ├── compact-handoff.mdc                    # requestable — dense operational handoff
│   ├── deployment.mdc                         # glob-gated — Dockerfile/deploy/workflows only
│   └── worktree-orchestrator.mdc              # glob-gated — scripts/orchestrator/** only
├── hooks/
│   ├── detect-secrets.sh                      # beforeSubmitPrompt
│   ├── block-no-verify.sh                     # beforeShellExecution
│   ├── block-sensitive-reads.sh               # beforeTabFileRead
│   ├── orchestrator-pre-shell.sh              # beforeShellExecution (git policy)
│   ├── orchestrator-post-tool.sh              # subagentStop (mixed-concern detection)
│   └── refresh-compact-context.sh             # afterFileEdit + stop
├── hooks.json
├── skills/
│   ├── doppler-secrets/                       # secret manager CLI
│   ├── supabase-cli/                          # database CLI
│   ├── fireflies-ops-cli/                     # integration ingest troubleshooting
│   ├── grafana-deploy/                        # dashboard/alert deployment
│   ├── perplexity-space-export/               # integration backfill
│   ├── notion-integration/                    # plugin-gated Notion workflow
│   ├── worktree-orchestrator/                 # multi-agent branch split
│   ├── architecture-diagram-generator/        # mermaid + standalone diagrams
│   └── oss-skill-security-review/             # OSS skill intake gate (paired with rule)
└── settings.json
```

### Key properties

- **9 rules** (6 always-on, 2 glob-gated, 1 requestable) down from 15 single-concern rules.
- **~50% reduction in always-on context cost** — measured in `CONTEXT_BUDGET.md`.
- **Operational knowledge lives in skills**, not rules. Doppler, Supabase, Grafana, Fireflies, Perplexity, worktrees, and architecture diagrams each own a skill.
- **Hooks are low-signal.** The two orchestrator hooks emit at most one `followup_message` per event, and only when a threshold trips.
- **`auto-context.md` is hook-generated** and gitignored. The `compact-handoff.mdc` rule reads it as authoritative repo state.

### What to copy vs. what to adapt

| Copy verbatim | Adapt to your project |
|---|---|
| `00-orchestrator.mdc` (template) | Mode list if your stack has a distinct workflow |
| Hook scripts | Additional blocking hooks specific to your stack |
| OSS skill intake section of `security-and-git.mdc` | Base-branch name, branch prefixes, PR target |
| Security stop-and-report section | Project's safe patterns (`settings.*`, parameterized query helpers) |
| Testing AAA structure | Test framework, marker names, fixture conventions |

Template starters: [`templates/00-orchestrator.mdc`](templates/00-orchestrator.mdc), [`templates/engineering-discipline.mdc`](templates/engineering-discipline.mdc), [`templates/environment-and-commands.mdc`](templates/environment-and-commands.mdc), [`templates/security-and-git.mdc`](templates/security-and-git.mdc), [`templates/README-dot-cursor.md`](templates/README-dot-cursor.md).

---

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
| Session handoff (compact / checkpoint) | **`.cursor/rules/compact-handoff.mdc`**, optional **`.cursor/auto-context.md`** (hook-generated) and **`.cursor/session-handoff.md`** (on explicit save) — see [hooks.md](hooks.md#session-handoff-pattern-compact--checkpoint) |
| Organization templates | **This repo** — [cursor-setup-guide](https://github.com/Wade-O-Lution-Inc/cursor-setup-guide) |
