# Cursor Agent Setup Guide

How we configure Cursor's AI agent to work effectively and safely across Wade-O-Lution projects. This guide is a reference for setting up new repos with the same patterns.

## Why Bother?

Without rules and skills, every Cursor session starts from zero. The agent doesn't know your project structure, your deployment pipeline, your database conventions, or what it's not allowed to touch. You end up repeating the same corrections session after session.

Rules, skills, and hooks solve this by giving the agent **persistent institutional knowledge**:

- **Rules** = guardrails and context that apply automatically (always-on, glob-gated, or requestable)
- **Skills** = step-by-step procedures the agent follows for specific tasks (operational runbooks, executable)
- **Hooks** = shell scripts on lifecycle events — blocking hooks that deny bad actions, and optional observation hooks for side effects (e.g. refreshing a repo snapshot)
- **MCP** = live connections to your running services the agent can query

One more concept sits on top of all of these:

- **Orchestrator** = a small always-on rule that *routes* each request to one primary mode and the matching specialists, instead of replaying every rule on every turn. See [orchestration.md](orchestration.md).

The payoff is immediate: the agent writes code that follows your patterns, avoids your known pitfalls, and knows where things live — without being told each session.

## Directory Structure (target shape)

```
your-repo/
├── AGENTS.md                              # Cloud Agent VM instructions (optional)
├── .cursor/
│   ├── README.md                          # Self-documents the orchestration layer
│   ├── rules/
│   │   ├── 00-orchestrator.mdc            # always-on — implicit routing
│   │   ├── project.mdc                    # always-on — project identity, pattern catalog, doc index
│   │   ├── engineering-discipline.mdc     # always-on — think/scope/surgical/simple/done
│   │   ├── environment-and-commands.mdc   # always-on — secret manager, run commands, feature flags
│   │   ├── security-and-git.mdc           # always-on — security protocol, git workflow, OSS intake
│   │   ├── testing-conventions.mdc        # always-on — test patterns, naming, markers
│   │   ├── compact-handoff.mdc            # requestable — session handoff format
│   │   ├── deployment.mdc                 # glob-gated — deploy/infra files only
│   │   └── …                              # glob-gated domain rules as needed
│   ├── skills/                            # operational procedures — one per CLI/integration
│   │   ├── secret-manager/SKILL.md
│   │   ├── db-cli/SKILL.md
│   │   ├── deployment/SKILL.md
│   │   └── …
│   ├── hooks/
│   │   ├── detect-secrets.sh              # block leaked keys in prompts
│   │   ├── block-no-verify.sh             # block --no-verify in git commands
│   │   ├── block-sensitive-reads.sh       # block reads of .env, .key, .pem, credentials
│   │   └── refresh-compact-context.sh     # optional: refresh .cursor/auto-context.md
│   ├── hooks.json                         # hook event → script mapping
│   ├── mcp.json                           # MCP server connections (optional)
│   ├── settings.json                      # Cursor plugin settings (optional)
│   └── auto-context.md                    # gitignored — machine-written repo snapshot
└── CONTEXT_BUDGET.md                      # optional — track always-on token cost
```

Everything in `.cursor/` **except** `auto-context.md` and `session-handoff.md` is safe to commit. Gitignore the two generated files.

**Concrete snippets and the canonical example:** see [EXAMPLES.md](EXAMPLES.md).

## Quick Start for a New Repo

1. Copy the consolidated templates from `templates/` into your repo's `.cursor/rules/` directory:
   - `00-orchestrator.mdc`
   - `project.mdc`
   - `engineering-discipline.mdc`
   - `environment-and-commands.mdc`
   - `security-and-git.mdc`
   - `testing-conventions.mdc`
   - `compact-handoff.mdc` (requestable)
2. Fill in `project.mdc` — this is the single most impactful rule. Entry points, key commands, pattern catalog, high-conflict files, doc index.
3. Adjust `environment-and-commands.mdc` to reference your secret manager (Doppler, 1Password, Vault, etc.) and your run-command conventions.
4. Adjust `security-and-git.mdc` to reference your base branch (`staging`, `develop`, `main`) and your branch-naming convention.
5. Copy `templates/hooks.json` and `templates/hooks/` into `.cursor/` for hard security enforcement. Make scripts executable: `chmod +x .cursor/hooks/*.sh`.
6. Add `.cursor/auto-context.md` and `.cursor/session-handoff.md` to `.gitignore`.
7. Copy `templates/README-dot-cursor.md` to `.cursor/README.md` and fill in your actual rule/hook/skill inventory.
8. Add skills for any multi-step **operational** procedure you find yourself repeating (secret manager CLI, deployment, database state, integration backfill).
9. Commit the `.cursor/` directory.

Start small. The six always-on rules plus the three security hooks cover most projects. Add glob-gated rules and skills as pain points emerge.

## The Core Rules You Should Start With

See [rules.md](rules.md) for detailed per-rule guidance. The essentials (six always-on):

| Rule | Purpose | Why It Matters |
|---|---|---|
| `00-orchestrator.mdc` | Classifies each request into one mode, points at the matching specialist | Prevents "apply every rule every turn" failure mode; see [orchestration.md](orchestration.md) |
| `project.mdc` | Project identity, entry points, commands, pattern catalog, doc index | Without this, the agent wastes time exploring your repo from scratch every session |
| `engineering-discipline.mdc` | Think-first / stay-in-scope / surgical / simplest-working / done | One rule replaces four overlapping ones (think, goal, surgical, simplicity) |
| `environment-and-commands.mdc` | Secret manager + run commands + feature flags + secret safety | Prevents reading `.env`, hardcoding credentials, committing secrets, or using the wrong run-command shape |
| `security-and-git.mdc` | Stop-and-report for security + multi-agent git workflow + OSS intake | One rule replaces three overlapping ones (security, git, oss-intake) |
| `testing-conventions.mdc` | Test patterns, naming, markers, ship-with-tests policy | Keeps test code consistent across agents and humans |

Plus:

| Rule | Scope | Purpose |
|---|---|---|
| `compact-handoff.mdc` | requestable | Dense handoff format triggered by `compact` / `checkpoint` / `handoff` |
| `deployment.mdc` | glob-gated | Deploy/infra conventions (loads only on Dockerfile / deploy/ / workflows) |
| `hooks.json` + `hooks/` | — | Security trio + optional context-refresh hook |

## Context Budget — First-Class Concern

Every `alwaysApply: true` rule lives in every session's context window. Before adding a new always-on rule, check whether an existing one covers 70%+ of the behavior — extend it instead of adding a new file. See [context-budget.md](context-budget.md) for tier guidance and a real before/after measurement.

## When to Add a Skill

Create a skill when:

- You have a **multi-step operational procedure** the agent gets wrong without detailed guidance (migrations, deployments, integration backfills, CLI workflows).
- The procedure has **safety constraints** (database writes, production rollouts, external integrations).
- You find yourself **re-explaining the same workflow** across multiple sessions.

Skills own *operational* procedures; rules own *code discipline*. When in doubt, rule = "always know this," skill = "do these steps when X."

Don't create skills for simple tasks. See [skills.md](skills.md) for anatomy and templates.

## When to Add Hooks

Add hooks when rules aren't strong enough. Rules are soft — the agent *should* follow them but can slip. **Blocking** hooks are hard — the action is physically denied by the script. **Observation** hooks (`afterFileEdit`, `stop`, `subagentStop`) run for side effects and always exit 0.

Start with the three security hooks (secret detection, git safety, sensitive file blocking). They cost nothing when the agent behaves correctly and catch real mistakes when it doesn't. Add the optional `refresh-compact-context.sh` on `afterFileEdit` + `stop` if you use the compact-handoff pattern.

See [hooks.md](hooks.md) for the full guide and template scripts. Optional workflow hooks are in [EXAMPLES.md](EXAMPLES.md).

## AGENTS.md — Cloud Agent Instructions

If you use Cursor Cloud Agents (background agents in ephemeral VMs), add an `AGENTS.md` to your repo root. It tells the agent how to run your project without your local tools (Doppler, 1Password, etc.), which env vars to use with placeholder values, and any tooling quirks specific to the VM environment.

This is separate from `.cursor/rules/` — rules apply everywhere; `AGENTS.md` is operational setup for cloud-only environments.

See [agents.md](agents.md) for the full guide and template.

## When to Add MCP

Add an MCP connection when your running app exposes tools or data the agent should be able to query. Be careful: some plugins (e.g. the Notion workspace plugin) cost tens of thousands of tokens in every session. Measure the cost before enabling workspace-wide and consider flip-on-demand patterns.

See [mcp.md](mcp.md) for setup patterns and [EXAMPLES.md](EXAMPLES.md) for sample `mcp.json` and plugin `settings.json` snippets.

## Global vs Project Scope

| Scope | Location | Shared via git? | Use for |
|---|---|---|---|
| Project | `your-repo/.cursor/` | Yes | Anything specific to this codebase |
| Global | `~/.cursor/skills/` | No | Cross-project knowledge (SSH hosts, personal workflows) |
| Global | `~/.cursor/rules/` | No | Personal rules you want in every project (e.g. a copy of `compact-handoff.mdc` for machine-wide handoff format) |

**Default to project scope.** Global skills are for things like machine connection details or personal preferences that span multiple repos. If a rule or skill is useful to anyone working on the repo, it belongs in the project.

See [scope.md](scope.md) for detailed guidance.

## Further Reading

- [orchestration.md](orchestration.md) — the implicit-routing pattern
- [context-budget.md](context-budget.md) — the always-on token cost discipline
- [rules.md](rules.md) — per-rule guidance and target tier
- [skills.md](skills.md) — how to structure operational skills
- [hooks.md](hooks.md) — security trio + optional workflow hooks
- [mcp.md](mcp.md) — MCP server patterns
- [agents.md](agents.md) — Cloud Agent setup (`AGENTS.md`)
- [scope.md](scope.md) — project vs global
- [EXAMPLES.md](EXAMPLES.md) — canonical example + copy-paste snippets
