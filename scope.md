# Global vs Project Scope

Rules and skills can live in two places. Choosing the right scope avoids duplication and keeps sensitive info out of shared repos.

**Wade-O-Lution global harness:** [global-env.md](./global-env.md) · **Day-1:** [day1-setup.md](./day1-setup.md)

## Multi-repo ownership map

| Repo | Owns | Spec Kit / SDD? |
|------|------|-----------------|
| **cursor-setup-guide** (this repo) | Adoption docs + templates | Documents only — no product `.specify/` runtime |
| **sdd-orchestrator** | Portable ctl (`sdd-ctl`, `sdd-run`, phase models, swarms) | Runtime SSOT for orchestration |
| **meeting_notes_workflow** | Gold product harness (`.specify/`, `sdd-entry`, SDD user guide) | Yes — primary SDD reference |
| **Integrity_Lab** | Mac mini platform (Caddy, k3s, Alloy, Terraform) | **No** — use lab skills/gates, not Spec Kit |
| **repo-index** | Swarm composition / coordination plane | Swarm protocol; not Spec Kit product features |
| Platform stack (`data-api`, `integrity-ts`, …) | Product APIs / UI | Adopt SDD via [specify/bootstrap.md](./specify/bootstrap.md) when needed |

Workspaces often include `meeting_notes_workflow` + `Integrity_Lab` + `repo-index`. Each has its own `.cursor/`. The **global skill router** (`~/.cursor/hooks/workspace-skill-router.sh`) detects the active repo — see [global-env.md](./global-env.md).

---

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

Use for anything specific to this codebase:

- Project structure and entry points
- Code conventions and patterns
- Safety guardrails (secrets, git workflow, deployment)
- Hard enforcement hooks
- Multi-step procedures (migrations, integrations, releases)
- MCP connections to the app's own services
- Spec Kit `.specify/` workflows (`sdd`, `sdd-remote`), `sdd-entry`, `.specify/orchestrator.json`

### Multi-root note

Rules in `repo-a/.cursor/rules/` may be visible when working in `repo-b/` in a multi-root window. Keep rules repo-specific so they travel when a repo is opened solo.

---

## Global Scope (`~/.cursor/`)

```
~/.cursor/
├── hooks.json + hooks/     # Skill router (beforeSubmitPrompt)
├── rules/                  # Cross-repo alwaysApply safety rules
├── skills/                 # Global skills + pointer stubs
├── sdd-orchestrator-ctl/   # Clone of Wade-O-Lution-Inc/sdd-orchestrator
├── bin/                    # Helpers (e.g. archive-stale-plans.sh)
├── plans/                  # Cursor-managed (archive, don't commit)
├── skills-cursor/          # Built-in — never hand-edit
├── plugins/                # Cursor-managed
└── mcp.json                # Optional user-level MCP (keep minimal)
```

**Not in product git.** Install from [templates/global/](./templates/global/) + clone [sdd-orchestrator](https://github.com/Wade-O-Lution-Inc/sdd-orchestrator) to `~/.cursor/sdd-orchestrator-ctl` ([day1-setup.md](./day1-setup.md)).

| Good for global scope | Why |
|----------------------|-----|
| Skill router hooks | Must run in every workspace |
| Always-on safety rules (git, supply chain, mixed-concern, platform inheritance) | Same policy across all Wade-O-Lution repos |
| `lab-host-ssh`, browser automation, session-handoff | Cross-repo ops |
| `sdd-orchestrator` skill + `sdd-orchestrator-ctl` | Shared SDD phase gating |
| Pointer stubs (`speckit-*`, Notion, …) | Discovery without duplicating large skill bodies |

### Real Example: Lab host SSH

```
~/.cursor/skills/lab-host-ssh/SKILL.md
```

(Formerly `mac-mini-ssh`.) Tailscale SSH ops for the Mac mini — used by meeting_notes and Integrity_Lab. Prefer MagicDNS names over hardcoding IPs; never put tokens in the skill.

---

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
- **A private fork of sdd-orchestrator** — clone the GitHub repo; pull to update

## Spec-Driven Development (SDD)

Full docs: **[specify/](./specify/)** · placement: **[specify/managed-vs-custom.md](./specify/managed-vs-custom.md)**

| Asset | Scope | Notes |
|-------|-------|-------|
| `.specify/`, `specs/`, SDD docs | **Project** | Ephemeral planning on feature branches |
| `.specify/orchestrator.json` | **Project** | Optional policy overrides for ctl |
| `sdd` / `sdd-remote` workflows | **Project** | From [templates/spec-kit/](templates/spec-kit/) |
| `sdd-entry` skill | **Project** | Chat front door only |
| `speckit-*` phase skills | **Project** (managed) + optional **global stubs** | Worker procedures |
| `sdd-orchestrator` + `sdd-orchestrator-ctl` | **Global** | Always-on phase gating |

**Live product reference:** [meeting_notes_workflow](https://github.com/Wade-O-Lution-Inc/meeting_notes_workflow)  
**Orchestrator runtime:** [sdd-orchestrator](https://github.com/Wade-O-Lution-Inc/sdd-orchestrator)
