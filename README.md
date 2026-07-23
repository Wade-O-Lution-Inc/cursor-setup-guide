# Cursor Agent Setup Guide

Adoption hub for Wade-O-Lution Cursor setup: machine harness, product `.cursor/`, optional Spec Kit / SDD, and copy-paste templates. **Not** the runtime source of truth.

| Concern | Source of truth | This repo |
|---------|-----------------|-----------|
| Orchestrator runtime (`sdd-ctl`) | [sdd-orchestrator](https://github.com/Wade-O-Lution-Inc/sdd-orchestrator) → `~/.cursor/sdd-orchestrator-ctl` | Install + overview |
| Product daily SDD guide | [meeting_notes `SDD_USER_GUIDE`](https://github.com/Wade-O-Lution-Inc/meeting_notes_workflow/blob/staging/docs/agents/SDD_USER_GUIDE.md) | Portable template under `templates/spec-kit/` |
| Live product harness | That product repo (gold: meeting_notes) | Synced starters — [templates/SYNC.md](./templates/SYNC.md) |

**Pins:** Spec Kit **0.13.0** · orchestrator always `sdd-ctl sync` → clean `origin/main`.

---

## Start here

| I want to… | Go |
|------------|-----|
| **Set up a new machine** | [docs/day1.md](./docs/day1.md) |
| **Add / adapt harness on a product repo** | [docs/product-repo.md](./docs/product-repo.md) |
| **Adopt Spec Kit / SDD** | [docs/specify/bootstrap.md](./docs/specify/bootstrap.md) → [quick-start](./docs/specify/quick-start.md) |
| **Know what lives where** | [docs/ownership.md](./docs/ownership.md) |
| **Maintain templates (maintainers)** | [templates/SYNC.md](./templates/SYNC.md) · `./bin/cursor-setup sync-check` |

meeting_notes is an optional **gold reference**, not a day-1 prerequisite.

```bash
gh repo clone Wade-O-Lution-Inc/cursor-setup-guide
cd cursor-setup-guide
./bin/cursor-setup doctor
./bin/cursor-setup install-global
```

What the CLI touches (command → files): see [docs/day1.md](./docs/day1.md#what-the-cli-does) and `./bin/cursor-setup --help`.

---

## Layers (5 lines)

| Layer | Role |
|-------|------|
| **Global `~/.cursor/`** | Cross-repo router, safety rules, `sdd-orchestrator` |
| **Product `.cursor/`** | Repo rules, hooks, ops skills |
| **Specify / SDD** | Optional multi-step `spec → plan → tasks → confidence` |
| **Skills / hooks / MCP** | Procedures, enforcement, live tools |
| **This guide** | Docs + templates + install CLI |

---

## More docs

[day1](./docs/day1.md) · [ownership](./docs/ownership.md) · [product-repo](./docs/product-repo.md) · [rules](./docs/rules.md) · [skills](./docs/skills.md) · [hooks](./docs/hooks.md) · [mcp](./docs/mcp.md) · [company-mcp](./docs/company-mcp.md) · [agents](./docs/agents.md) · [specify/](./docs/specify/) · [CONTENT_EVAL](./docs/CONTENT_EVAL.md) (revamp audit)

Legacy root filenames redirect into `docs/`.
