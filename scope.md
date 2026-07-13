# Global vs Project Scope

Rules and skills can live in two places. Choosing the right scope avoids duplication and keeps sensitive info out of shared repos.

**Wade-O-Lution global harness (current):** [global-env.md](./global-env.md)

## Project Scope (`.cursor/` in your repo)

```
your-repo/.cursor/
├── rules/
├── skills/
├── hooks/         # Hook enforcement scripts
├── hooks.json     # Hook event → script mapping
├── mcp.json
└── settings.json
```

**Committed to git. Shared with collaborators.**

Use for anything specific to this codebase that any contributor (human or AI) should know:

- Project structure and entry points
- Code conventions and patterns
- Safety guardrails (secrets, git workflow, deployment)
- Hard enforcement hooks (secret detection, command blocking, file read blocking)
- Multi-step procedures (migrations, integrations, releases)
- MCP connections to the app's own services
- Spec Kit `.specify/` workflows (`sdd`, `sdd-remote`) and `sdd-entry`

### Multi-Root Workspaces

Workspaces often include `meeting_notes_workflow` + `Integrity_Lab` + `repo-index` (and separately the platform stack). Each repo has its own `.cursor/`. The **global skill router** (`~/.cursor/hooks/workspace-skill-router.sh`) detects which repo is active and injects the right skill list — see [global-env.md](./global-env.md).

- Rules in `repo-a/.cursor/rules/` are visible when working in `repo-b/` too in a multi-root window
- Keep rules repo-specific so they travel when a repo is opened solo

## Global Scope (`~/.cursor/`)

```
~/.cursor/
├── hooks.json + hooks/     # Skill router (beforeSubmitPrompt)
├── rules/                  # Cross-repo alwaysApply safety rules
├── skills/                 # Global skills + pointer stubs
├── sdd-orchestrator-ctl/   # SDD multi-model control plane
├── bin/                    # Helpers (e.g. archive-stale-plans.sh)
├── plans/                  # Cursor-managed (archive, don't commit)
├── skills-cursor/          # Built-in — never hand-edit
├── plugins/                # Cursor-managed
└── mcp.json                # Optional user-level MCP (keep minimal)
```

**Not in product git.** Sync new machines from [templates/global/](./templates/global/) + a known-good copy of `sdd-orchestrator-ctl`.

| Good for global scope | Why |
|----------------------|-----|
| Skill router hooks | Must run in every workspace |
| Always-on safety rules (git, supply chain, mixed-concern, platform inheritance) | Same policy across all Wade-O-Lution repos |
| `lab-host-ssh`, browser automation, session-handoff | Cross-repo ops |
| `sdd-orchestrator` + `sdd-orchestrator-ctl` | Shared SDD phase gating |
| Pointer stubs (`speckit-*`, Notion, overengineering, …) | Discovery without duplicating large skill bodies |

### Real Example: Lab host SSH

```
~/.cursor/skills/lab-host-ssh/SKILL.md
```

(Formerly `mac-mini-ssh`.) Tailscale SSH ops for the Mac mini — used by meeting_notes and Integrity_Lab. Lives globally because it spans repos and is operational, not product code. Prefer Tailscale MagicDNS names over hardcoding IPs; never put tokens in the skill.

## Decision Flowchart

```
Is this specific to one codebase?
├── Yes → Project scope (.cursor/ in that repo)
│
├── No, it spans multiple Wade-O-Lution repos
│   ├── Cross-repo safety / routing / SDD orchestrator?
│   │   └── Global (~/.cursor/) — document in global-env.md
│   ├── Machine-specific ops (SSH, lab)?
│   │   └── Global skill (no secrets in file)
│   └── Shared product convention?
│       └── Owning repo + optional global stub
│
└── Personal preference only
    └── Global skill/rule (your machine)
```

## What NOT to Put in Global Scope

- **API keys or tokens** — Doppler / env vars
- **Product procedures collaborators need** — put in the repo
- **Full duplicates of large repo skills** — use pointer stubs

## Spec-Driven Development (SDD)

| Asset | Scope | Notes |
|-------|-------|-------|
| `.specify/`, `specs/`, SDD docs | **Project** | Ephemeral planning on feature branches |
| `sdd` / `sdd-remote` workflows | **Project** | From [templates/spec-kit/](templates/spec-kit/) |
| `sdd-entry` skill | **Project** | Chat front door only |
| `speckit-*` phase skills | **Project** (managed) + optional **global stubs** | Worker procedures; stubs point at owning repo |
| `sdd-orchestrator` + `sdd-orchestrator-ctl` | **Global** | Always-on phase gating |

See [spec-driven-development.md](spec-driven-development.md) and [global-env.md](./global-env.md).

**Reference:** [meeting_notes_workflow](https://github.com/Wade-O-Lution-Inc/meeting_notes_workflow)
