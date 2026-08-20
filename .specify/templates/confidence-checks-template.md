# Confidence Checks: [FEATURE NAME]

**Feature**: [Link to spec.md] | **Drafted**: [DATE] (at `/speckit-plan`) | **Re-compiled**: [DATE or "pending — filled at `/speckit-confidence`"]

<!--
  ============================================================================
  Drafted by /speckit-plan from this feature's own FRs/SCs/blast-radius.
  Re-compiled by /speckit-confidence at the start of each iteration from the
  final tasks.md + implementation diff (drop/escalate orphaned checks, add
  diff-derived anti-overbuild checks). These checks are ADDITIVE evidence for
  the three static confidence axes — they do not replace them.
  ============================================================================
-->

## Intent summary

[One paragraph: what this feature is actually for, in plain language — not a restatement of the FR list.]

## Complexity ceiling (what we will NOT build)

<!-- Explicit non-goals / speculative-flexibility to avoid, named up front so implement has a boundary to check against. -->

- [Thing we will not build, and why the plan doesn't need it]

## Checks

<!--
  Authority (tag at draft time — do not discover this at confidence):
  - in_authority: agent can produce evidence here/now (unit/integration test,
    ruff/pytest, EXPLAIN, static inspection of the diff).
  - escalate: needs something outside this run. Always escalate (never
    in_authority) for: staging/live p95 or deploy smoke, third-party credentials
    (Linear / Slack / Doppler tokens), Mac mini / Tailscale / embedding gateway
    reachability, and operator-only manual QA. Escalate checks are residual
    risk; they must not block HIGHLY_CONFIDENT or enter the confidence loop-back.
-->

| ID | Axis | Check | Evidence | Authority | Status |
|----|------|-------|----------|-----------|--------|
| CC-001 | Accuracy | [FR-00N / SC-00N this check verifies] | [test / eval command / EXPLAIN / manual inspection] | in_authority \| escalate | pending |

## Anti-overbuild watch-list (checked at re-compile, not scored yet)

- [Signal to watch for in the diff — unused flag, single-caller module, dependency, blast-radius drift]
