# Cursor Agent Setup Guide

How we configure Cursor's AI agent to work effectively and safely across Wade-O-Lution projects. This guide is a reference for setting up new repos with the same patterns.

## Why Bother?

Without rules and skills, every Cursor session starts from zero. The agent doesn't know your project structure, your deployment pipeline, your database conventions, or what it's not allowed to touch. You end up repeating the same corrections session after session.

Rules, skills, and hooks solve this by giving the agent **persistent institutional knowledge**:

- **Rules** = guardrails and context that apply automatically (like a `.editorconfig` for AI behavior)
- **Skills** = step-by-step procedures the agent follows for specific tasks (like runbooks, but executable)
- **Hooks** = shell scripts that enforce hard constraints by blocking actions before they happen
- **MCP** = live connections to your running services the agent can query

The payoff is immediate: the agent writes code that follows your patterns, avoids your known pitfalls, and knows where things live — without being told each session.

## Directory Structure

```
your-repo/
├── AGENTS.md            # Cloud Agent VM instructions (optional)
├── .cursor/
│   ├── rules/           # Always-on context and guardrails
│   │   ├── project.mdc      # Project identity, entry points, key commands
│   │   ├── code-style.mdc   # Language conventions, patterns, lint config
│   │   ├── environment.mdc  # Secret safety, config patterns, environments
│   │   ├── git-workflow.mdc  # Branch strategy, forbidden ops, multi-agent coordination
│   │   ├── security-protocol.mdc  # Stop-and-report for security findings
│   │   ├── testing-conventions.mdc # Test patterns, naming, mandatory coverage
│   │   ├── goal-driven-execution.mdc  # Scope management, done criteria
│   │   ├── surgical-changes.mdc       # Minimal edits, service boundaries
│   │   ├── think-before-coding.mdc    # Pattern discovery, blast radius
│   │   └── ...               # Domain-specific rules as needed
│   ├── skills/          # On-demand procedures for specific tasks
│   │   ├── migration-workflow/
│   │   │   └── SKILL.md
│   │   ├── search-first/     # Adopt/Extend/Compose/Build decision matrix
│   │   │   └── SKILL.md
│   │   └── ...
│   ├── hooks/           # Hard enforcement scripts (block bad actions)
│   │   ├── detect-secrets.sh     # Block leaked API keys in prompts
│   │   ├── block-no-verify.sh    # Prevent --no-verify in git commands
│   │   └── block-sensitive-reads.sh  # Block reading .env, .key, .pem files
│   ├── hooks.json       # Hook event → script mapping
│   ├── mcp.json         # MCP server connections (optional)
│   └── settings.json    # Cursor plugin settings (optional)
```

Everything in `.cursor/` is safe to commit to git. It contains no secrets — just guidance for the AI agent that should be shared with collaborators.

## Quick Start for a New Repo

1. Copy the templates from `templates/` into your repo's `.cursor/` directory
2. Edit `project.mdc` — this is the single most impactful rule
3. Add a `code-style.mdc` if you have language conventions
4. Add safety rules for anything the agent shouldn't touch (`environment.mdc`, `git-workflow.mdc`)
5. Copy `templates/hooks.json` and `templates/hooks/` into `.cursor/` for hard security enforcement
6. Make hook scripts executable: `chmod +x .cursor/hooks/*.sh`
7. Add skills for any multi-step procedure you find yourself repeating
8. Commit the `.cursor/` directory to git

Start small. Two or three rules plus the security hooks is plenty. Add skills as pain points emerge.

---

## The Core Files You Should Start With

See [rules.md](rules.md) for detailed guidance on rules. The essentials:

| File | Purpose | Why It Matters |
|------|---------|---------------|
| `project.mdc` | Project identity, entry points, commands | Without this, the agent wastes time exploring your repo from scratch every session |
| `code-style.mdc` | Language conventions, patterns | Prevents the agent from writing code in a style that doesn't match your project |
| `environment.mdc` | Secret safety, config patterns | Prevents the agent from reading `.env`, hardcoding credentials, or committing secrets |
| `git-workflow.mdc` | Branch strategy, forbidden ops | Prevents the agent from pushing to main, force pushing, or skipping CI |
| `security-protocol.mdc` | Stop-and-report for security issues | Ensures the agent flags hardcoded secrets, injection vectors, and auth gaps immediately |
| `testing-conventions.mdc` | Test patterns, naming, markers | Keeps test code consistent: AAA structure, descriptive names, mandatory test coverage |
| `goal-driven-execution.mdc` | Scope management, done criteria | Prevents scope creep, "while I'm here" refactors, and unrelated changes |
| `surgical-changes.mdc` | Minimal edits, one concern per commit | Keeps PRs small and focused, respects service boundaries |
| `think-before-coding.mdc` | Reason before implementing | Forces pattern discovery and blast radius checks before writing code |
| `hooks.json` + `hooks/` | Hard enforcement scripts | Blocks leaked secrets, `--no-verify`, and sensitive file reads even if rules are ignored |

## When to Add a Skill

Create a skill when:
- You have a **multi-step procedure** that the agent gets wrong without detailed guidance
- The procedure has **safety constraints** (like database migrations, deployments, integration changes)
- You find yourself **re-explaining the same workflow** across multiple sessions

Don't create skills for simple tasks. If the agent can figure it out from the rules and codebase alone, a skill adds noise without value.

See [skills.md](skills.md) for the anatomy of a good skill and templates.

## When to Add Hooks

Add hooks when rules aren't strong enough. Rules are "soft" — the agent *should* follow them but can slip. Hooks are "hard" — the action is physically blocked by the script.

Start with the three security hooks (secret detection, git safety, sensitive file blocking). They cost nothing when the agent behaves correctly and catch real mistakes when it doesn't.

See [hooks.md](hooks.md) for the full guide and template scripts.

## AGENTS.md — Cloud Agent Instructions

If you use Cursor Cloud Agents (background agents that run in ephemeral VMs), add an `AGENTS.md` to your repo root. It tells the agent how to run your project without your local tools (Doppler, 1Password, etc.), which env vars to use with placeholder values, and any tooling quirks specific to the VM environment.

This is separate from `.cursor/rules/` — rules apply to all sessions (local and cloud), while `AGENTS.md` is operational setup for cloud-only environments.

See [agents.md](agents.md) for the full guide and template.

## When to Add MCP

Add an MCP connection when your running app exposes tools or data the agent should be able to query. For example, our knowledge base API exposes an MCP server that lets the agent search meetings, look up people, and query the knowledge graph — without writing ad-hoc database queries.

See [mcp.md](mcp.md) for setup patterns.

## Global vs Project Scope

| Scope | Location | Shared via git? | Use for |
|-------|----------|----------------|---------|
| Project | `your-repo/.cursor/` | Yes | Anything specific to this codebase |
| Global | `~/.cursor/skills/` | No | Cross-project knowledge (SSH hosts, personal workflows) |

**Default to project scope.** Global skills are for things like machine connection details or personal preferences that span multiple repos. If a rule or skill is useful to anyone working on the repo, it belongs in the project.

See [scope.md](scope.md) for detailed guidance on what goes where.
