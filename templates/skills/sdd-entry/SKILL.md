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

**Read first:** `docs/agents/SDD_USER_GUIDE.md`.

Every phase transition goes through **`sdd-orchestrator`** (worker → D-hooks →
judge → gate). Bare `speckit-*` skills are the **worker procedure** the
orchestrator invokes — not a separate front door.

## Chat — two verbs

| Intent | What you do |
|--------|-------------|
| **Start SDD: \<what/why\>** | New feature. Resolve/create `specs/NNN-*`, then orchestrate **specify**. |
| **Continue SDD** | Resume current branch / feature dir; orchestrate the next ungated phase. |

Aliases: `Spec this feature: …`, `Continue SDD on branch …`.

Optional NL flags: `scope=api`, `stop at plan`, `emit issues`, `remote after tasks`, `test-fix mode`.

## Procedure (every chat turn)

1. Confirm `.specify/` exists (`specify integration status` if unsure).
2. Resolve **FEATURE_DIR** (absolute path to `specs/NNN-*`).
3. Resolve next **PHASE** (specify → clarify → plan → tasks → analyze → implement → confidence). Do not skip clarify before plan; do not implement without `tasks.md`.
4. **Must** read and follow `~/.cursor/skills/sdd-orchestrator/SKILL.md` for that PHASE. Do **not** call `speckit-*` as the top-level skill.
5. After a hard gate pass, stop and report to the human before the next phase unless they already approved Continue.

Headless twin of Continue: `~/.cursor/sdd-orchestrator-ctl/bin/sdd-run`.

## CLI — two workflows

```bash
specify workflow run sdd -i spec="..." -i integration=cursor-agent \
  -i scope=full|api-only|frontend-only \
  -i stop_at=confidence|tasks|plan -i issues=false -i mode=full|test-fix

specify workflow run sdd-remote -i spec="..." -i remote_phase=implement -i interval=600
# transfer only: -i transfer_only=true
```

Deprecated aliases (still run): `sdd-full`, `sdd-api`, `sdd-rfc`, `sdd-test-fix`, `sdd-issues`, `sdd-full-remote`, `sdd-remote-handoff`.

## Handoff

On compact/checkpoint: include `specs/.../tasks.md` progress.

Deep reference: `docs/agents/SPEC_DRIVEN_DEVELOPMENT.md`

Org templates: [cursor-setup-guide](https://github.com/Wade-O-Lution-Inc/cursor-setup-guide)
