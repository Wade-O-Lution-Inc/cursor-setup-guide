# Global Cursor Environment (Wade-O-Lution)

Canonical description of the **machine-local** Cursor harness under `~/.cursor/`. Project repos still own most rules/skills in git; this layer adds cross-repo routing, always-on safety rules, Spec Kit stubs, and the SDD multi-model control plane.

**Pair with:** [day1-setup.md](./day1-setup.md) · [specify/](./specify/) · [scope.md](./scope.md) · [hooks.md](./hooks.md)  
**Live product reference:** [meeting_notes_workflow](https://github.com/Wade-O-Lution-Inc/meeting_notes_workflow)  
**Orchestrator runtime:** [sdd-orchestrator](https://github.com/Wade-O-Lution-Inc/sdd-orchestrator)

---

## Layout (editable vs Cursor-managed)

```
~/.cursor/
├── hooks.json                 # YOU — global beforeSubmitPrompt → skill router
├── hooks/
│   ├── route-skills-before-prompt.sh   # thin exec → workspace-skill-router.sh
│   ├── workspace-skill-router.sh       # mandatory skill/rule suggestions
│   └── workspace-skill-router.test.sh
├── rules/                     # YOU — cross-repo alwaysApply / on-demand rules
├── skills/                    # YOU — global skills + pointer stubs
│   └── sdd-orchestrator → ../sdd-orchestrator-ctl/skills/sdd-orchestrator
├── sdd-orchestrator-ctl/      # YOU — clone of Wade-O-Lution-Inc/sdd-orchestrator
├── bin/                       # YOU — helper CLIs (e.g. archive-stale-plans.sh)
├── plans/                     # Cursor — agent plans (archive via bin helper)
├── skills-cursor/             # Cursor — built-in skills; never hand-edit
├── plugins/                   # Cursor — plugin cache
├── mcp.json                   # YOU — optional user-level MCP (keep minimal)
└── cli-config.json            # Cursor CLI config
```

Templates for the YOU-owned pieces (except ctl) live under [templates/global/](./templates/global/).

---

## Skill routing (mandatory)

Every prompt runs a global `beforeSubmitPrompt` hook that injects an **agent_message** starting with `MANDATORY SKILL ROUTING` listing skill/rule paths to read before acting.

| File | Role |
|------|------|
| `~/.cursor/hooks.json` | Registers `hooks/route-skills-before-prompt.sh` |
| `route-skills-before-prompt.sh` | `exec` into the router |
| `workspace-skill-router.sh` | Detects repo (`meeting_notes_workflow`, `Integrity_Lab`, `repo-index`, platform repos…) and prompt keywords; suggests repo + global skills |

**Rule:** [skill-routing-mandate.mdc](./templates/global/rules/skill-routing-mandate.mdc) (`alwaysApply: true`) — agents must read every listed path before implementing.

Repo-local `beforeSubmitPrompt` hooks (e.g. meeting_notes) may add repo-only suggestions; the global router is the cross-repo source of truth. Integrity_Lab may use a repo-local router for lab skills to avoid duplicate mandatory lists — see that repo’s orchestrator rule.

---

## Always-on global rules

Install into `~/.cursor/rules/` (templates in [templates/global/rules/](./templates/global/rules/)):

| Rule | Purpose |
|------|---------|
| `git-safety.mdc` | No force-push / no push to main / no `--no-verify` unless asked |
| `mixed-concern-guardrail.mdc` | Split work across 3+ boundaries |
| `platform-inheritance.mdc` | Industry → Industry Type → Customer; no customer forks |
| `skill-routing-mandate.mdc` | Honor hook-injected skill lists |
| `supply-chain-defense.mdc` | No unsolicited npm/uv installs; MCP/lockfile hygiene |

On-demand (not alwaysApply): `compact-handoff.mdc`, `design-pattern-guardrails.mdc`, `team-topologies-review-loop.mdc`, `multi-repo-workspace.mdc` (platform workspace map).

---

## Global skills pattern

| Kind | Examples | Notes |
|------|----------|-------|
| **Owned globally** | `lab-host-ssh`, `browser-automation`, `session-handoff` | Cross-repo ops; no secrets in files |
| **Symlink from ctl** | `sdd-orchestrator` | Points at `sdd-orchestrator-ctl/skills/sdd-orchestrator` |
| **Pointer stubs** | `speckit-*`, `notion-integration`, `skill-supply-chain-review`, `overengineering-*` | Thin SKILL.md → canonical copy in owning repo |
| **Built-in** | `~/.cursor/skills-cursor/*` | Cursor product skills — leave alone |

---

## SDD control plane (global)

Full docs: **[specify/orchestrator.md](./specify/orchestrator.md)**.

| Asset | Role |
|-------|------|
| `~/.cursor/skills/sdd-orchestrator/SKILL.md` | Interactive Task driver (`auto_chain` / `single_phase`) |
| `~/.cursor/sdd-orchestrator-ctl/bin/sdd-ctl` | Deterministic plan / hooks / record / report (no API key) |
| `~/.cursor/sdd-orchestrator-ctl/bin/sdd-run` | Headless SDK runner (needs venv + `CURSOR_API_KEY`) |
| Project `sdd-entry` | Chat front door — FEATURE_DIR + PHASE → orchestrator |
| Project `.specify/orchestrator.json` | Optional policy overrides |

Install:

```bash
gh repo clone Wade-O-Lution-Inc/sdd-orchestrator ~/.cursor/sdd-orchestrator-ctl
ln -sfn ~/.cursor/sdd-orchestrator-ctl/skills/sdd-orchestrator ~/.cursor/skills/sdd-orchestrator
git -C ~/.cursor/sdd-orchestrator-ctl pull --ff-only   # updates
```

CLI in repos: `specify workflow run sdd` / `sdd-remote` — [specify/workflows.md](./specify/workflows.md).

---

## Plans hygiene

`~/.cursor/plans/` accumulates agent plans. Optional helper: `~/.cursor/bin/archive-stale-plans.sh`. Do not commit plans into product repos.

---

## Bootstrap a new machine

Prefer the checklist in **[day1-setup.md](./day1-setup.md)**. Short form:

1. Copy [templates/global/hooks.json](./templates/global/hooks.json) → `~/.cursor/hooks.json`
2. Copy [templates/global/hooks/*.sh](./templates/global/hooks/) → `~/.cursor/hooks/` and `chmod +x`
3. Copy [templates/global/rules/*.mdc](./templates/global/rules/) → `~/.cursor/rules/`
4. Clone [sdd-orchestrator](https://github.com/Wade-O-Lution-Inc/sdd-orchestrator) → `~/.cursor/sdd-orchestrator-ctl` and symlink the skill
5. Install Spec Kit 0.10.2; optional pointer stubs from meeting_notes
6. Run `bash ~/.cursor/hooks/workspace-skill-router.test.sh` if present
7. Smoke: `python3 ~/.cursor/sdd-orchestrator-ctl/bin/sdd-ctl plan-phase --help`

---

## What still belongs in the repo

Project `.cursor/` remains the home for:

- `project.mdc` / engineering rules / testing conventions
- Repo skills (Doppler, Supabase, Grafana, …)
- Security blocking hooks (secrets, `--no-verify`, sensitive reads)
- Spec Kit `.specify/`, `sdd` / `sdd-remote` workflows, `sdd-entry`, `.specify/orchestrator.json`

Do **not** put machine IPs, tokens, or Doppler secrets in this guide or in global skills.
