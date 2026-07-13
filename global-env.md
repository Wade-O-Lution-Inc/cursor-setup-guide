# Global Cursor Environment (Wade-O-Lution)

Canonical description of the **machine-local** Cursor harness under `~/.cursor/`, as of 2026-07. Project repos still own most rules/skills in git; this layer adds cross-repo routing, always-on safety rules, Spec Kit stubs, and the SDD multi-model control plane.

**Pair with:** [specify/](./specify/) (workflows + customizations) · [scope.md](./scope.md) · [hooks.md](./hooks.md) · live reference [meeting_notes_workflow](https://github.com/Wade-O-Lution-Inc/meeting_notes_workflow)

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
├── sdd-orchestrator-ctl/      # YOU — SDD phase policy, sdd-run, JSONL runs
├── bin/                       # YOU — helper CLIs (e.g. archive-stale-plans.sh)
├── plans/                     # Cursor — agent plans (archive via bin helper)
├── skills-cursor/             # Cursor — built-in skills; never hand-edit
├── plugins/                   # Cursor — plugin cache
├── mcp.json                   # YOU — optional user-level MCP (keep minimal)
└── cli-config.json            # Cursor CLI config
```

Templates for the YOU-owned pieces live under [templates/global/](./templates/global/).

---

## Skill routing (mandatory)

Every prompt runs a global `beforeSubmitPrompt` hook that injects an **agent_message** starting with `MANDATORY SKILL ROUTING` listing skill/rule paths to read before acting.

| File | Role |
|------|------|
| `~/.cursor/hooks.json` | Registers `hooks/route-skills-before-prompt.sh` |
| `route-skills-before-prompt.sh` | `exec` into the router |
| `workspace-skill-router.sh` | Detects repo (`meeting_notes_workflow`, `Integrity_Lab`, `repo-index`, platform repos…) and prompt keywords; suggests repo + global skills |

**Rule:** [skill-routing-mandate.mdc](./templates/global/rules/skill-routing-mandate.mdc) (`alwaysApply: true`) — agents must read every listed path before implementing.

Repo-local `beforeSubmitPrompt` hooks (e.g. meeting_notes) may add repo-only suggestions; the global router is the cross-repo source of truth.

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
| **Owned globally** | `lab-host-ssh`, `browser-automation`, `session-handoff`, `sdd-orchestrator` | Cross-repo ops / harness; no secrets in files (IPs via Tailscale names / Doppler) |
| **Pointer stubs** | `speckit-*`, `notion-integration`, `skill-supply-chain-review`, `overengineering-*` | Thin SKILL.md that points at the canonical copy in `meeting_notes_workflow` (or other owning repo) |
| **Built-in** | `~/.cursor/skills-cursor/*` | Cursor product skills — leave alone |

Stubs keep discovery working when the router suggests a name that is owned in a repo. Prefer stubs over duplicating large skill bodies.

---

## SDD control plane (global)

Full policy docs: **[specify/orchestrator.md](./specify/orchestrator.md)**.

| Asset | Role |
|-------|------|
| `~/.cursor/skills/sdd-orchestrator/SKILL.md` | Interactive Task-path: worker → D-hooks → judge → `phase-exits.md` + JSONL |
| `~/.cursor/sdd-orchestrator-ctl/` | Shared policy (`phase-models.json`), checklists, prompts, `bin/sdd-run` |
| Project `sdd-entry` | Chat front door — resolves FEATURE_DIR + PHASE, then **must** call the orchestrator |

CLI in repos: `specify workflow run sdd` / `sdd-remote` — [specify/workflows.md](./specify/workflows.md).

---

## Plans hygiene

`~/.cursor/plans/` accumulates agent plans. Optional helper: `~/.cursor/bin/archive-stale-plans.sh` moves stale plans into `~/.cursor/plans/archive/`. Do not commit plans into product repos.

---

## Bootstrap a new machine

1. Copy [templates/global/hooks.json](./templates/global/hooks.json) → `~/.cursor/hooks.json`
2. Copy [templates/global/hooks/*.sh](./templates/global/hooks/) → `~/.cursor/hooks/` and `chmod +x`
3. Copy [templates/global/rules/*.mdc](./templates/global/rules/) → `~/.cursor/rules/`
4. Install global skills you need (clone stubs from meeting_notes or copy from a known-good machine)
5. Clone/copy `sdd-orchestrator` skill + `sdd-orchestrator-ctl` from a known-good machine (or rebuild from the multi-model router plan)
6. Run `bash ~/.cursor/hooks/workspace-skill-router.test.sh` if present
7. Open a Wade-O-Lution multi-root workspace and confirm a prompt with `SDD` injects `sdd-entry` + `sdd-orchestrator`

---

## What still belongs in the repo

Project `.cursor/` remains the home for:

- `project.mdc` / engineering rules / testing conventions
- Repo skills (Doppler, Supabase, Grafana, …)
- Security blocking hooks (secrets, `--no-verify`, sensitive reads)
- Spec Kit `.specify/`, `sdd` / `sdd-remote` workflows, `sdd-entry`

Do **not** put machine IPs, tokens, or Doppler secrets in this guide or in global skills.
