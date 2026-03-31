# Cursor Agent Setup Guide

How we configure Cursor's AI agent to work effectively and safely across Wade-O-Lution projects. This guide is a reference for setting up new repos with the same patterns.

## Why Bother?

Without rules and skills, every Cursor session starts from zero. The agent doesn't know your project structure, your deployment pipeline, your database conventions, or what it's not allowed to touch. You end up repeating the same corrections session after session.

Rules and skills solve this by giving the agent **persistent institutional knowledge**:

- **Rules** = guardrails and context that apply automatically (like a `.editorconfig` for AI behavior)
- **Skills** = step-by-step procedures the agent follows for specific tasks (like runbooks, but executable)
- **MCP** = live connections to your running services the agent can query

The payoff is immediate: the agent writes code that follows your patterns, avoids your known pitfalls, and knows where things live — without being told each session.

## Directory Structure

```
your-repo/
├── .cursor/
│   ├── rules/           # Always-on context and guardrails
│   │   ├── project.mdc      # Project identity, entry points, key commands
│   │   ├── code-style.mdc   # Language conventions, patterns, lint config
│   │   ├── environment.mdc  # Secret safety, config patterns, environments
│   │   ├── git-workflow.mdc  # Branch strategy, forbidden ops, approval gates
│   │   └── ...               # Domain-specific rules as needed
│   ├── skills/          # On-demand procedures for specific tasks
│   │   ├── migration-workflow/
│   │   │   └── SKILL.md
│   │   ├── add-integration/
│   │   │   └── SKILL.md
│   │   └── ...
│   ├── mcp.json         # MCP server connections (optional)
│   └── settings.json    # Cursor plugin settings (optional)
```

Everything in `.cursor/` is safe to commit to git. It contains no secrets — just guidance for the AI agent that should be shared with collaborators.

## Quick Start for a New Repo

1. Copy the templates from `templates/` into your repo's `.cursor/` directory
2. Edit `project.mdc` — this is the single most impactful rule
3. Add a `code-style.mdc` if you have language conventions
4. Add safety rules for anything the agent shouldn't touch (`environment.mdc`, `git-workflow.mdc`)
5. Add skills for any multi-step procedure you find yourself repeating
6. Commit the `.cursor/` directory to git

Start small. Two or three rules is plenty. Add skills as pain points emerge.

---

## The Four Files You Should Start With

See [rules.md](rules.md) for detailed guidance. The essentials:

| Rule | Purpose | Why It Matters |
|------|---------|---------------|
| `project.mdc` | Project identity, entry points, commands | Without this, the agent wastes time exploring your repo from scratch every session |
| `code-style.mdc` | Language conventions, patterns | Prevents the agent from writing code in a style that doesn't match your project |
| `environment.mdc` | Secret safety, config patterns | Prevents the agent from reading `.env`, hardcoding credentials, or committing secrets |
| `git-workflow.mdc` | Branch strategy, forbidden ops | Prevents the agent from pushing to main, force pushing, or skipping CI |

## When to Add a Skill

Create a skill when:
- You have a **multi-step procedure** that the agent gets wrong without detailed guidance
- The procedure has **safety constraints** (like database migrations, deployments, integration changes)
- You find yourself **re-explaining the same workflow** across multiple sessions

Don't create skills for simple tasks. If the agent can figure it out from the rules and codebase alone, a skill adds noise without value.

See [skills.md](skills.md) for the anatomy of a good skill and templates.

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
