# Implementation Plan: Team Marketplace Plugins for SDD

**Branch**: `001-team-marketplace-plugins` | **Date**: 2026-08-20 | **Spec**: [spec.md](./spec.md)

**Input**: Feature specification from `/specs/001-team-marketplace-plugins/spec.md`

**Workflow profile**: SDD Lite (`specify → plan → implement → light_gate`). Lite implement reads this plan’s **Implementation Worklist** — do **not** create or require `tasks.md` on the happy path.

**Note**: This template is filled in by the `/speckit-plan` command; its definition describes the execution workflow.

## Summary

Package `cursor-setup-guide` as the Integrity Cursor Team marketplace (`integrity-cursor`) with exactly three Cursor Plugins — `integrity-sdd` (SDD chat surface: Full / Lite / Review), `integrity-safety` (git + supply-chain rules + skill router), and `integrity-company-context` (company-mcp skill only) — while keeping the existing `./bin/cursor-setup install-global` dual-path and leaving Cursor dashboard activation as a human admin runbook. Orchestration remains `sdd-ctl`; SDD is not an MCP server.

## Technical Context

**Language/Version**: Python 3 (stdlib only in `bin/cursor-setup`); Bash for hooks; Markdown / JSON / `.mdc` for plugins, rules, skills, commands, docs

**Primary Dependencies**: None new. Existing: Cursor Team marketplace + Cursor Plugin layout (`.cursor-plugin/`), GitHub (`gh`), optional `jq` in hooks, Spec Kit 0.13.0 + `sdd-ctl` installed on the seat (via `/sdd-bootstrap` or `install-global`). **PL-03: no new npm or pip packages.**

**Storage**: Git files in this repo; seat machine state under `~/.cursor/` for CLI path only; Team MCP / dashboard config outside git

**Testing**: `python3 -c` / `json.load` for manifests; `bash templates/global/hooks/workspace-skill-router.test.sh`; `./bin/cursor-setup doctor` (optional marketplace WARN); static grep for secrets in `plugins/`; human Standard-seat smoke after dashboard import

**Target Platform**: Cursor Desktop / Cloud Agents on Integrity Cursor Team named seats (macOS/Linux operator machines)

**Project Type**: Adoption hub — docs + templates + install CLI + multi-plugin marketplace packaging (not an application service)

**Performance Goals**: N/A (distribution / packaging); doctor and hook scripts remain fast fail-open injectors

**Constraints**:
- Official Cursor Plugin layout: `plugins/<name>/.cursor-plugin/plugin.json`; hooks at `plugins/<name>/hooks/hooks.json` (not plugin-root `hooks.json`)
- Engine stays external `sdd-ctl` (`~/.cursor/sdd-orchestrator-ctl`); do not vendor orchestrator `lib/` or wrap as MCP
- Company MCP auth/URL stays Team MCP dashboard — **no** `mcp.json` with URLs/tokens in this repo
- Dual-path: marketplace plugins + `templates/global/**` + `bin/cursor-setup` coexist
- Safety plugin hooks must invoke `./hooks/workspace-skill-router.sh` (sibling), not the HOME wrapper path that breaks plugin-only seats
- Do not mark plugins Required from git; dashboard install modes are human leftover
- Git delivery: commit/push/PR on `feat/team-marketplace-plugins`; do not merge

**Scale/Scope**: One marketplace (`integrity-cursor`), three plugins, dual-path template sync, admin runbook + doc patches, optional doctor WARN

## Complexity ceiling (what we will NOT build)

- No second marketplace repository
- No MCP wrapping of `sdd-ctl` / SDD orchestration
- No secrets, URLs, or tokens in `mcp.json` (company-context ships skill + README only)
- No vendoring of `sdd-orchestrator` `lib/`, `phase-models.json`, or full ctl tree
- Dashboard clicks (import marketplace, Auto Refresh, Required/Default On modes, Team MCP add) are **human leftover** — documented in runbook, not automated by this feature
- Do **not** mark plugins Required from git
- No new SDD modes beyond Full / Lite / Review
- No new npm/pip dependencies
- Do not copy orchestrator `route-sdd-verbs-before-prompt.sh`
- Do not remove or deprecate `install-global` / `templates/global/**`

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

Repo constitution file is still the Spec Kit placeholder stub; operative gates for this repo (from specify-rules / adoption practice):

| Gate | Status |
|------|--------|
| No unjustified new project / dependency surface | **PASS** — packaging only; PL-03 no new npm/pip |
| Dual-path preserved (CLI not removed) | **PASS** — worklist keeps `bin/cursor-setup` + `templates/global/**` |
| Engine boundary (`sdd-ctl` external; not MCP) | **PASS** — FR-008/FR-009 + complexity ceiling |
| Quality smoke available without new tooling | **PASS** — JSON load, router test, doctor, secret grep |
| Lite worklist instead of `tasks.md` | **PASS** — PL-08 |

Post-design re-check: same — no violations requiring Complexity Tracking rows.

## Project Structure

### Documentation (this feature)

```text
specs/001-team-marketplace-plugins/
├── plan.md                 # This file (/speckit-plan)
├── spec.md                 # Feature specification
├── confidence-checks.md    # Drafted at plan; re-compiled at confidence/light_gate
├── phase-exits.md          # Gate log
└── checklists/requirements.md
```

**Lite note:** Do **not** create `tasks.md` on the happy path. Implement executes **## Implementation Worklist** below. Template mentions of `tasks.md` / Phase 2 tasks are Full-profile only.

### Source Code (repository root)

```text
.cursor-plugin/
└── marketplace.json                    # name: integrity-cursor; three plugin entries

plugins/
├── integrity-sdd/
│   ├── .cursor-plugin/plugin.json
│   ├── skills/sdd-entry/SKILL.md       # copy from sdd-orchestrator main (Lite+Review)
│   ├── skills/sdd-bootstrap/SKILL.md   # NEW — ctl + Spec Kit 0.13.0 once
│   ├── rules/sdd-front-door.mdc
│   ├── rules/skill-routing-mandate.mdc
│   ├── hooks/hooks.json                # official path (not plugin-root)
│   ├── hooks/sdd-specify-preflight.sh  # sync from ~/.cursor/hooks + templates/global
│   └── commands/
│       ├── start-sdd.md
│       ├── start-sdd-lite.md
│       ├── start-sdd-review.md
│       ├── continue-sdd.md
│       └── sdd-bootstrap.md
├── integrity-safety/
│   ├── .cursor-plugin/plugin.json
│   ├── rules/git-safety.mdc
│   ├── rules/supply-chain-defense.mdc
│   ├── hooks/hooks.json                # must invoke ./hooks/workspace-skill-router.sh
│   ├── hooks/workspace-skill-router.sh
│   ├── hooks/route-skills-before-prompt.sh
│   └── hooks/workspace-skill-router.test.sh
└── integrity-company-context/
    ├── .cursor-plugin/plugin.json
    ├── skills/company-mcp/             # copy of templates/skills/company-mcp/
    └── README.md                       # Team MCP via Dashboard — no mcp.json

bin/cursor-setup                        # keep; optional doctor WARN for marketplace

templates/
├── SYNC.md                             # note: sdd-entry gold = sdd-orchestrator until MNW catches up
├── sync-manifest.json                  # sdd-entry gold-row note only
├── skills/sdd-entry/SKILL.md           # overwrite with orchestrator copy
├── skills/company-mcp/                 # source for company-context plugin
└── global/
    ├── hooks.json                      # router + sdd-specify-preflight (CLI path)
    ├── hooks/sdd-specify-preflight.sh
    ├── hooks/workspace-skill-router.sh
    ├── hooks/route-skills-before-prompt.sh
    ├── hooks/workspace-skill-router.test.sh
    └── rules/
        ├── git-safety.mdc
        ├── supply-chain-defense.mdc
        └── skill-routing-mandate.mdc

docs/
├── team-marketplace.md                 # NEW admin runbook + packaging SSOT
├── day1.md                             # patch: marketplace + bootstrap + CLI fallback
├── ownership.md                        # patch: marketplace layer
├── hooks.md                            # patch: dual-path hooks / no double-inject
└── company-mcp.md                      # existing thin pointer (referenced, not rewritten)

README.md                               # patch: Start-here → team marketplace
```

**Structure Decision**: Multi-plugin marketplace living in this adoption repo (Cursor official layout). Dual-path keeps machine CLI templates under `templates/global/` and `bin/cursor-setup`. No application `src/` tree; no separate marketplace repo.

## FR → file / module mapping (PL-01)

| FR | Concrete files / modules |
|----|---------------------------|
| **FR-001** Package as Integrity Team marketplace | `.cursor-plugin/marketplace.json` (`name`: `integrity-cursor`); `docs/team-marketplace.md` |
| **FR-002** Exactly three plugins | marketplace `plugins[]` → `plugins/integrity-sdd/`, `plugins/integrity-safety/`, `plugins/integrity-company-context/` (+ each `.cursor-plugin/plugin.json`) |
| **FR-003** Full / Lite / Review via SDD chat surface | `plugins/integrity-sdd/skills/sdd-entry/SKILL.md`; `plugins/integrity-sdd/rules/sdd-front-door.mdc`; `plugins/integrity-sdd/commands/start-sdd.md`, `start-sdd-lite.md`, `start-sdd-review.md`, `continue-sdd.md` |
| **FR-004** Safety protections | `plugins/integrity-safety/rules/git-safety.mdc`; `plugins/integrity-safety/rules/supply-chain-defense.mdc`; `plugins/integrity-safety/hooks/hooks.json` + `workspace-skill-router.sh` (routing mandate companion under SDD plugin) |
| **FR-005** Company context skill | `plugins/integrity-company-context/skills/company-mcp/`; `plugins/integrity-company-context/README.md`; `docs/company-mcp.md` (existing pointer) |
| **FR-006** Dual-path marketplace + install-global | `bin/cursor-setup`; `templates/global/**`; `plugins/**`; `docs/day1.md`; `docs/team-marketplace.md`; `README.md` |
| **FR-007** Admin runbook for dashboard leftovers | `docs/team-marketplace.md` (ordered human steps + done checks) |
| **FR-008** Orchestration stays on sdd-ctl | `plugins/integrity-sdd/skills/sdd-entry/SKILL.md`; `plugins/integrity-sdd/skills/sdd-bootstrap/SKILL.md`; `plugins/integrity-sdd/hooks/sdd-specify-preflight.sh` — all call/install ctl, never replace it |
| **FR-009** SDD is not an MCP server | `docs/team-marketplace.md`; `README.md`; company plugin ships **no** SDD MCP; complexity ceiling |
| **FR-010** Modes are Full / Lite / Review only | `plugins/integrity-sdd/skills/sdd-entry/SKILL.md`; SDD commands; `docs/team-marketplace.md` |
| **FR-011** Complementary paths, not exclusive | `docs/team-marketplace.md`; `docs/day1.md`; `docs/ownership.md`; `README.md` |

## Design notes (Lite Phase 0/1 folded here)

### Marketplace & plugin manifests

- Root `.cursor-plugin/marketplace.json`: marketplace `name` `integrity-cursor`; exactly three entries with `source` paths `plugins/integrity-sdd`, `plugins/integrity-safety`, `plugins/integrity-company-context`.
- Each plugin: `plugins/<name>/.cursor-plugin/plugin.json` with `name`, `displayName` (harmless extra), `version`, `description`, `author.name: "Integrity Systems"`.
- Hooks config path: **`hooks/hooks.json`** per official Cursor Plugin discovery.

### integrity-sdd

- Copy `sdd-entry` from **sdd-orchestrator** `main` (must include **Start SDD Lite** and **Start SDD Review**); also overwrite `templates/skills/sdd-entry/SKILL.md`.
- NEW `sdd-bootstrap` skill + `/sdd-bootstrap` command: one-shot ctl clone/sync + Spec Kit 0.13.0 guidance for marketplace seats.
- Rules: `sdd-front-door.mdc` (route Start/Continue/Lite/Review verbs into sdd-entry → orchestrator); copy `skill-routing-mandate.mdc` from `templates/global/rules/`.
- Preflight: copy/sync `sdd-specify-preflight.sh` from live `~/.cursor/hooks/sdd-specify-preflight.sh` **and** keep `templates/global/hooks/sdd-specify-preflight.sh` aligned; wire in plugin `hooks/hooks.json`.

### integrity-safety

- Copy `git-safety.mdc` + `supply-chain-defense.mdc` from `templates/global/rules/`.
- Ship router + wrapper + test from `templates/global/hooks/`.
- **Critical:** plugin `hooks/hooks.json` command MUST be `./hooks/workspace-skill-router.sh` (NOT `route-skills-before-prompt.sh` → HOME exec). Keep the wrapper file for CLI dual-path parity where cwd is `~/.cursor/`.

### integrity-company-context

- Copy entire `templates/skills/company-mcp/` tree.
- README: IntegrityKB via Team MCP dashboard; **forbid** committing `mcp.json` with URLs/tokens.

### Dual-path / SYNC

- Keep `bin/cursor-setup` and `templates/global/**`.
- Note in `templates/SYNC.md` (and `sync-manifest.json` sdd-entry row): **sdd-entry gold is sdd-orchestrator until MNW catches up** with Lite/Review.
- Optional `doctor` WARN if marketplace.json missing or plugin names mismatch sources — WARN only, not FAIL.

### Docs & git

- New `docs/team-marketplace.md` = packaging SSOT + admin runbook (import repo, marketplace access, Auto Refresh off until smoke, then install modes, Team rule, IntegrityKB Team MCP).
- Patch `README.md`, `docs/day1.md`, `docs/ownership.md`, `docs/hooks.md`.
- After implement: commit/push/PR on `feat/team-marketplace-plugins`; do not merge.

## Implementation Worklist

Dependency-ordered. Lite implement executes these items in order; each cites Project Structure paths.

1. **W01 — Branch + marketplace manifest** — ✅ Done. Confirm work is on `feat/team-marketplace-plugins` (from `origin/main`); never commit to `main`. Create `.cursor-plugin/marketplace.json` with `name: integrity-cursor` and exactly three plugin sources: `plugins/integrity-sdd`, `plugins/integrity-safety`, `plugins/integrity-company-context`.

2. **W02 — integrity-sdd plugin skeleton + chat surface** — ✅ Done. Create `plugins/integrity-sdd/.cursor-plugin/plugin.json`; copy orchestrator-main `sdd-entry` → `plugins/integrity-sdd/skills/sdd-entry/SKILL.md` and `templates/skills/sdd-entry/SKILL.md`; add `plugins/integrity-sdd/rules/sdd-front-door.mdc`; copy `templates/global/rules/skill-routing-mandate.mdc` → `plugins/integrity-sdd/rules/skill-routing-mandate.mdc`; add commands `plugins/integrity-sdd/commands/{start-sdd,start-sdd-lite,start-sdd-review,continue-sdd,sdd-bootstrap}.md`; add NEW `plugins/integrity-sdd/skills/sdd-bootstrap/SKILL.md`.

3. **W03 — integrity-sdd hooks** — ✅ Done. Add `plugins/integrity-sdd/hooks/sdd-specify-preflight.sh` (sync from `~/.cursor/hooks/sdd-specify-preflight.sh` and align `templates/global/hooks/sdd-specify-preflight.sh`); wire `plugins/integrity-sdd/hooks/hooks.json`; ensure `templates/global/hooks.json` still wires preflight for CLI path.

4. **W04 — integrity-safety plugin** — ✅ Done. Create `plugins/integrity-safety/.cursor-plugin/plugin.json`; copy `templates/global/rules/git-safety.mdc` and `supply-chain-defense.mdc` → `plugins/integrity-safety/rules/`; copy `templates/global/hooks/{workspace-skill-router.sh,route-skills-before-prompt.sh,workspace-skill-router.test.sh}` → `plugins/integrity-safety/hooks/`; write `plugins/integrity-safety/hooks/hooks.json` invoking **`./hooks/workspace-skill-router.sh`**.

5. **W05 — integrity-company-context plugin** — ✅ Done. Create `plugins/integrity-company-context/.cursor-plugin/plugin.json`; copy `templates/skills/company-mcp/` → `plugins/integrity-company-context/skills/company-mcp/`; write `plugins/integrity-company-context/README.md` (Team MCP only; no `mcp.json` secrets).

6. **W06 — Dual-path SYNC + optional doctor** — ✅ Done. Update `templates/SYNC.md` and `templates/sync-manifest.json` (sdd-entry gold = sdd-orchestrator until MNW); keep `bin/cursor-setup` + `templates/global/**`; optional WARN in `bin/cursor-setup` `cmd_doctor` when marketplace.json missing or plugin name/source mismatch.

7. **W07 — Docs / runbook** — ✅ Done. Write `docs/team-marketplace.md` (admin runbook + packaging SSOT); patch `README.md`, `docs/day1.md`, `docs/ownership.md`, `docs/hooks.md`.

8. **W08 — Local smoke** — ✅ Done. JSON-load `.cursor-plugin/marketplace.json` + each `plugins/*/.cursor-plugin/plugin.json`; verify sources exist; assert `plugins/integrity-sdd/skills/sdd-entry/SKILL.md` contains Lite + Review strings; grep `plugins/` for secrets; `bash templates/global/hooks/workspace-skill-router.test.sh`; `./bin/cursor-setup doctor`.

9. **W09 — Git / PR (no merge)** — ✅ Done (commit/push/PR). Commit on `feat/team-marketplace-plugins`, push, open PR vs `main` (branch safety: do not merge, force-push, or push to `main`). Dashboard leftover steps remain human per `docs/team-marketplace.md`.

## Complexity Tracking

> No constitution violations requiring justification.

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| — | — | — |
