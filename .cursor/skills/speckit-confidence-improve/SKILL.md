---
name: "speckit-confidence-improve"
description: "Cluster recurring SDD confidence-loop findings into a human-reviewed improvement proposal. Never edits any skill, template, or constitution file itself."
compatibility: "Requires spec-kit project structure with .specify/ directory; reads docs/assessments/SDD_CONFIDENCE_LEARNING_LOG.md"
metadata:
  author: "meeting-notes-workflow"
  source: "spec 021-sdd-confidence-governance"
---

## Purpose

Close the recursive-improvement loop for the SDD confidence workflow **without** ever mutating the workflow itself automatically. This skill only reads `docs/assessments/SDD_CONFIDENCE_LEARNING_LOG.md`, clusters findings, and drafts a proposal for a human to review and, if they agree, apply by hand in a normal PR.

This mirrors the human-gated ρ (reflect) → proposal → human κ (commit) pattern in [`docs/agents/PROMPT_EVOLUTION_ARCHITECTURE.md`](../../docs/agents/PROMPT_EVOLUTION_ARCHITECTURE.md), adapted for harness governance instead of prompt resources.

## When to run this

- On demand, whenever an operator wants to check for recurring patterns (e.g., "any recurring confidence findings worth fixing in the harness?").
- Optionally after `/speckit-confidence` via the `after_confidence` hook in `.specify/extensions.yml` (prompted, not automatic).

## Outline

1. Run `uv run python -m scripts.eval_sdd_confidence --propose`.
2. If it prints "No recurring finding has reached the 3-occurrence threshold yet," report that and stop — there is nothing to propose.
3. If it prints a proposal, present it to the user verbatim. Do **not** paraphrase away the specific tag, feature list, or suggested-action wording — those are the evidence trail.
4. Explicitly state: "This proposal has not modified any file. If you'd like to adopt it, tell me which skill/template to edit and I will make that specific, isolated change in a normal edit + PR — following `engineering-discipline.mdc`'s surgical-scope rule, not a broader rewrite."
5. If the user asks you to adopt it: make the *smallest* edit that addresses the named recurring finding in the *one* file the proposal named. Do not batch in unrelated cleanup. This adoption edit is a normal, human-approved change — not something this skill applies on its own initiative.

## Constraints

- **Never** edit `.cursor/skills/`, `.specify/templates/`, `.specify/memory/constitution.md`, or `.cursor/rules/*.mdc` as part of running this skill (steps 1-4). Only step 5, and only with explicit user direction naming the target file, may touch those.
- **Never** invent a new scored axis, a new phase, or a new artifact format in response to a proposal — if a recurring finding's "fix" would require that, say so explicitly and let the user decide; do not auto-reject or auto-apply it either way.
- **Never** write to `docs/assessments/SDD_CONFIDENCE_LEARNING_LOG.md` from this skill — that file is written only by `/speckit-confidence`'s post-execution hook.

## Done When

- [ ] `--propose` run and its exact output (proposal or "nothing yet") reported to the user
- [ ] If a proposal exists, the no-auto-apply statement was given verbatim
- [ ] No file was modified by this skill unless the user explicitly directed a specific, named adoption edit
