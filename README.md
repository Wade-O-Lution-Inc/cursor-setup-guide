# Cursor Agent Setup Guide

**Adoption hub** for how Wade-O-Lution configures Cursor’s AI agent — Spec Kit / SDD, rules, skills, hooks, MCP, and the global `~/.cursor/` harness.

This repo is **not** the runtime source of truth. It teaches adopters and ships copy-paste templates. Live engines and product guides live elsewhere:

| Concern | Source of truth | This repo |
|---------|-----------------|-----------|
| Orchestrator runtime (`sdd-ctl`, phase models, swarms) | [sdd-orchestrator](https://github.com/Wade-O-Lution-Inc/sdd-orchestrator) → `~/.cursor/sdd-orchestrator-ctl` | Install steps + thin overview |
| Product-facing daily SDD guide | [meeting_notes_workflow `SDD_USER_GUIDE.md`](https://github.com/Wade-O-Lution-Inc/meeting_notes_workflow/blob/main/docs/agents/SDD_USER_GUIDE.md) | Portable template under `templates/spec-kit/` |
| Working workflows / skills in a product repo | That product repo (gold: meeting_notes) | Synced starters — see [templates/SYNC.md](./templates/SYNC.md) |

**CLI pin:** Spec Kit **`0.10.2`** (`uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@v0.10.2`).

---

## Start here

| I want to… | Go to |
|------------|--------|
| **Set up a new machine (day 1)** | [day1-setup.md](./day1-setup.md) |
| Run SDD today (chat + CLI) | [specify/quick-start.md](./specify/quick-start.md) |
| Understand Spec Kit vs our layers | [specify/overview.md](./specify/overview.md) |
| Adopt SDD in a new repo | [specify/bootstrap.md](./specify/bootstrap.md) |
| See `sdd` / `sdd-remote` flags | [specify/workflows.md](./specify/workflows.md) |
| Understand the orchestrator (`sdd-ctl`) | [specify/orchestrator.md](./specify/orchestrator.md) |
| Tune models / gates | [sdd-orchestrator README](https://github.com/Wade-O-Lution-Inc/sdd-orchestrator#readme) + local `phase-models.json` |
| Know managed vs custom files | [specify/managed-vs-custom.md](./specify/managed-vs-custom.md) |

Full Spec Kit docs: **[specify/](./specify/)**.

Deprecated workflow IDs (`sdd-full`, `sdd-api`, …) are **removed** from the meeting_notes registry. Migration mapping only: [templates/spec-kit/deprecated-aliases.md](./templates/spec-kit/deprecated-aliases.md).

---

## Why the rest of this repo exists

Without rules and skills, every Cursor session starts from zero. Spec Kit structures multi-step features; rules/skills/hooks keep day-to-day coding safe and consistent.

| Layer | Role |
|-------|------|
| **Specify / SDD** | Reviewable `spec → plan → tasks → confidence` before/alongside code |
| **Rules** | Always-on or glob-gated guardrails (`.mdc`) |
| **Skills** | On-demand procedures (`SKILL.md`) |
| **Hooks** | Hard blocks + skill routing + observation side-effects |
| **MCP** | Live tool connections to running services |
| **Global `~/.cursor/`** | Cross-repo router, safety rules, `sdd-orchestrator` — [global-env.md](./global-env.md) |

---

## Directory map (this guide)

```
cursor-setup-guide/
├── day1-setup.md            # New machine checklist
├── specify/                 # Spec Kit + customization docs
├── global-env.md            # Machine ~/.cursor harness
├── scope.md                 # Project vs global + multi-repo map
├── rules.md / skills.md / hooks.md / agents.md / mcp.md
├── EXAMPLES.md              # Snippets (incl. specify + sdd-ctl)
└── templates/               # Copy-paste starters (see SYNC.md)
    ├── spec-kit/            # sdd + sdd-remote YAMLs, policy example, …
    ├── global/              # Skill router + alwaysApply rules
    ├── skills/sdd-entry/
    └── rules/sdd-orchestrator-snippet.mdc
```

---

## Quick start for a new *product* repo (non-SDD baseline)

1. Copy security hooks + core rules from `templates/` into `your-repo/.cursor/`
2. Edit `project.mdc`
3. `chmod +x .cursor/hooks/*.sh`
4. Commit `.cursor/`

For multi-step features, continue with [specify/bootstrap.md](./specify/bootstrap.md).

---

## Supporting guides

| Doc | Topic |
|-----|--------|
| [day1-setup.md](./day1-setup.md) | New laptop / Cloud Agent machine checklist |
| [rules.md](./rules.md) | Writing `.mdc` rules; glob-gated SDD rules |
| [skills.md](./skills.md) | Skill anatomy; `speckit-*` vs `sdd-entry` vs orchestrator |
| [hooks.md](./hooks.md) | Blocking trio + global skill router + compact handoff |
| [scope.md](./scope.md) | Repo vs `~/.cursor/` + multi-repo ownership |
| [global-env.md](./global-env.md) | Bootstrap a developer machine |
| [agents.md](./agents.md) | Cloud Agent `AGENTS.md` |
| [mcp.md](./mcp.md) | MCP connections |
| [EXAMPLES.md](./EXAMPLES.md) | Concrete JSON / CLI examples |
| [templates/SYNC.md](./templates/SYNC.md) | How templates stay aligned with meeting_notes |

Legacy filenames [sdd-user-guide.md](./sdd-user-guide.md) and [spec-driven-development.md](./spec-driven-development.md) redirect into `specify/`.
