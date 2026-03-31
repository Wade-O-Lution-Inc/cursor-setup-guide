# Global vs Project Scope

Rules and skills can live in two places. Choosing the right scope avoids duplication and keeps sensitive info out of shared repos.

## Project Scope (`.cursor/` in your repo)

```
your-repo/.cursor/
├── rules/
├── skills/
├── mcp.json
└── settings.json
```

**Committed to git. Shared with collaborators.**

Use for anything specific to this codebase that any contributor (human or AI) should know:

- Project structure and entry points
- Code conventions and patterns
- Safety guardrails (secrets, git workflow, deployment)
- Multi-step procedures (migrations, integrations, releases)
- MCP connections to the app's own services

### Multi-Root Workspaces

If your workspace contains multiple repos (like we have `meeting_notes_workflow` + `Integrity_Lab`), each repo has its own `.cursor/` directory. Rules from both repos are loaded when the workspace is open. This means:

- Rules in `repo-a/.cursor/rules/` are visible when working in `repo-b/` too
- You don't need to duplicate shared rules — but you should keep rules repo-specific since they travel with the repo when opened solo

## Global Scope (`~/.cursor/skills/`)

```
~/.cursor/
├── skills/
│   └── your-skill/
│       └── SKILL.md
└── plans/          ← Cursor-managed, don't touch
```

**Not in any git repo. Personal to your machine.**

Use for cross-project knowledge that doesn't belong in any single repo:

| Good for global scope | Why |
|----------------------|-----|
| SSH connection details for shared machines | Contains IPs/hostnames, relevant across repos |
| Personal workflow preferences | Your style, not the team's |
| Cross-project deployment procedures | Span multiple repos |

### Real Example: Mac Mini SSH

We have a global skill for connecting to our Mac mini:

```
~/.cursor/skills/mac-mini-ssh/SKILL.md
```

This contains the Tailscale IP, SSH user, common operations (deploy Alloy, restart services, tail logs), and PATH caveats for non-interactive SSH. It lives globally because:

1. Both `meeting_notes_workflow` and `Integrity_Lab` need it
2. It contains a machine-specific IP address
3. It's operational knowledge, not codebase knowledge

## Decision Flowchart

```
Is this specific to one codebase?
├── Yes → Project scope (.cursor/ in that repo)
│
├── No, it spans multiple repos
│   ├── Does it contain machine-specific details (IPs, paths)?
│   │   └── Yes → Global scope (~/.cursor/skills/)
│   │
│   └── No, it's a shared convention
│       └── Put it in the most relevant repo, or duplicate
│           if both repos truly need independent copies
│
└── No, it's personal preference
    └── Global scope (~/.cursor/skills/)
```

## What NOT to Put in Global Scope

- **API keys or tokens** — Use environment variables, not skills
- **Project-specific procedures** — These should travel with the repo
- **Anything a collaborator needs** — If it's not in git, they won't have it

## The `~/.cursor/` Directory

The global `~/.cursor/` directory also contains Cursor-managed files:

| Path | Managed by | Safe to edit? |
|------|-----------|---------------|
| `~/.cursor/skills/` | You | Yes — this is where your global skills go |
| `~/.cursor/plans/` | Cursor | No — auto-generated plan files |
| `~/.cursor/plugins/` | Cursor | No — plugin cache, managed automatically |
| `~/.cursor/skills-cursor/` | Cursor | No — built-in skills, never create files here |

Only create files in `~/.cursor/skills/`. Everything else is managed by Cursor.
