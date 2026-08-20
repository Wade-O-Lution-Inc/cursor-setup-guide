# Light Gate — 001-team-marketplace-plugins

Lite terminal audit. Workflow: `specify → plan → implement → light_gate`.

**Sources**: [spec.md](./spec.md), [plan.md](./plan.md) (Implementation Worklist + complexity ceiling + Project Structure), [phase-exits.md](./phase-exits.md), [docs/team-marketplace.md](../../docs/team-marketplace.md), PR [#16](https://github.com/Wade-O-Lution-Inc/cursor-setup-guide/pull/16) (`feat/team-marketplace-plugins` → `main`, **OPEN**, not merged).

Did **not** re-run swarm. Deterministic-hook findings below are cited from prior-phase / diff-scale advisories, not re-executed here.

---

## Worklist completion

All nine Implementation Worklist items in `plan.md` are marked **✅ Done**. Evidence mapped per item:

| ID | Item | Evidence |
|----|------|----------|
| **W01** | Branch + marketplace manifest | Branch `feat/team-marketplace-plugins`. `.cursor-plugin/marketplace.json`: `name` `integrity-cursor`, `metadata.pluginRoot` `plugins`, exactly three sources `integrity-sdd` / `integrity-safety` / `integrity-company-context`. PR #16 open vs `main`. |
| **W02** | integrity-sdd skeleton + chat surface | `plugins/integrity-sdd/.cursor-plugin/plugin.json`; `skills/sdd-entry/SKILL.md` (Start SDD / Lite / Review); `skills/sdd-bootstrap/SKILL.md`; `rules/sdd-front-door.mdc` + `skill-routing-mandate.mdc`; commands `start-sdd.md`, `start-sdd-lite.md`, `start-sdd-review.md`, `continue-sdd.md`, `sdd-bootstrap.md`; gold also synced to `templates/skills/sdd-entry/SKILL.md`. |
| **W03** | integrity-sdd hooks | `plugins/integrity-sdd/hooks/hooks.json` → `./hooks/sdd-specify-preflight.sh`; script present; CLI dual-path still wired via `templates/global/hooks.json` + `templates/global/hooks/sdd-specify-preflight.sh`. |
| **W04** | integrity-safety plugin | `plugins/integrity-safety/.cursor-plugin/plugin.json`; `rules/git-safety.mdc` + `supply-chain-defense.mdc`; hooks tree including `workspace-skill-router.sh` (+ wrapper + test); `hooks/hooks.json` invokes **`./hooks/workspace-skill-router.sh`** (not HOME wrapper). |
| **W05** | integrity-company-context plugin | `plugins/integrity-company-context/.cursor-plugin/plugin.json`; `skills/company-mcp/` tree; `README.md` forbids committing `mcp.json` secrets; **no** `mcp.json` under `plugins/`. |
| **W06** | Dual-path SYNC + optional doctor | `templates/SYNC.md` + `templates/sync-manifest.json` note sdd-entry gold = sdd-orchestrator until MNW; `bin/cursor-setup` + `templates/global/**` retained; doctor marketplace WARN path present; `./bin/cursor-setup doctor` exit 0 on this machine; `python3 -m py_compile bin/cursor-setup` OK. |
| **W07** | Docs / runbook | `docs/team-marketplace.md` (packaging SSOT + ordered Dashboard leftovers); patches in `README.md`, `docs/day1.md`, `docs/ownership.md`, `docs/hooks.md`. |
| **W08** | Local smoke | JSON-load marketplace + three `plugin.json` (via `pluginRoot`); `sdd-entry` contains Lite + Review strings; no `mcp.json` under `plugins/`; `bash templates/global/hooks/workspace-skill-router.test.sh` passed; doctor exit 0. Also reflected in PR #16 Test evidence. |
| **W09** | Git / PR (no merge) | Commits on feature branch pushed; PR [#16](https://github.com/Wade-O-Lution-Inc/cursor-setup-guide/pull/16) **OPEN** (`mergedAt: null`). Agent did not merge. Dashboard leftovers remain human per runbook. |

No `tasks.md` (Lite happy path). Phase exits: specify / plan / implement each repaired once then continued (`phase-exits.md`).

---

## Spec alignment

### User Story 1 (P1) — Named seat runs SDD modes from team marketplace

| # | Acceptance scenario | Evidence |
|---|---------------------|----------|
| 1 | Named seat with SDD chat surface → **SDD Full** | `plugins/integrity-sdd/skills/sdd-entry/SKILL.md` + `commands/start-sdd.md` + `rules/sdd-front-door.mdc` enter Full (`workflow_profile=full`). Packaging ready; live seat enablement waits on Dashboard import (human leftover). |
| 2 | Same seat → **SDD Lite** | Same surface: Lite strings in `sdd-entry`; `commands/start-sdd-lite.md`. |
| 3 | Same seat → **SDD Review** | Same surface: Review strings in `sdd-entry`; `commands/start-sdd-review.md`; Review constrained to inspect→verdict (no implement). |
| 4 | Non–named-seat does not get Integrity team marketplace access as if named | Delivery is Team marketplace packaging (`integrity-cursor`) + admin runbook marketplace-access step; access control remains Cursor Team / Dashboard (not automated by this feature). Out of scope: administering seat membership. |

**Packaging half of SC-001 / FR-003**: three-mode chat surface is in-repo. **Seat enablement half** (SC-001 / CC-018): escalate — requires human Dashboard import + Standard-seat smoke (see Next steps).

### Supporting stories (recorded for completeness; not LG-02 P1)

- **P2 safety + company-context (FR-002/004/005)**: exactly three plugins in marketplace; safety rules encode force-push / unsolicited-commit / gated dep + MCP install protections; company-mcp skill shipped without `mcp.json` secrets.
- **P2 dual-path (FR-006/011)**: runbook + day1/ownership/README describe marketplace and `install-global` as complementary; CLI templates + `bin/cursor-setup` retained.
- **P3 admin runbook (FR-007)**: `docs/team-marketplace.md` lists ordered Dashboard steps with manual callouts and smoke checklist.
- **FR-008/009**: docs and company README state SDD is not an MCP server; orchestration remains external `sdd-ctl`.

---

## Complexity ceiling (what was NOT built)

Matches `plan.md` Complexity ceiling — intentionally absent from this Lite exit:

- No second marketplace repository
- No MCP wrap of `sdd-ctl` / SDD orchestration
- No `mcp.json` secrets, URLs, or tokens in-repo
- No vendoring of orchestrator `lib/` / `phase-models.json` / full ctl tree
- Plugins **not** marked Required (or Default On) from git
- No Dashboard clicks from the agent (import, Auto Refresh, install modes, Team MCP)
- No new SDD modes beyond Full / Lite / Review
- No new npm/pip dependencies
- `install-global` / `templates/global/**` not removed or deprecated
- No copy of orchestrator `route-sdd-verbs-before-prompt.sh`

Adopt-sdd paths (`.specify/**`, repo `.cursor/skills/speckit-*`, etc.) are harness prerequisite per plan Project Structure — not a fourth marketplace plugin.

---

## Residual risks

- **D-hook `blast_radius_high` (advisory)**: PR #16 touches a wide tree (marketplace `plugins/**`, docs, dual-path templates, plus Lite adopt-sdd `.specify/**` / Spec Kit skills). Treat as expected packaging + dogfood-harness blast radius — advisory, not an unresolved product defect. Do not expand scope further in this Lite loop.
- **`merge_lane` irreversible**: Human merge of #16 is an irreversible distribution change for the Team marketplace source. Agent must not merge; leave merge to a human after review and post-merge Dashboard activation plan.
- **Dashboard leftover is human**: Import marketplace, marketplace access, Auto Refresh, Required / Default On, Team Rule paste, IntegrityKB Team MCP — documented in `docs/team-marketplace.md` only; agent cannot complete seat-wide activation.
- **`railway.app` in company-mcp skill is docs, not a secret**: `plugins/integrity-company-context/skills/company-mcp/SKILL.md` mentions a public `…railway.app/mcp-company` URL pattern as operator guidance for Team/Cloud Agents. That is documentation / setup prose, not a committed credential or `mcp.json` secret. Auth remains Dashboard Team MCP.
- **Escalate / live verification still open**: Standard-seat smoke (CC-018), live FR-004 enforcement under the safety plugin (CC-019), and admin Dashboard activation pass (CC-020) are human/operator evidence after import — not claimed done by this gate.
- **Dual-path double-inject**: After plugins become Required, seats must not also inject the same `beforeSubmitPrompt` router from `~/.cursor/hooks.json` (documented in runbook / `docs/hooks.md`).

---

## Next steps

Humans only — **do not merge from this run**; keep **Auto Refresh off** until smoke passes:

1. **Dashboard import** — Import this repo as the Integrity Team marketplace source; set marketplace access for named seats (`docs/team-marketplace.md` steps 1–2).
2. **Standard-seat smoke** — Enable the three plugins; confirm Start SDD Lite (and routing / preflight injects) per runbook smoke checklist.
3. **Then Required / Default On** — After smoke: `integrity-sdd` + `integrity-safety` → **Required**; `integrity-company-context` → **Default On**; paste Team Rule; connect IntegrityKB via Team MCP.
4. Human merges PR #16 when ready (not this light_gate worker).
