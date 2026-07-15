---
name: "speckit-confidence-improve"
description: "Cluster recurring SDD confidence-loop findings into a human-reviewed improvement proposal. Never edits any skill, template, or constitution file itself."
compatibility: "Requires spec-kit project structure with .specify/ directory; reads docs/assessments/SDD_CONFIDENCE_LEARNING_LOG.md"
metadata:
  author: "Wade-O-Lution"
  source: "org: speckit-confidence-improve (spec 021-sdd-confidence-governance)"
---

## Purpose

Close the recursive-improvement loop for the SDD confidence workflow **without** ever mutating the workflow itself automatically. This skill reads `docs/assessments/SDD_CONFIDENCE_LEARNING_LOG.md`, clusters findings, and drafts a proposal for a human to review and, if they agree, apply by hand in a normal PR.

## When to run this

- On demand, whenever an operator wants to check for recurring patterns.
- Optionally after `/speckit-confidence` via the `after_confidence` hook in `.specify/extensions.yml` (prompted, not automatic).

## Outline

1. **If your repo ships an eval helper** (reference: meeting_notes `scripts/eval_sdd_confidence.py`), run its propose mode, e.g. `uv run python -m scripts.eval_sdd_confidence --propose`. Otherwise, read `docs/assessments/SDD_CONFIDENCE_LEARNING_LOG.md` and manually cluster rows that share finding tags across ≥3 features.
2. If nothing has reached your recurrence threshold, report that and stop.
3. If a proposal exists, present it to the user verbatim. Do **not** paraphrase away tags, feature lists, or suggested-action wording.
4. Explicitly state: "This proposal has not modified any file. If you'd like to adopt it, tell me which skill/template to edit and I will make that specific, isolated change in a normal edit + PR."
5. If the user asks you to adopt it: make the *smallest* edit that addresses the named recurring finding in the *one* file the proposal named.

## Constraints

- **Never** edit `.cursor/skills/`, `.specify/templates/`, `.specify/memory/constitution.md`, or `.cursor/rules/*.mdc` as part of running this skill (steps 1–4). Only step 5, with explicit user direction, may touch those.
- **Never** invent a new scored axis, phase, or artifact format in response to a proposal.
- **Never** write to `docs/assessments/SDD_CONFIDENCE_LEARNING_LOG.md` from this skill — that file is written only by `/speckit-confidence`.

## Done When

- [ ] Propose run (script or manual cluster) and exact output reported
- [ ] If a proposal exists, the no-auto-apply statement was given verbatim
- [ ] No file modified unless the user explicitly directed a named adoption edit
