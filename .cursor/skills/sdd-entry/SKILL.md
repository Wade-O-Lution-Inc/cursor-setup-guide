---
name: sdd-entry
description: >-
  Kickoff for Spec-Driven Development. Use for Start SDD, Continue SDD,
  Spec this feature, sdd / sdd-remote workflows, or any multi-step SDD loop.
  Resolves FEATURE_DIR + next PHASE, then always runs sdd-orchestrator —
  never invoke bare speckit-* as the top-level skill.
disable-model-invocation: true
---

# SDD Entry

**Read first:** [docs/agents/SDD_USER_GUIDE.md](../../docs/agents/SDD_USER_GUIDE.md).

Every phase transition goes through **`sdd-orchestrator`** (worker → D-hooks →
judge → gate). Bare `speckit-*` skills are the **worker procedure** the
orchestrator invokes — not a separate front door.

## Chat — verbs

| Intent | What you do |
|--------|-------------|
| **Start SDD: \<what/why\>** | Explicit Full entry. Pin `workflow_profile=full`, run **specify → clarify → plan → tasks → analyze → implement → converge → confidence**. |
| **Start SDD Lite: \<what/why\>** | Explicit Lite entry. Pin `workflow_profile=lite`, run **specify → plan → implement → light_gate**. Default model profile **lean** when unset. |
| **Start SDD Review** | Explicit Review entry (PR URL or current branch). Pin `workflow_profile=review`, run **inspect → verdict**. Scratch dir `.specify/reviews/pr-<n>/` (gitignored). Default model **lean**. Never a development build loop. |
| **Continue SDD** | Resume current branch / feature dir; orchestrate the next ungated phase (profile-aware — see below). |
| **Suggest SDD route** | Phase 2 advisory only: `sdd-ctl advise-route` — never auto-pins a profile. Never recommends `review`. |

Aliases: `Spec this feature: …`, `Continue SDD on branch …`, `Start SDD Lite: …`, `Start SDD Review: <pr-url>`.

Optional natural-language flags: `scope=api`, `stop at plan`, `emit issues`,
`remote after tasks`, `test-fix mode`, `Use lean|balanced|frontier`.

Profile helpers:

```text
Start SDD: <what/why>. Use balanced.
Start SDD Lite: <what/why>.
Start SDD Review: <pr-url-or-branch>.
Continue SDD using frontier.
Show SDD profile.
Explain current SDD routing.
Suggest SDD route: <what/why>   # advisory only (Phase 2)
```

**Start SDD Lite** MUST pass `--workflow-profile lite` to `plan-phase` / `sdd-run` so the feature pin is explicit (FR-004). Eligibility warnings are advisory — they never rewrite pins.

Profiles are the normal cost/reliability choice (`lean` / `balanced` /
`frontier`). Reject raw model-name overrides in chat; recommend a profile.
Repo default lives in `.specify/orchestrator.json` → `model_profile`
(currently `balanced`, the evaluated ctl default). Mid-feature profile switches
require explicit confirmation and are runlogged via the feature pin.

## Procedure (every chat turn)

1. **Sync the shared engine to `origin/main`** (required on every Start /
   Continue). Runtime installs must not sit on feature branches:

   ```bash
   python3 ~/.cursor/sdd-orchestrator-ctl/bin/sdd-ctl sync
   python3 ~/.cursor/sdd-orchestrator-ctl/bin/sdd-ctl preflight
   ```

   If sync fails (dirty tree / diverged history), stop and report — do not
   continue SDD on a stale or branched ctl. Escape hatch for *developing*
   sdd-orchestrator itself only: `SDD_CTL_SKIP_INSTALL_PREFLIGHT=1` or
   `plan-phase --skip-install-preflight` (never on laptop/mini operator hosts).
2. Confirm `.specify/` exists (`specify integration status` if unsure).
3. Resolve **FEATURE_DIR**:
   - **Start SDD Review**: `.specify/reviews/pr-<n>/` (create if missing; gitignored). Do not use `specs/NNN-*`.
   - On branch `NNN-*` or with an existing feature dir → use it (Full/Lite).
   - Start SDD with no dir yet → FEATURE_DIR is created by the specify worker.
4. Resolve active **workflow_profile** before choosing the next phase:
   - Read `.specify/orchestrator-runs/<feature-slug>.workflow.json` when present (`workflow_profile`: `full` | `lite` | `review`).
   - Or infer from the last explicit entry (`--workflow-profile lite|review`, `mode=lite`, **Start SDD Lite**, **Start SDD Review**).
   - Default when absent: **`full`**.
   - `advise-route` never pins `review`.
5. Resolve next **PHASE** from runlog / `phase-exits.md` (first phase without a passing row):

   **Full (`workflow_profile=full`)** — canonical order:

   `specify → clarify → plan → tasks → analyze → implement → converge → confidence`

   - Do not skip **clarify** before **plan**.
   - Do **not** run **implement** without `tasks.md`.
   - Honor stop flags (`stop at plan` / `stop at tasks`).

   **Lite (`workflow_profile=lite`)** — canonical order:

   `specify → plan → implement → light_gate` (terminal)

   - Do **not** require `tasks.md` on the happy path; implement reads `## Implementation Worklist` from `plan.md`.
   - Do **not** route to Full-only phases (`clarify`, `tasks`, `analyze`, `converge`, `confidence`) unless the operator explicitly switches profile with confirmation.
   - After a passing **implement**, next phase is **light_gate** (not converge/confidence).
   - Passing **light_gate** completes the feature (terminal end report via `sdd-ctl report`).

   **Review (`workflow_profile=review`)** — canonical order:

   `inspect → verdict` (terminal)

   - Not a development loop. Do **not** run specify/plan/implement.
   - Spec/plan are optional evidence. Missing spec is not a fail.
   - Pass `--workflow-profile review` on every `plan-phase`. Default model **lean**.
   - Passing **verdict** completes the review (GitHub APPROVE or REQUEST_CHANGES; never merge).

6. **Must** read and follow `~/.cursor/skills/sdd-orchestrator/SKILL.md` for
   that PHASE (FEATURE_DIR + PHASE) in `auto_chain` mode. Preserve the original
   Start SDD what/why as `--feature-description` for specify. Pass
   `--workflow-profile lite` or `--workflow-profile review` on every plan-phase when
   the pin is Lite or Review. Do **not** call
   `speckit-*` as the top-level skill.
7. Passing phases auto-continue. Prefer `next_phase` from `sdd-ctl record`
   (Full: converge may return `implement` under the round cap, else `confidence`;
   Lite: implement → light_gate, then terminal;
   Review: inspect → verdict, then terminal). Stop only when `sdd-ctl` returns
   `stop` (repair cap exhausted), the requested `stop_at` boundary is reached, or the
   repository opts into `gate_mode: interactive`. After a `stop`, do **not** leave the
   SDD chain for ad-hoc implementation: fix the artifact, then **Continue SDD** so the
   driver re-enters the same failing phase with `--repairs-used` from history
   (escalated attempt when `repair_cap >= 2`; Lite cap is 1 — then escalate to Full per report).

Headless twin of Continue: `~/.cursor/sdd-orchestrator-ctl/bin/sdd-run`
(see `~/.cursor/sdd-orchestrator-ctl/README.md`).

## CLI — two workflows

```bash
specify workflow run sdd -i spec="..." -i integration=cursor-agent \
  -i scope=full|api-only|frontend-only \
  -i stop_at=confidence|tasks|plan -i issues=false \
  -i mode=full|lite|test-fix \
  -i model_profile=balanced

specify workflow run sdd-remote -i spec="..." -i remote_phase=implement \
  -i interval=600 -i model_profile=lean
# transfer only: -i transfer_only=true
```

Only `sdd`, `sdd-remote`, and the upstream `speckit` workflow are registered.

## Brownfield

Before specify: closest pattern in `project.mdc` → *Finding the Right Pattern*.

## Handoff

On compact/checkpoint: include progress from `specs/.../tasks.md` (Full) or
`specs/.../plan.md` Implementation Worklist (Lite). Read `.cursor/auto-context.md`
Spec Progress on resume.

## Repo hooks (advise-route hint)

Project hook `.cursor/hooks/route-sdd-advise-before-prompt.sh` (see `.cursor/hooks/README.md`)
offers a **non-blocking** hint when the operator asks **Suggest SDD route** — complements
this skill; does not replace explicit **Start SDD Lite** entry.

Deep reference: [docs/agents/SPEC_DRIVEN_DEVELOPMENT.md](../../docs/agents/SPEC_DRIVEN_DEVELOPMENT.md)
