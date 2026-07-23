# Ownership — what lives where

Decide machine vs product vs gold vs ctl **before** copying files. Prevents duplicate skills and secrets in the wrong place.

**Day-1 install:** [day1.md](./day1.md) · **Product adapt:** [product-repo.md](./product-repo.md) · **CLI:** [`../bin/cursor-setup`](../bin/cursor-setup)

---

## Decision flowchart

```
Is this specific to one codebase?
├── Yes → Product scope (repo/.cursor/ + .specify/ when SDD)
├── No, spans multiple Wade-O-Lution repos
│   ├── Cross-repo safety / routing / SDD ctl? → Machine (~/.cursor/)
│   ├── Machine-specific ops (SSH, lab)? → Global skill (no secrets in file)
│   └── Shared product convention? → Owning repo + optional global stub
└── Personal preference only → Your machine only (never templates)
```

---

## Multi-repo map

| Repo | Owns | Spec Kit / SDD? |
|------|------|-----------------|
| **cursor-setup-guide** | Adoption docs + templates + install CLI | Documents only |
| **sdd-orchestrator** | Portable ctl (`sdd-ctl`, phase models) | Runtime SSOT |
| **meeting_notes_workflow** | Gold product harness, SDD user guide, Company MCP skill/deep guide | Yes — primary reference |
| **Integrity_Lab** | Mac mini platform skills/gates | **No** Spec Kit product features |
| **repo-index** | Swarm composition | Swarm protocol |
| Platform (`data-api`, `integrity-ts`, …) | Product APIs / UI harness | Adopt SDD when needed via [product-repo](./product-repo.md) |

Each repo has its own `.cursor/`. The **global skill router** (`~/.cursor/hooks/workspace-skill-router.sh`) detects the active repo.

---

## Machine scope (`~/.cursor/`)

**Not in product git.** Install: `./bin/cursor-setup install-global` · refresh after router PRs: `refresh-global`.

```
~/.cursor/
├── hooks.json + hooks/     # Skill router (beforeSubmitPrompt)
├── rules/                  # Always-on safety + shared on-demand rules
├── skills/                 # Pointer stubs + personal/machine skills
├── sdd-orchestrator-ctl/   # Clone of sdd-orchestrator
├── plans/                  # Cursor-managed — don't commit
├── skills-cursor/          # Built-in — never hand-edit
└── mcp.json                # Optional; keep minimal
```

### Always-on global rules (why)

| Rule | Why |
|------|-----|
| `git-safety.mdc` | No force-push / main push / unsolicited commits |
| `supply-chain-defense.mdc` | Gate npm/pip/MCP installs |
| `mixed-concern-guardrail.mdc` | Split work across 3+ boundaries |
| `platform-inheritance.mdc` | Industry→customer; no customer forks in shared code |
| `skill-routing-mandate.mdc` | Read hook-injected skill paths before acting |

### Shared on-demand global rules

`compact-handoff` · `design-pattern-guardrails` · `multi-repo-workspace` · `team-topologies-review-loop`

### Skills on the machine

| Kind | Examples | Policy |
|------|----------|--------|
| Symlink / ctl | `sdd-orchestrator` | `sdd-ctl sync` |
| Pointer stubs | `speckit-*`, overengineering, … | Short; canonical in gold product |
| Personal / machine | `lab-host-ssh`, `browser-automation` | Never overwritten by `install-global` |

Stub list: [`templates/sync-manifest.json`](../templates/sync-manifest.json) → `stub_skill_names`.  
`doctor` warns when a stub name looks like a full body.

**Live routing is per-machine:** Cursor runs `~/.cursor/hooks/…`, not the git copy. After router keyword PRs: `refresh-global`.

---

## Product scope (`repo/.cursor/` + `.specify/`)

**Committed. Shared with collaborators.**

Use for: project structure, stack conventions, security hooks, ops skills, app MCP, Spec Kit workflows, `sdd-entry`.

### Starter pack vs gold (important)

| | Guide `templates/product/` | MNW gold `.cursor/rules/` |
|--|---------------------------|---------------------------|
| Intent | Pedagogy starters for any repo | Mature KB platform harness |
| Examples | `think-before-coding.mdc`, `surgical-changes.mdc`, `security-protocol.mdc` | `00-orchestrator.mdc`, `engineering-discipline.mdc`, `security-and-git.mdc` |

Scaffold gives you a **starting point**. It is **not** a byte-copy of meeting_notes. Compare to gold when you want MNW’s patterns; adapt names and content to your stack.

**Multi-root:** rules from `repo-a` may be visible in `repo-b`. Keep rules repo-specific.

---

## Promotion rules

1. Cross-repo safety / routing / SDD ctl → **machine** (via `templates/global/` + CLI).
2. Collaborator procedures → **that repo’s** `.cursor/skills/`.
3. SDD phase workers → **product** (managed) + optional **machine stubs**.
4. Reusable pattern invented in MNW → sync into guide templates → teammates `refresh-global` / re-scaffold. Document starter≠gold when pedagogy diverges.
5. Personal prefs / host paths → **machine only**; never templates.

### What NOT to put in global

- API keys / tokens — Doppler / env  
- Full duplicates of large repo skills — stubs  
- Private fork of sdd-orchestrator — clone GitHub; `sdd-ctl sync`

---

## Spec-Driven Development placement

| Asset | Scope |
|-------|-------|
| `.specify/`, `specs/`, product SDD docs | **Project** |
| `sdd` / `sdd-remote` workflows | **Project** (`templates/spec-kit/`) |
| `sdd-entry` | **Project** |
| `speckit-*` workers | **Project** + optional **global stubs** |
| `sdd-orchestrator` + ctl | **Global** |

Deep docs: [specify/](./specify/) · gold: [meeting_notes_workflow](https://github.com/Wade-O-Lution-Inc/meeting_notes_workflow) · runtime: [sdd-orchestrator](https://github.com/Wade-O-Lution-Inc/sdd-orchestrator)
