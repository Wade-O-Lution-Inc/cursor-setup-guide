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

## Chat — two verbs

| Intent | What you do |
|--------|-------------|
| **Start SDD: \<what/why\>** | New feature. Resolve/create `specs/NNN-*`, then orchestrate **specify**. |
| **Continue SDD** | Resume current branch / feature dir; orchestrate the next ungated phase. |

Aliases that mean the same: `Spec this feature: …`, `Continue SDD on branch …`.

Optional natural-language flags: `scope=api`, `stop at plan`, `emit issues`,
`remote after tasks`, `test-fix mode`, `Use lean|balanced|frontier`.

Profile helpers:

```text
Start SDD: <what/why>. Use balanced.
Continue SDD using frontier.
Show SDD profile.
Explain current SDD routing.
```

Profiles are the normal cost/reliability choice (`lean` / `balanced` /
`frontier`). Reject raw model-name overrides in chat; recommend a profile.
Repo default lives in `.specify/orchestrator.json` → `model_profile`
(currently `balanced`, the evaluated ctl default). Mid-feature profile switches
require explicit confirmation and are runlogged via the feature pin.

## Procedure (every chat turn)

1. Confirm `.specify/` exists (`specify integration status` if unsure).
2. Resolve **FEATURE_DIR** (absolute path to `specs/NNN-*`):
   - On branch `NNN-*` or with an existing feature dir → use it.
   - Start SDD with no dir yet → FEATURE_DIR is created by the specify worker.
3. Resolve next **PHASE** (one of: specify → clarify → plan → tasks → analyze →
   implement → **converge** → confidence). Do not skip clarify before plan; do
   not implement without `tasks.md`. Honor stop flags (`stop at plan` /
   `stop at tasks`).
4. Ensure the global ctl is on clean `origin/main` (orchestrator skill runs
   `sdd-ctl sync` + `preflight`; `plan-phase` fails closed on drift).
5. **Must** read and follow `~/.cursor/skills/sdd-orchestrator/SKILL.md` for
   that PHASE (FEATURE_DIR + PHASE) in `auto_chain` mode. Preserve the original
   Start SDD what/why as `--feature-description` for specify. Do **not** call
   `speckit-*` as the top-level skill.
6. Passing phases auto-continue. Stop only when `sdd-ctl` returns `stop`
   (repair cap exhausted), the requested `stop_at` boundary is reached, or the
   repository opts into `gate_mode: interactive`.

`persona_comms` (if present in `.specify/orchestrator.json`) is independent of
`model_profile` — same channel caps under lean / balanced / frontier.

Headless twin of Continue: `~/.cursor/sdd-orchestrator-ctl/bin/sdd-run`
(see `~/.cursor/sdd-orchestrator-ctl/README.md` and
`docs/ADOPTION.md` in that repo for multi-repo enablement).

## CLI — two workflows

```bash
specify workflow run sdd -i spec="..." -i integration=cursor-agent \
  -i scope=full|api-only|frontend-only \
  -i stop_at=confidence|tasks|plan -i issues=false -i mode=full|test-fix \
  -i model_profile=balanced

specify workflow run sdd-remote -i spec="..." -i remote_phase=implement \
  -i interval=600 -i model_profile=lean
# transfer only: -i transfer_only=true
```

Only `sdd`, `sdd-remote`, and the upstream `speckit` workflow are registered.

## Brownfield

Before specify: closest pattern in `project.mdc` → *Finding the Right Pattern*.

## Handoff

On compact/checkpoint: include `specs/.../tasks.md` progress. Read
`.cursor/auto-context.md` Spec Progress on resume.

Deep reference: [docs/agents/SPEC_DRIVEN_DEVELOPMENT.md](../../docs/agents/SPEC_DRIVEN_DEVELOPMENT.md)
