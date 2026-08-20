# Confidence Checks: Team Marketplace Plugins for SDD

**Feature**: [spec.md](./spec.md) | **Drafted**: 2026-08-20 (at `/speckit-plan`) | **Re-compiled**: pending — filled at `/speckit-confidence` or Lite `light_gate`

<!--
  Authority
  Drafted by /speckit-plan from this feature's own FRs/SCs/blast-radius.
  Re-compiled by /speckit-confidence at the start of each iteration from the
  final worklist/diff (Lite: plan Implementation Worklist — no tasks.md).
  These checks are ADDITIVE evidence for the three static confidence axes —
  they do not replace them.
-->

## Intent summary

Give every Integrity Cursor Team named seat SDD Full, Lite, and Review through a three-plugin Team marketplace packaged in this repo, while keeping `install-global` as a peer path, leaving dashboard leftovers to a human runbook, and keeping orchestration on `sdd-ctl` (not MCP).

## Complexity ceiling (what we will NOT build)

- No second marketplace repo
- No MCP wrapping of `sdd-ctl`
- No secrets / URLs / tokens in `mcp.json`
- No vendoring `sdd-orchestrator` `lib/` (or full ctl tree)
- Dashboard clicks are human leftover (not automated)
- Do not mark plugins Required from git
- No new npm/pip dependencies
- No new SDD modes beyond Full / Lite / Review
- Do not deprecate `bin/cursor-setup` / `templates/global/**`

## Checks

| ID | Axis | Check | Evidence | Authority | Status |
|----|------|-------|----------|-----------|--------|
| CC-001 | Accuracy | **FR-001**: `.cursor-plugin/marketplace.json` exists with marketplace `name` `integrity-cursor` | `python3 -c` JSON load; inspect `name` | in_authority | pending |
| CC-002 | Accuracy | **FR-002** / **SC-005**: marketplace lists exactly three plugins (`integrity-sdd`, `integrity-safety`, `integrity-company-context`) and matching `plugins/<source>/` dirs exist | Parse `plugins[]`; `test -d` each source | in_authority | pending |
| CC-003 | Accuracy | **FR-003** / **SC-001** (packaging half): SDD chat surface exposes Full, Lite, Review — `plugins/integrity-sdd/skills/sdd-entry/SKILL.md` contains Start SDD / Start SDD Lite / Start SDD Review; matching commands exist under `plugins/integrity-sdd/commands/` | `rg` strings; list command files | in_authority | pending |
| CC-004 | Accuracy | **FR-004** / **SC-006** (rule surface): safety plugin ships `git-safety.mdc` (no force-push / no unsolicited commits) and `supply-chain-defense.mdc` (gated dependency + MCP installs) | File presence + content grep for the four protections | in_authority | pending |
| CC-005 | Accuracy | **FR-004**: `plugins/integrity-safety/hooks/hooks.json` invokes `./hooks/workspace-skill-router.sh` (not HOME wrapper) | JSON/text inspect of hooks.json | in_authority | pending |
| CC-006 | Accuracy | **FR-005**: company-context plugin includes `skills/company-mcp/` and README; no plugin `mcp.json` with URLs/tokens | Tree listing; secret/URL grep under `plugins/integrity-company-context/` | in_authority | pending |
| CC-007 | Accuracy | **FR-006** / **FR-011** / **SC-003** (docs half): dual-path described — marketplace and `install-global` both present in `docs/team-marketplace.md`, `docs/day1.md`, and `README.md` | Doc grep for marketplace + install-global | in_authority | pending |
| CC-008 | Accuracy | **FR-006**: CLI dual-path artifacts retained — `bin/cursor-setup`, `templates/global/hooks.json`, `templates/global/hooks/sdd-specify-preflight.sh`, router scripts | Path existence checks | in_authority | pending |
| CC-009 | Accuracy | **FR-007** / **SC-002**: `docs/team-marketplace.md` lists ordered leftover dashboard steps with done conditions and marks them manual | Section headings / checklist review | in_authority | pending |
| CC-010 | Accuracy | **FR-008** / **FR-009** / **SC-004**: guidance states SDD orchestration is `sdd-ctl` and SDD is not an MCP server; zero contradictory “SDD as MCP” claims in feature docs/plugins | Grep `docs/team-marketplace.md`, `README.md`, `plugins/integrity-sdd/` for sdd-ctl / MCP claims | in_authority | pending |
| CC-011 | Accuracy | **FR-010**: only Full / Lite / Review named as supported SDD modes in packaging docs and sdd-entry surface | Grep for invented mode names; confirm three verbs | in_authority | pending |
| CC-012 | Accuracy | **FR-003** companion: `sdd-front-door` rule + `sdd-bootstrap` skill/command present under `plugins/integrity-sdd/` | Path existence | in_authority | pending |
| CC-013 | Accuracy | Official hooks path: each plugin that ships hooks uses `hooks/hooks.json` (not plugin-root `hooks.json`) | Path checks under `plugins/integrity-sdd/` and `plugins/integrity-safety/` | in_authority | pending |
| CC-014 | Performance | Hook/router smoke still fast: `bash templates/global/hooks/workspace-skill-router.test.sh` exits 0 | Test script run | in_authority | pending |
| CC-015 | Performance | `./bin/cursor-setup doctor` completes without new FAIL from marketplace WARN (WARN OK if present) | Doctor exit + output | in_authority | pending |
| CC-016 | Complexity | Ceiling held: no second marketplace repo; no vendored orchestrator `lib/`; no `mcp.json` secrets; no new npm/pip deps in diff | Diff / tree inspection | in_authority | pending |
| CC-017 | Complexity | PL-08 Lite: no `tasks.md` required; implement tracked via plan **Implementation Worklist** | `specs/001-team-marketplace-plugins/` listing | in_authority | pending |
| CC-018 | Accuracy | **SC-001** / **SC-003** seat enablement (marketplace and CLI-only) | Named-seat smoke after dashboard import; separate CLI-only Start SDD mode entry | escalate | pending |
| CC-019 | Accuracy | **SC-006** live enforcement: force-push / unsolicited commit / ungated dep install / ungated MCP install blocked when safety plugin enabled | Operator agent attempt under safety plugin | escalate | pending |
| CC-020 | Accuracy | **SC-002**: admin completes leftover dashboard steps using only `docs/team-marketplace.md` | Human admin activation pass | escalate | pending |

## Anti-overbuild watch-list (checked at re-compile, not scored yet)

- Second marketplace repo or Agent Plugin root `plugin.json` instead of `.cursor-plugin/`
- `mcp.json` (or tokens/URLs) under `plugins/integrity-company-context/`
- Vendored `sdd-orchestrator` `lib/` / `phase-models.json`
- Plugin hooks still pointing at `~/.cursor/hooks/workspace-skill-router.sh` via wrapper
- Plugin-root `hooks.json` instead of `hooks/hooks.json`
- New npm/pip dependency added “for validation”
- `tasks.md` introduced on Lite happy path
- Dashboard Required/Auto Refresh automated or claimed done from git
- Deprecation language for `install-global`
- Copy of orchestrator `route-sdd-verbs-before-prompt.sh`
