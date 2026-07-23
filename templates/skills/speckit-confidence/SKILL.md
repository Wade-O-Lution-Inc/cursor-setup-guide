---
name: "speckit-confidence"
description: "Score implementation confidence across accuracy, complexity, and performance, then reflect-and-loop back through earlier SDD phases until highly confident or a max-iteration cap is hit."
compatibility: "Requires spec-kit project structure with .specify/ directory"
metadata:
  author: "Integrity"
  source: "local: speckit-confidence (reflect-and-loop terminal phase)"
---


## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Pre-Execution Checks

**Check for extension hooks (before scoring)**:
- Check if `.specify/extensions.yml` exists in the project root.
- If it exists, read it and look for entries under the `hooks.before_confidence` key
- If the YAML cannot be parsed or is invalid, skip hook checking silently and continue normally
- Filter out hooks where `enabled` is explicitly `false`. Treat hooks without an `enabled` field as enabled by default.
- For each remaining hook, do **not** attempt to interpret or evaluate hook `condition` expressions:
  - If the hook has no `condition` field, or it is null/empty, treat the hook as executable
  - If the hook defines a non-empty `condition`, skip the hook and leave condition evaluation to the HookExecutor implementation
- When constructing slash commands from hook command names, replace dots (`.`) with hyphens (`-`). For example, `speckit.git.commit` → `/speckit-git-commit`.
- For each executable hook, output the following based on its `optional` flag:
  - **Optional hook** (`optional: true`):
    ```
    ## Extension Hooks

    **Optional Pre-Hook**: {extension}
    Command: `/{command}`
    Description: {description}

    Prompt: {prompt}
    To execute: `/{command}`
    ```
  - **Mandatory hook** (`optional: false`):
    ```
    ## Extension Hooks

    **Automatic Pre-Hook**: {extension}
    Executing: `/{command}`
    EXECUTE_COMMAND: {command}

    Wait for the result of the hook command before proceeding to the Goal.
    ```
- If no hooks are registered or `.specify/extensions.yml` does not exist, skip silently

## Goal

This is the **terminal reflect-and-loop phase** of an SDD cycle. After `/speckit-implement` completes, evaluate how confident you are in the feature implementation across **three axes**, surface the specific things you are *least* confident about as concrete findings, and — if confidence is below the **highly confident** bar — route those findings back into the appropriate earlier SDD phase(s), re-implement, and re-score. Repeat until highly confident or the max-iteration cap is hit. Persist the outcome to `specs/NNN-*/confidence.md`.

This command MUST run only after `/speckit-implement` has produced a working tree (tasks in `tasks.md` marked `[X]`).

## Operating Constraints

- **Honest scoring over optimistic scoring.** The point of this phase is to catch weak spots, not to rubber-stamp. If unsure, score lower and write a finding.
- **Practice the complexity principle.** Loop-back edits must themselves be surgical and in-scope (see `.cursor/rules/engineering-discipline.mdc`). Do not add abstraction to "fix" a complexity finding.
- **Bounded.** Never exceed the max-iteration cap (default **3**). When the cap is hit, take the diminishing-returns escape — record residual risk; do not loop forever.
- **Re-clarify is the exception.** Only loop back to `/speckit-clarify` when scope is genuinely ambiguous; default loop-back targets are plan/tasks/implement.
- **Template format is mandatory (CF-05).** `confidence.md` MUST use `.specify/templates/confidence-template.md` with its Scoreboard, per-iteration Effort Checks/Findings/Actions/Decision sections, and Final Decision. Do not substitute a free-form summary or remove required headings/tables.
- **Phase-exit ownership is external.** The worker MUST NOT create, append, or edit `phase-exits.md`; after validation, only `sdd-ctl record` through the SDD orchestrator writes it.

## Confidence Rubric

Score **each** of the three axes on a **1–5** scale. **5 = Highly Confident** is the exit target for every axis.

### Axis 1 — Accuracy / End-to-End Functionality

Does the implementation actually deliver the spec's user stories and Functional Requirements end to end, with passing tests?

| Score | Meaning |
|-------|---------|
| 5 — Highly Confident | Every FR and prioritized user story is implemented and traceable to passing tests; quality gates green; edge cases from spec handled. |
| 4 — High | All P1/P2 stories work end to end; minor edge case or a non-blocking test gap remains. |
| 3 — Moderate | Core happy path works but ≥1 FR is partial, or tests cover code but not the user story end to end. |
| 2 — Low | Significant FR or user story unimplemented, or tests failing/flaky. |
| 1 — Very Low | Feature does not deliver its primary user story, or no meaningful test coverage. |

### Axis 2 — Complexity (lower necessary complexity = higher confidence)

How confident are you that the implementation is **as simple as optimal**? **Unnecessary complexity, over-engineering, and excess code are penalized — they LOWER this score.** Reward minimal-sufficient implementations and removing/avoiding unneeded abstraction.

| Score | Meaning |
|-------|---------|
| 5 — Highly Confident | Minimal-sufficient: no speculative generality, no unused abstraction, smallest change that solves the problem; matches existing sibling patterns; complexity present is *essential* to the requirements. |
| 4 — High | Largely lean; one small simplification opportunity identified but low-risk. |
| 3 — Moderate | Some avoidable indirection, a premature helper/abstraction with a single caller, or duplicated logic that should be consolidated. |
| 2 — Low | Clear over-engineering: new framework/layer where a function would do, config/flags nothing uses, code well beyond what the spec requires. |
| 1 — Very Low | Pervasive unnecessary complexity; the implementation is substantially larger/harder than the problem warrants. |

> Anti-pattern reminder: a large, "flexible," highly abstracted solution is **worse**, not better. If you can delete code and still satisfy the spec + tests, this axis is below 5.

### Axis 3 — Performance

Are there performance concerns or unvalidated hot paths?

| Score | Meaning |
|-------|---------|
| 5 — Highly Confident | No obvious hot-path risks; N+1 / unbounded queries, sync calls in loops, and large in-memory scans considered and avoided or validated; relevant Success Criteria (e.g., latency) addressed. |
| 4 — High | No known issues; one path is plausibly hot but low-traffic / acceptable, with a note. |
| 3 — Moderate | A hot path exists that is reasoned about but not validated (no measurement/benchmark). |
| 2 — Low | A likely performance problem identified (e.g., N+1, unbounded fetch, blocking I/O on request path) and unaddressed. |
| 1 — Very Low | Known/likely severe performance regression on a primary path. |

## "Highly Confident" Exit Bar

Exit the loop and finalize when **ALL** of the following hold:

1. **Accuracy = 5**, **Complexity = 5**, **Performance = 5**.
2. Quality gates green: `uv run ruff check` passes **and** `doppler run -- uv run python -m pytest tests/ -x -q` passes.
3. No open CRITICAL/HIGH findings remain in the current iteration.
4. Every `in_authority` check in `confidence-checks.md` (if present) is `pass`. **`escalate`-tagged checks never block this bar** — they are recorded as residual risk immediately (see Step 2) and do not enter the loop-back table.

If the bar is not met, loop back (below) — unless the escape conditions apply.

## Execution Steps

### 1. Initialize Context

Run `.specify/scripts/bash/check-prerequisites.sh --json --require-tasks --include-tasks` once from repo root and parse JSON for `FEATURE_DIR` and `AVAILABLE_DOCS`. Derive absolute paths: `SPEC = FEATURE_DIR/spec.md`, `PLAN = FEATURE_DIR/plan.md`, `TASKS = FEATURE_DIR/tasks.md`, `CONFIDENCE = FEATURE_DIR/confidence.md`, `CHECKS = FEATURE_DIR/confidence-checks.md`. Abort with a clear message if `tasks.md` is missing or has no `[X]` items (instruct the user to run `/speckit-implement` first).

Determine the current iteration `N`: if `confidence.md` exists, `N` = (highest recorded iteration) + 1; otherwise `N = 1`. **Hard cap: `MAX_ITERATIONS = 3`.**

### 2. Re-compile Effort Checks

If `CHECKS` (`confidence-checks.md`) exists from `/speckit-plan`, re-compile it against the final `tasks.md` and the implementation diff (`git diff <base>...HEAD`) before scoring:

1. For each existing check, find its evidence: a completed task, a passing test, an eval command's output, or a diff hunk. If no evidence exists, mark it **orphaned** — drop it if the requirement turned out not to apply, or re-tag `escalate` if it still matters but needs something outside this run to verify.
2. Add new checks for diff-detected anti-overbuild risk signals (unused `Settings` field, a new module with ≤1 caller in the diff, a file changed outside the plan's stated blast radius, a new dependency line) — `scripts/eval_sdd_confidence.py`'s `detect_diff_risks()` implements this heuristic; run it against the diff, or reason through the same four signals manually if the script isn't available in this environment.
3. Classify **every** remaining check `in_authority` (you can produce the evidence yourself, here, now) or `escalate` (needs a live service, external credential, or a product/scope decision) — do this classification **before** scoring, not as a reaction to a failed loop-back attempt.
4. Score each check `pass`/`fail` against its evidence. Write the re-compiled table into `CHECKS` (update statuses in place; this file reflects current truth, not iteration history — `confidence.md` holds the history).

If `confidence-checks.md` does not exist (older feature, or plan predates this mechanism), skip this step — the three static axes remain the floor regardless.

### 3. Run Quality Gates

Run both gates and capture pass/fail + key output:

- `uv run ruff check`
- `doppler run -- uv run python -m pytest tests/ -x -q`

(If Python was not touched this cycle, ruff/pytest should be unaffected — still run them to confirm.)

### 4. Score the Three Axes

For each axis, assign a 1–5 score using the rubric above, grounded in evidence (spec FR/story coverage, the actual diff, test results, gate output, and the re-compiled effort checks from Step 2). Be specific and honest.

### 5. Enumerate Least-Confident Items as Findings

For **each axis**, list the specific things you are least confident about as actionable findings. Each finding records:

- **Axis** (Accuracy / Complexity / Performance)
- **Location** (file/area, e.g., `app/services/foo.py:fetch_all`)
- **Why** (what is weak / risky / over-built)
- **Severity** (CRITICAL / HIGH / MEDIUM / LOW)
- **What would raise confidence** (the concrete action)
- **Loop-back target phase** (see routing table)

If an axis is already 5 with no concerns, record "No findings." A `fail`-status `in_authority` effort check should always produce a corresponding finding; an `escalate`-tagged check should NOT produce a loop-back finding — record it directly under Residual instead.

### 6. Decide: Exit, Loop, or Escape

- **Exit** if the Highly Confident Exit Bar (above) is met → go to Step 8 with decision `HIGHLY_CONFIDENT`.
- **Escape** if any of these hold → go to Step 8 with decision `RESIDUAL_RISK_ACCEPTED`:
  - `N >= MAX_ITERATIONS`, **or**
  - the only remaining findings are LOW severity and the last iteration produced no score improvement (**diminishing returns**), **or**
  - a finding requires a decision/resource outside the agent's authority (scope change, new dependency, product call), **or** the only remaining open items are `escalate`-tagged effort checks — **escalate** to the user instead of looping.
- **Loop** otherwise → Step 7.

### 7. Loop Back (reflect → act → re-score)

Route findings to the appropriate earlier phase using this table, run that phase scoped to the findings, then re-run `/speckit-implement`, then re-enter this skill at Step 1 (iteration `N+1`).

| Dominant finding type | Loop-back target |
|-----------------------|------------------|
| Missing/partial FR or story; failing tests; failing `in_authority` accuracy check | `/speckit-implement` (re-implement); add `/speckit-tasks` first only if a needed task is absent |
| Over-engineering / unnecessary complexity / excess code; failing `in_authority` complexity check | `/speckit-plan` (choose the simpler approach) → `/speckit-implement` (delete/simplify code) |
| Performance risk on a hot path; failing `in_authority` performance check | `/speckit-plan` if architectural; else `/speckit-implement` to optimize; add a validation task via `/speckit-tasks` |
| Genuinely ambiguous scope/requirement | `/speckit-clarify` (only when scope is truly unclear) → re-plan as needed |

`escalate`-tagged checks are never routed here — they go straight to Residual in the Final Decision, regardless of iteration.

Write the iteration's scores, findings, and the actions you will take to `confidence.md` **before** running the loop-back phases (so progress survives a compact). Then perform the loop-back and re-score.

### 8. Write the Confidence Report

Create or update `confidence.md` from `.specify/templates/confidence-template.md`. Template conformance is mandatory for CF-05: preserve the required headings and table columns. Append one **Iteration N** block per iteration (never overwrite prior iterations) with: per-axis scores, the effort-checks results table, gate results, findings table, actions taken, and the iteration decision. On the final iteration, fill the **Final Decision** section (`HIGHLY_CONFIDENT` or `RESIDUAL_RISK_ACCEPTED` with the residual low-confidence items listed, including any `escalate`-tagged effort checks).

### 9. Check for extension hooks

After writing the report, perform the hook handling described in **Mandatory Post-Execution Hooks** below.

## Learning Log Append

After writing the Final Decision in `confidence.md` (every run, whichever outcome), append one row to `docs/assessments/SDD_CONFIDENCE_LEARNING_LOG.md` (create it from its header shape if missing — never overwrite existing rows): feature id, final decision, escape reasons (from the routing/escape logic in Step 6), a comma-separated list of recurring finding tags (short, reusable labels like `unused_flag`, `perf_unvalidated`, `env_gated` — reuse a tag from a prior run's log entry when the finding is the same kind, don't invent a new synonym), and the sum of repair counts read from this feature's `phase-exits.md`. This is data collection only — it does not itself propose or apply any change; see the optional `speckit-confidence-improve` skill for that.

**Finding-tag discipline (keeps the improve loop actionable):**
- Tag `env_gated` only when environment/live/credential gating contributed to `RESIDUAL_RISK_ACCEPTED`, or when an env check was wrongly left `in_authority` and had to be reclassified.
- Do **not** stamp `env_gated` on a `HIGHLY_CONFIDENT` exit merely because correctly tagged `escalate` residuals (staging p95, live Linear, Mac mini, Doppler) were recorded — that is expected residual, not a harness failure mode.
- Prefer tags that name a fixable harness pattern (`unused_flag`, `overbuild`, `perf_unvalidated` mis-tagged as in_authority) over tags that only restate escalate residuals.

## Mandatory Post-Execution Hooks

**You MUST complete this section before reporting completion to the user.**

Check if `.specify/extensions.yml` exists in the project root.
- If it does not exist, or no hooks are registered under `hooks.after_confidence`, skip to the Completion Report.
- If it exists, read it and look for entries under the `hooks.after_confidence` key.
- If the YAML cannot be parsed or is invalid, skip hook checking silently and continue to the Completion Report.
- Filter out hooks where `enabled` is explicitly `false`. Treat hooks without an `enabled` field as enabled by default.
- For each remaining hook, do **not** attempt to interpret or evaluate hook `condition` expressions:
  - If the hook has no `condition` field, or it is null/empty, treat the hook as executable
  - If the hook defines a non-empty `condition`, skip the hook and leave condition evaluation to the HookExecutor implementation
- When constructing slash commands from hook command names, replace dots (`.`) with hyphens (`-`). For example, `speckit.git.commit` → `/speckit-git-commit`.
- For each executable hook, output the following based on its `optional` flag:
  - **Mandatory hook** (`optional: false`) — **You MUST emit `EXECUTE_COMMAND:` for each mandatory hook**:
    ```
    ## Extension Hooks

    **Automatic Hook**: {extension}
    Executing: `/{command}`
    EXECUTE_COMMAND: {command}
    ```
  - **Optional hook** (`optional: true`):
    ```
    ## Extension Hooks

    **Optional Hook**: {extension}
    Command: `/{command}`
    Description: {description}

    Prompt: {prompt}
    To execute: `/{command}`
    ```

## Completion Report

Report final status: number of iterations run, final per-axis scores, the final decision (`HIGHLY_CONFIDENT` or `RESIDUAL_RISK_ACCEPTED`), any residual low-confidence items, and the path to `confidence.md`.

## Done When

- [ ] `confidence-checks.md` re-compiled (orphans dropped/escalated, diff-derived checks added, every check classified `in_authority`/`escalate`) — when the file exists
- [ ] All three axes scored 1–5 for the final iteration with evidence
- [ ] Quality gates run (`uv run ruff check` + `doppler run -- uv run python -m pytest tests/ -x -q`)
- [ ] Least-confident items captured as findings (location + why + action + loop-back target); `escalate`-tagged effort checks recorded as residual directly, never as loop-back findings
- [ ] Loop-back performed for sub-bar iterations, or escape taken at the cap / on diminishing returns / on escalation-only remaining items
- [ ] `confidence.md` written with per-iteration history, effort-checks results, and a Final Decision
- [ ] CF-05 passes: `confidence.md` conforms to `.specify/templates/confidence-template.md`
- [ ] One row appended to `docs/assessments/SDD_CONFIDENCE_LEARNING_LOG.md`
- [ ] Extension hooks dispatched or skipped per Mandatory Post-Execution Hooks
- [ ] Completion reported to user
