# Cursor Agent Setup Guide

How Wade-O-Lution configures Cursor’s AI agent — with **Spec Kit / `specify` workflows** as the primary documentation focus, plus the supporting rules, skills, hooks, and global machine harness.

## Start here: Specify & SDD

→ **[specify/](./specify/)** — full documentation of the `specify` workflow, org customizations, and what you can still change.

| I want to… | Go to |
|------------|--------|
| Run SDD today (chat + CLI) | [specify/quick-start.md](./specify/quick-start.md) |
| Understand Spec Kit vs our layers | [specify/overview.md](./specify/overview.md) |
| Adopt SDD in a new repo | [specify/bootstrap.md](./specify/bootstrap.md) |
| See `sdd` / `sdd-remote` flags & gates | [specify/workflows.md](./specify/workflows.md) |
| Tune models / phase gates | [specify/orchestrator.md](./specify/orchestrator.md) |
| Know managed vs custom files | [specify/managed-vs-custom.md](./specify/managed-vs-custom.md) |

**Live reference:** [meeting_notes_workflow](https://github.com/Wade-O-Lution-Inc/meeting_notes_workflow) (`.specify/`, `sdd-entry`, docs under `docs/agents/`).

**CLI pin:** Spec Kit **`0.10.2`** (`uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@v0.10.2`).

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
├── specify/                 # ★ Canonical Spec Kit + customization docs
├── global-env.md            # Machine ~/.cursor harness
├── scope.md                 # Project vs global placement
├── rules.md / skills.md / hooks.md / agents.md / mcp.md
├── EXAMPLES.md              # Snippets (incl. specify run/resume)
└── templates/               # Copy-paste starters (workflows, hooks, rules, skills)
    ├── spec-kit/            # sdd + sdd-remote YAMLs, init checklist, …
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
| [rules.md](./rules.md) | Writing `.mdc` rules; glob-gated SDD rules |
| [skills.md](./skills.md) | Skill anatomy; `speckit-*` vs `sdd-entry` vs orchestrator |
| [hooks.md](./hooks.md) | Blocking trio + global skill router + compact handoff |
| [scope.md](./scope.md) | What belongs in the repo vs `~/.cursor/` |
| [global-env.md](./global-env.md) | Bootstrap a developer machine |
| [agents.md](./agents.md) | Cloud Agent `AGENTS.md` |
| [mcp.md](./mcp.md) | MCP connections |
| [EXAMPLES.md](./EXAMPLES.md) | Concrete JSON / CLI examples |

Legacy filenames [sdd-user-guide.md](./sdd-user-guide.md) and [spec-driven-development.md](./spec-driven-development.md) redirect into `specify/`.
