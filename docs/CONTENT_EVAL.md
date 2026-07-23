# Content evaluation — cursor-setup-guide

**Status:** Phase B **implemented** (2026-07-22) after human “run it all” approval.  
**Date:** 2026-07-22  
**Corpus:** guide branch `docs/cursor-setup-guide-revamp` + live `~/.cursor` + MNW `.cursor` / `.specify` / key docs.  
**Prior pass:** [`AUDIT.md`](./AUDIT.md) archived. This eval drove the rewrite.

### Phase B changelog (implemented)

- Rewrote README, day1 (Spec Kit optional), ownership (merged machine harness), product-repo (starter≠gold), rules/skills/hooks/mcp/agents/company-mcp
- Cut examples content → redirects; archived AUDIT
- global-harness.md → redirect into ownership
- Specify: phase-model includes converge; shrink quick-start/orchestrator; confidence portable; troubleshooting triage; bootstrap warn/verify
- templates/README starter≠gold; CLI help epilog + adopt-sdd warn; sync-check labeled maintainer

**Rubric axes (1–5):** clarity · uniqueness · accuracy · actionability · layer correctness — each with one why-sentence.

---

## 0. Executive summary (controversial verdicts)

1. **Day-1 still over-indexes Spec Kit.** `docs/day1.md` step 1 installs `specify-cli` before the teammate opens a product repo — wrong for Integrity_Lab / platform eng who may never run SDD. **Verdict:** Rewrite day1 so Spec Kit is an optional branch after global harness works.
2. **`ownership.md` + `global-harness.md` duplicate ~60%.** Merge into one primary “Where things live + how to install the machine layer,” with a short global-harness appendix or fold entirely.
3. **Product rule starters ≠ MNW gold.** Guide scaffolds `think-before-coding.mdc`, `surgical-changes.mdc`, … while MNW ships `00-orchestrator.mdc`, `engineering-discipline.mdc`, … Docs never explain that gap → teammates copy pedagogy and think they have the gold model. **Must document:** starter pack vs gold reference.
4. **`docs/examples.md` should be Cut** (fold 6 CLI lines into day1/product-repo; link `cursor-setup --help`).
5. **Specify set is a second wiki.** Gates/sync/flags restated 3–5×; **phase-model omits `converge`** while quick-start/orchestrator include it — accuracy bug. Shrink quick-start; make phase-model SSOT for order; trim orchestrator install duplication.
6. **CLI: Keep, narrow in docs.** Keep `doctor` / `install-global` / `refresh-global` / `scaffold-repo` / `adopt-sdd`. Treat `sync-check` as **maintainer** (SYNC.md), not day-1 “Next.” Do **not** remove the CLI — it earns its keep for install friction — but stop teaching every journey as CLI-first without explaining *why*.
7. **Company MCP thin pointer: Keep.** Deep guide stays MNW (previous AUDIT was right).
8. **Root redirects: Keep.** Cheap, prevent link rot.
9. **`docs/AUDIT.md`:** Cut or archive after this file is approved (meta noise in README directory map).

---

## 1. Root `README.md`

| Field | Assessment |
|-------|------------|
| **Audience moment** | First open of the repo / GitHub landing |
| **Job-to-be-done** | Know what this repo is, pick one journey, run first commands without reading the wiki |
| **Must-keep facts** | Adoption hub ≠ runtime SSOT; three SSOTs table (ctl / MNW SDD guide / product harness); Spec Kit 0.13.0 pin; MNW optional for day-1; three journeys |
| **Problems** | (1) “Why the rest exists” + full directory map + supporting-guides table still feels wiki-like after the “three journeys” win. (2) Directory map advertises `docs/AUDIT.md` — meta, not teammate-facing. (3) Journeys 2–3 jump straight to CLI without one sentence of *when you need SDD*. (4) No “I only write platform UI / lab infra” path. |
| **Scores** | clarity 3 — journeys help, rest dilutes · uniqueness 3 — overlaps day1 · accuracy 4 — SSOT table good · actionability 4 — clone commands present · layer 4 — correctly positions guide |
| **Need verdict** | **Rewrite** |
| **Proposed outline** | H1 title · one-paragraph what/not · SSOT table · **Start here** (3 journeys + optional “I maintain templates”) · 5-line layer legend · link to ownership · drop AUDIT from map · supporting guides as single collapsed list or omit |
| **Ownership note** | README owns routing only; must not re-teach ctl install (→ day1) |

**Redirect stubs** (`day1-setup.md`, `scope.md`, …): **Keep** — “Moved” one-liners are correct.

---

## 2. `docs/day1.md` (+ `day1-setup.md` redirect)

| Field | Assessment |
|-------|------------|
| **Audience moment** | New laptop / Cloud VM, first hour |
| **Job-to-be-done** | Machine harness works; open *my* product repo; prove skill routing; optional SDD tooling |
| **Must-keep facts** | No MNW clone required; `install-global` + `doctor`; ctl clone/sync/preflight; refresh-global after router PRs; smoke: doctor, preflight, `MANDATORY SKILL ROUTING` |
| **Problems** | (1) **§1 Spec Kit CLI** is mandatory before harness — quote: “## 1. Spec Kit CLI” then `uv tool install specify-cli` — forces SDD toolchain on all roles. (2) §5 optional smoke `specify workflow list` is fine; making specify step 1 is not. (3) “Next” pushes `sync-check --mnw` — maintainer task, confuses day-1. (4) Does not say what “skill routing” looks like if you only open Integrity_Lab. |
| **Scores** | clarity 3 · uniqueness 4 · accuracy 4 · actionability 4 · layer 3 (pulls Spec Kit into machine day-1) |
| **Need verdict** | **Rewrite** |
| **Proposed outline** | Prereqs · Install global harness + ctl · Smoke (doctor, preflight, routing) · Open your product repo (+ scaffold if bare) · **Optional:** Spec Kit CLI + adopt-sdd · Optional MNW gold · Next links by role |
| **Ownership note** | Day1 teaches **machine** install; must not imply product `.cursor` is optional forever |

---

## 3. `docs/ownership.md` + `docs/global-harness.md`

### 3a. ownership.md

| Field | Assessment |
|-------|------------|
| **Audience moment** | “Where do I put this rule/skill?” / multi-repo confusion |
| **Job-to-be-done** | Decide machine vs product vs gold vs ctl without Slack |
| **Must-keep facts** | Multi-repo map; project vs global trees; stub vs full; promotion rules; SDD placement table; no secrets in global |
| **Problems** | (1) Overlaps global-harness install commands and layout tree almost verbatim. (2) “Rules and skills can live in two places” understates guide + gold as third/fourth homes. (3) Does not call out **starter templates ≠ MNW gold rules** (naming mismatch). (4) Flowchart buried after long tables. |
| **Scores** | clarity 4 · uniqueness 3 (vs global-harness) · accuracy 4 · actionability 3 · layer 5 |
| **Need verdict** | **Merge** (absorb global-harness install/refresh here or become the single SSOT) |
| **Proposed outline** | Decision flowchart first · Multi-repo map · Machine vs product trees · Stub policy · Promotion rules · SDD placement · “Starter vs gold” callout · Link day1 for install |
| **Ownership note** | This page *is* the ownership SSOT for the org adoption story |

### 3b. global-harness.md

| Field | Assessment |
|-------|------------|
| **Audience moment** | After day1, deep dive on `~/.cursor` |
| **Job-to-be-done** | Know layout, always-on vs on-demand rules, refresh duty |
| **Must-keep facts** | Live router is per-machine; rule file lists; stub/personal/symlink skill kinds; ctl sync |
| **Problems** | (1) Install block duplicates day1 + ownership. (2) “What still belongs in the repo” duplicates ownership/product-repo. (3) Rule lists useful but no *why each always-on exists* (one line each would help adapt). |
| **Scores** | clarity 4 · uniqueness 2 · accuracy 5 · actionability 4 · layer 5 |
| **Need verdict** | **Merge into ownership.md** (keep a short `# Machine harness` section) **or Cut** if day1+ownership cover install |
| **Proposed outline** | If kept as section: Layout · Always-on (name + one-line why) · On-demand · Skills kinds · Refresh duty · link ctl |
| **Ownership note** | Correctly machine-scoped |

---

## 4. `docs/product-repo.md`

| Field | Assessment |
|-------|------------|
| **Audience moment** | Bare or under-harnessed product repo |
| **Job-to-be-done** | Scaffold baseline `.cursor/`, know optional orchestrator hooks, optionally adopt SDD |
| **Must-keep facts** | `scaffold-repo`; edit `project.mdc`; commit `.cursor/`; orchestrator hooks shipped but not wired; `adopt-sdd` + lint/test flags; MNW optional gold |
| **Problems** | (1) No inventory of *which* starter `.mdc` files land or that they differ from MNW. (2) “Merge sdd-orchestrator-snippet” is vague — into what file? (3) Python lint/test examples bias non-Python repos. (4) No “minimal harness for Lab/infra” path (hooks-only?). |
| **Scores** | clarity 3 · uniqueness 4 · accuracy 4 · actionability 4 · layer 4 |
| **Need verdict** | **Rewrite** |
| **Proposed outline** | When you need this · Scaffold what you get (table) · Edit project.mdc (checklist) · Optional orchestrator hooks · Adopt SDD (stack-agnostic flags) · Compare to gold (optional) |
| **Ownership note** | Product scope; must not pull global router into repo (MNW does wire `route-skills-before-prompt` — call out as gold-only pattern) |

---

## 5. Rules / skills / hooks

### 5a. `docs/rules.md`

| Field | Assessment |
|-------|------------|
| **Audience moment** | Authoring or adapting rules |
| **Job-to-be-done** | Write a short good rule; know which pack to copy |
| **Must-keep facts** | alwaysApply vs globs; three install paths; core starter list; glob-gated SDD |
| **Problems** | (1) No example frontmatter block. (2) No anti-patterns (novel-length rules, secrets, alwaysApply everything). (3) Gold MNW rule set mentioned but not contrasted with starters. (4) Thin — fine if linked from product-repo; as standalone feels unfinished. |
| **Scores** | clarity 3 · uniqueness 3 · accuracy 4 · actionability 3 · layer 4 |
| **Need verdict** | **Rewrite** (or Merge authoring tips into product-repo + ownership; keep short reference) |
| **Proposed outline** | Anatomy · Good vs bad · Where to put · Starter pack vs gold · Maintenance/refresh |
| **Ownership note** | Correct |

### 5b. `docs/skills.md`

| Field | Assessment |
|-------|------------|
| **Audience moment** | When to write a skill vs rule; stub policy |
| **Job-to-be-done** | Create/copy a skill without duplicating gold |
| **Must-keep facts** | Rules vs skills table; stub vs full; org skill roles; pedagogy templates not for prod |
| **Problems** | (1) Fireflies example assumes MNW ops knowledge. (2) No “when *not* to global-stub.” (3) Doesn’t list what `install-global` stubs by name (manifest). |
| **Scores** | clarity 4 · uniqueness 4 · accuracy 4 · actionability 3 · layer 5 |
| **Need verdict** | **Rewrite** (add stub manifest pointer + when to promote) |
| **Proposed outline** | Rules vs skills · Anatomy · Stub policy + manifest · Org catalog (roles) · Authoring · Company MCP pointer |
| **Ownership note** | Correct; reinforce gold = MNW for many shared skills |

### 5c. `docs/hooks.md`

| Field | Assessment |
|-------|------------|
| **Audience moment** | Understanding enforcement vs observation |
| **Job-to-be-done** | Know security trio, optional orchestrator hooks, global router refresh |
| **Must-keep facts** | Fail-closed vs fail-open; trio scripts; orchestrator optional + not in default hooks.json; refresh-global for router |
| **Problems** | (1) No minimal `hooks.json` snippet in-page (points at templates only). (2) MNW wires repo `route-skills-before-prompt` — guide says global router only; **accuracy gap** for gold. (3) Custom hook guidance thin but OK. |
| **Scores** | clarity 4 · uniqueness 4 · accuracy 3 · actionability 3 · layer 4 |
| **Need verdict** | **Rewrite** (document gold dual-router pattern: global + optional repo wrapper) |
| **Proposed outline** | Layers · Security baseline (+ snippet) · Optional orchestrator · Global router · Gold note · Writing hooks |
| **Ownership note** | Global router = machine; product hooks = repo |

---

## 6. MCP / company-mcp / agents / examples

### 6a. `docs/mcp.md`

| Field | Assessment |
|-------|------------|
| **Audience moment** | Enabling tools safely |
| **Job-to-be-done** | Prefer Team/repo MCP; avoid secretful personal mcp.json |
| **Must-keep facts** | Team MCP preference; placeholder product mcp.json; supply-chain approval |
| **Problems** | Too short to stand alone; URLs deferred entirely — OK if company-mcp owns KB. Little “how to add a server” for non-KB cases. |
| **Scores** | clarity 4 · uniqueness 3 · accuracy 4 · actionability 3 · layer 4 |
| **Need verdict** | **Keep structure, Rewrite** lightly (merge company-mcp section or keep thin + link) |
| **Proposed outline** | When MCP · Personal vs Team vs repo · IntegrityKB → company-mcp · Safety |
| **Ownership note** | Correct |

### 6b. `docs/company-mcp.md`

| Field | Assessment |
|-------|------------|
| **Audience moment** | FE/sales/PM need company context |
| **Job-to-be-done** | Find SSOT guide + pack-first habits; know skill copy path |
| **Must-keep facts** | MNW deep guide SSOT; pack-first; resolve before search; skill template path |
| **Problems** | Previous AUDIT thinned correctly; still slightly duplicates deep guide’s “who/quick start.” Fine. |
| **Scores** | clarity 5 · uniqueness 4 · accuracy 5 · actionability 4 · layer 5 |
| **Need verdict** | **Keep** (minor polish only) |
| **Proposed outline** | Keep current; optional “not for day-1 eng” eyebrow |
| **Ownership note** | Correct — deep content must not return to guide |

### 6c. `docs/agents.md`

| Field | Assessment |
|-------|------------|
| **Audience moment** | Adding Cloud Agent entrypoint to a product repo |
| **Job-to-be-done** | Write thin AGENTS.md; know relationship to day1 vs product docs |
| **Must-keep facts** | Thin index; link rules; fake env pattern; don’t paste whole guide |
| **Problems** | Still MNW-centric examples (Doppler, pytest) without “adapt to your stack.” No sample skeleton. |
| **Scores** | clarity 3 · uniqueness 4 · accuracy 3 · actionability 3 · layer 4 |
| **Need verdict** | **Rewrite** (add skeleton; de-MNW examples) |
| **Proposed outline** | Purpose · Skeleton · Gold link · vs day1 / docs/agents |
| **Ownership note** | Product root file, not global |

### 6d. `docs/examples.md`

| Field | Assessment |
|-------|------------|
| **Audience moment** | Someone hunting snippets |
| **Job-to-be-done** | Copy commands |
| **Must-keep facts** | None unique — all elsewhere |
| **Problems** | Explicitly says prefer CLI help; page is pure duplication of day1/product-repo/quick-start. |
| **Scores** | clarity 5 · uniqueness **1** · accuracy 4 · actionability 4 · layer 3 |
| **Need verdict** | **Cut** — fold any missing line into day1/product-repo; redirect root `EXAMPLES.md` → day1 or product-repo |
| **Proposed outline** | delete; fold |
| **Ownership note** | n/a |

---

## 7. `docs/specify/*`

### Cross-cutting specify findings

- **Duplication:** day1 sync/preflight, gates, flags, deprecated aliases, identical `sdd-run` blocks appear across quick-start, bootstrap, orchestrator, workflows, remote-handoff, troubleshooting.
- **Accuracy:** `phase-model.md` locked order **omits converge**; `quick-start.md` lines 28–29 and orchestrator/persona_comms assume converge. Fix in rewrite; phase-model must be SSOT for order.
- **Portable vs gold:** confidence-loop / managed-vs-custom / remote-handoff embed MNW paths (`docs/assessments/…`, `scripts/handoff_to_mac_mini.sh`, MNW lint commands).

### Per-page verdicts

| Page | Scores (c/u/a/act/layer) | Verdict | Role after rewrite |
|------|--------------------------|---------|---------------------|
| `README.md` | 3/3/4/2/4 | **Rewrite** | Ordered hub: adopt → daily → reference; when to use vs MNW SDD_USER_GUIDE |
| `overview.md` | 4/4/5/3/4 | **Keep** (trim) | Conceptual three surfaces + org delta only — no install inventory |
| `quick-start.md` | 3/2/3/4/3 | **Rewrite** | Pocket card: chat phrases + 3 CLI recipes; link flags/gates out |
| `bootstrap.md` | 4/4/4/4/4 | **Keep** (expand verify; manual → appendix) | Single adopt runbook via CLI |
| `phase-model.md` | 3/4/2/3/4 | **Rewrite** | Canonical phase graph **including converge** + gate matrix |
| `workflows.md` | 3/3/4/3/4 | **Keep** (dedupe gates) | `sdd`/`sdd-remote` control-flow only |
| `orchestrator.md` | 3/2/4/3/3 | **Rewrite** (split or cut install) | Invoke/configure ctl; pointer to ctl README for matrices; no day1 dump |
| `remote-handoff.md` | 3/3/3/3/3 | **Keep** (trim CLI; portable script note) | Mini-only checklist |
| `confidence-loop.md` | 3/3/3/3/3 | **Rewrite** | Portable contract; **Move** MNW learning-log path notes to MNW |
| `managed-vs-custom.md` | 3/3/4/3/4 | **Keep** (strip MNW diary) | Safe-to-edit matrix + SYNC/deltas links |
| `troubleshooting.md` | 4/3/4/4/4 | **Keep** (add triage order) | Symptom → one fix + links |

**Proposed reading order (specify):** overview → bootstrap (once) → quick-start (daily) → phase-model (when confused) → rest as reference.

---

## 8. Templates + SYNC + manifest

| Field | Assessment |
|-------|------------|
| **Audience moment** | Maintainer syncing gold; adopter peeking at pack contents |
| **Job-to-be-done** | Know four trees; resync without guessing paths |
| **Must-keep facts** | global/product/skills/spec-kit destinations; SYNC path map; sync-manifest for CLI; orchestrator hooks optional |
| **Problems** | (1) `templates/README` still catalog-heavy. (2) **No warning** that `product/*.mdc` pedagogy ≠ MNW rule names. (3) Pedagogy skills under `product/` easy to mistake for required. (4) SYNC + manifest + human table — three sources; OK if manifest is authoritative (document that). |
| **Scores** | clarity 3 · uniqueness 4 · accuracy 3 · actionability 4 · layer 4 |
| **Need verdict** | **Rewrite** README/SYNC intros; **Keep** four-tree layout (earns keep under 1B) |
| **Proposed outline** | Who should touch templates · Four trees · Starter vs gold · SYNC/manifest SSOT · Do not sync list |
| **Ownership note** | Guide owns adoption copies; MNW/machine own gold bytes |

**Layout verdict (1B):** **Keep** `templates/{global,product,skills,spec-kit}` — clear improvement over flat `templates/*.mdc`. Do not revert.

---

## 9. `bin/cursor-setup` (as a section)

| Field | Assessment |
|-------|------------|
| **Audience moment** | Install/adapt without manual cp |
| **Job-to-be-done** | doctor / install / scaffold / adopt / maintainer sync-check |
| **Must-keep facts** | Commands listed in `--help`; does not vendor ctl; stubs don’t overwrite personal skills |
| **Problems** | (1) Docs treat CLI as the product; little explanation of what files move (undermines “adapt”). (2) `sync-check` in day1 Next. (3) `adopt-sdd` still runs `specify init` with `--force` — dangerous if misunderstood (docs must warn). (4) No `cursor-setup --version` / guide pin. (5) Help text is fine; no man-page beyond argparse. |
| **Scores** | clarity 4 · uniqueness 5 · accuracy 4 · actionability 5 · layer 4 |
| **Need verdict** | **Keep CLI; Rewrite how docs teach it** — optional small CLI UX: warn on adopt-sdd; mark sync-check maintainer in help epilog |
| **Proposed outline** | In docs: “What the CLI does” one table (command → files touched → when). Help epilog: sync-check = maintainers |
| **Ownership note** | Tooling lives in guide repo; not a substitute for ownership understanding |

**CLI structural verdict (1B):** **Keep as-is functionally**; do **not** expand to fuller framework; do **not** delete. Narrow *documentation* surface.

---

## 10. Three-layer ownership matrix (live eval)

### 10.1 What lives where (recommended)

| Asset | Machine `~/.cursor` | Guide (templates/docs/CLI) | Product repo | MNW gold |
|-------|---------------------|----------------------------|--------------|----------|
| Skill router | **Live** | Copy in `templates/global` | Optional wrapper (MNW pattern) | Wrapper + WADE_REPO_KEY |
| Always-on safety rules | **Live** | `templates/global/rules` | No | May restate stack-specific in project rules |
| On-demand shared rules | **Live** | Same templates | No | No |
| `sdd-orchestrator-ctl` | **Live** clone | Docs/install only | Policy in `.specify/orchestrator.json` | Policy + workflows |
| Pointer stubs | **Live** | Created by install-global | Full `speckit-*` when adopted | Full skill bodies |
| Personal ops (`lab-host-ssh`) | **Live** only | Do not template secrets/hosts | No | No |
| Security hooks | — | `templates/product/hooks` | **Committed** | Full set + orchestrator + route wrapper |
| Product rules | — | Pedagogy starters | **Committed** (adapted) | Mature named set |
| Ops skills | — | Portable subset (sdd-entry, company-mcp, confidence*) | **Committed** as needed | Full catalog (~28) |
| SDD workflows / user guide | — | `templates/spec-kit` | `.specify/` + docs | SSOT bytes |
| Company MCP deep guide | — | Thin pointer only | Link or copy skill | **SSOT** doc + skill |
| Adoption narrative | — | **SSOT** | Thin AGENTS.md | Product SDD daily guide |

### 10.2 Deltas: guide claims vs live

| Finding | Evidence | Imbalance |
|---------|----------|-----------|
| Global rules now match machine (9 files) | `templates/global/rules` ↔ `~/.cursor/rules` | Aligned after prior pass |
| Global `speckit-*` stubs ~1.1–1.3KB with pointer language | `wc` on `~/.cursor/skills` | Aligned with stub policy; doctor heuristic still fuzzy |
| `session-handoff` 2257B — larger than stubs | live skills | Borderline; decide stub vs personal |
| `sdd-program` empty dir | live | Noise; ignore or document |
| Product starters ≠ MNW rules | guide `think-before-coding` vs MNW `engineering-discipline` | **Undocumented** — highest adapt confusion |
| MNW hooks.json includes repo skill route + orchestrator | MNW hooks vs guide product hooks.json | Guide optional scripts OK; **docs under-explain gold dual routing** |
| Guide does not ship most MNW ops skills | 28 vs few in templates/skills | Correct — must say “copy from gold if needed,” not imply scaffold = full platform |
| `multi-repo-workspace.mdc` still describes data-api/integrity-ts layout | global rule content | Accurate for platform; dense for MNW-only eng — OK as on-demand |

### 10.3 Promotion rules (confirm / amend)

1. Cross-repo safety/routing/ctl → machine via guide templates. **Confirm.**
2. Collaborator procedures → product skills. **Confirm.**
3. SDD workers → product + optional stubs. **Confirm.**
4. Reusable pattern from MNW → sync to guide → refresh/scaffold. **Confirm**; add: **document starter≠gold when pedagogy diverges.**
5. Personal/host → machine only. **Confirm.**

---

## 11. Cohesion map (install → use → adapt)

### Primary path (all Wade eng)

1. [README](../README.md) — pick journey  
2. [day1](./day1.md) — machine harness (Spec Kit optional)  
3. [ownership](./ownership.md) — where to put things (merged with global harness)  
4. Open product repo → [product-repo](./product-repo.md) if bare  

### Use path (daily coding)

- Product `.cursor/rules` + skills (repo)  
- Global router (invisible if healthy)  
- Optional: [rules](./rules.md) / [skills](./skills.md) / [hooks](./hooks.md) when authoring  

### Adapt path (SDD / MCP / Cloud)

- SDD: [specify/overview](./specify/overview.md) → [bootstrap](./specify/bootstrap.md) → [quick-start](./specify/quick-start.md); MNW `SDD_USER_GUIDE` when working in MNW  
- Company MCP: [company-mcp](./company-mcp.md) → MNW deep guide  
- Cloud: [agents](./agents.md)  

### Cut / demote

| Page | Action |
|------|--------|
| `docs/examples.md` | **Cut** |
| `docs/AUDIT.md` | **Cut/archive** after this eval approved |
| `docs/global-harness.md` | **Merge** into ownership |
| Root legacy names | Keep redirects |
| `docs/examples` content | Already in CLI/--help |

### Page roles after rewrite

| Role | Pages |
|------|-------|
| Primary | README, day1, ownership (merged), product-repo |
| Authoring reference | rules, skills, hooks, mcp, agents |
| Thin pointer | company-mcp |
| SDD reference | specify/* (shrunk quick-start / orchestrator; fixed phase-model) |
| Maintainer | templates/README, SYNC, sync-check |

---

## 12. Structural recommendations (1B — justified)

| Structure | Verdict | Why |
|-----------|---------|-----|
| `docs/` journey tree | **Keep** | Clearer than root wiki; content still needs rewrite |
| Root redirects | **Keep** | Link safety |
| `templates/{global,product,skills,spec-kit}` | **Keep** | Fixes three-homes confusion |
| `bin/cursor-setup` | **Keep** (docs narrow sync-check; warn adopt-sdd) | Install friction is real; deleting CLI recreates cp drift |
| Expand CLI further | **No** | Understanding already hidden behind commands |
| Move deep SDD entirely to MNW | **No** — keep portable adopt in guide; MNW keeps product daily guide | Other repos need bootstrap without cloning MNW app |
| Return Company MCP deep guide to guide | **No** | Drift magnet |

---

## 13. CLI verdict (explicit)

**Keep as-is** for: `doctor`, `install-global`, `refresh-global`, `scaffold-repo`, `adopt-sdd`.  

**Docs change:** `sync-check` = maintainer only.  

**Optional small code tweak (Phase B if approved):** help epilog + adopt-sdd warning that `--force` specify init can overwrite; print file-touch summary after scaffold.

**Not recommended:** remove CLI; add more subcommands before content rewrite lands.

---

## 14. Previous AUDIT.md vs this eval

| Prior AUDIT claim | This eval |
|-------------------|-----------|
| day1 Rewrite (any-repo) | Agree — **and** Spec Kit must become optional |
| scope+global-env Merge | Agree — ownership absorbs global-harness |
| EXAMPLES fold | Stronger: **Cut** page |
| specify deep Keep/trim | Agree + **phase-model accuracy bug** + orchestrator shrink |
| company-mcp Thin | Agree Keep |
| CLI must cover all commands | Soften: don’t put sync-check on day1 path |

---

## Gate

**Approved** via human “run it all” (2026-07-22). Phase B rewrite landed; Phase C cohesion smoke passed (`doctor` exit 0; journey links README → day1 → ownership → product-repo).

### Approval checklist

- [x] Day1: Spec Kit optional  
- [x] Merge global-harness into ownership  
- [x] Cut examples.md  
- [x] Keep CLI; narrow sync-check in docs  
- [x] Specify: fix converge in phase-model; shrink quick-start/orchestrator  
- [x] Document starter≠gold product rules  

