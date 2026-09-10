# Quick start (daily SDD)

**Pocket card** while running SDD. Working in meeting_notes? Prefer that repo’s [`SDD_USER_GUIDE.md`](https://github.com/Wade-O-Lution-Inc/meeting_notes_workflow/blob/staging/docs/agents/SDD_USER_GUIDE.md).

Passing phases **auto-continue**. Failures repair up to cap, then **stop**. After confidence: expect `sdd-ctl report`.

Phase order (SSOT): [phase-model.md](./phase-model.md) — includes **converge** before confidence.

Machine once: [../day1.md](../day1.md) (optional Spec Kit section) · New repo: [bootstrap.md](./bootstrap.md).

---

## Chat

```
Start SDD: <what and why — no tech stack yet>
Start SDD: <what and why>. Use balanced.
Start SDD Lite: <contained what and why>
Start SDD Review
Continue SDD
Continue SDD using frontier.
Show SDD profile.
I've reviewed spec.md — proceed to plan
Revise spec: <feedback>
compact
Stop SDD; switch to normal fix mode for <narrow bug>
```

Natural-language flags: `scope=api`, `stop at plan`, `emit issues`, `remote after tasks`, `test-fix mode`, `lite`, `Use lean|balanced|frontier`.  
Choose a **profile**, not model IDs — [orchestrator.md](./orchestrator.md). Full defaults to **balanced**; Lite and Review default to **lean** when unset.

Flow: `sdd-entry` → `sdd-orchestrator` (`auto_chain`) → `speckit-*` worker.

Expect two inject-only agent messages on Start/Continue: `MANDATORY SKILL ROUTING` then `MANDATORY SDD PREFLIGHT` (machine hooks — [../hooks.md](../hooks.md)).

On swarm phases (analyze / confidence), experts must dispatch **concurrently** in one message; recorded verdicts need `attempt_kind`, second-precision `wall_s`, and swarm `dispatch_mode` — [orchestrator.md](./orchestrator.md).

---

## Three CLI recipes

```bash
# Status
specify workflow list          # expect sdd + sdd-remote

# Full local cycle
specify workflow run sdd -i spec="..." -i integration=cursor-agent \
  -i model_profile=balanced

# Lite (specify → plan → implement → light_gate; lean when model_profile unset)
specify workflow run sdd -i spec="..." -i integration=cursor-agent \
  -i mode=lite

# Stop early (RFC-style)
specify workflow run sdd -i spec="..." -i stop_at=plan

# Laptop → Mac mini
specify workflow run sdd-remote -i spec="..." -i remote_phase=implement -i interval=600
```

Headless Continue: [orchestrator.md](./orchestrator.md). Laptop → mini: [remote-handoff.md](./remote-handoff.md).

Upstream workflow **`speckit`**: installed, not for daily use. Deprecated aliases: [deprecated-aliases.md](../../templates/spec-kit/deprecated-aliases.md).

---

## Workflow control-flow (essentials)

Definitions live in `.specify/workflows/<id>/workflow.yml`. Org templates: [sdd-workflow.yml](../../templates/spec-kit/sdd-workflow.yml), [sdd-remote-workflow.yml](../../templates/spec-kit/sdd-remote-workflow.yml).

### `sdd` (local)

Each named phase invokes the orchestrator in **`single_phase`** mode; this workflow owns sequencing and `stop_at`. Exhausted repair caps stop the run.

**Full path (`mode=full`):** specify → clarify → plan → (optional `stop_at=plan`) → tasks → analyze → (optional `issues=true` / `stop_at=tasks`) → implement → converge → confidence → `sdd-ctl report`.

**Lite (`mode=lite`):** specify → plan → implement → light_gate → report. Chat: **Start SDD Lite**. Unset `model_profile` resolves **lean**.

**Test-fix (`mode=test-fix`):** implement → test retry → confidence → report.

Pytest wrappers in the org template use `python3 -m pytest tests -q` (no Doppler). Product repos inject secrets with their own tool when tests need them.

### `sdd-remote`

| Branch | Behavior |
|--------|----------|
| `transfer_only=false` | Laptop through tasks, then handoff to Mac mini |
| `transfer_only=true` | Skip laptop phases; handoff only |

Inputs: `remote_phase`, `interval`, `model`, `scope`, optional `spec`. Details: [remote-handoff.md](./remote-handoff.md).

### Gates vs resume

| Gate | Resume |
|------|--------|
| Spec Kit `type: gate` in YAML | `specify workflow resume <run_id>` |
| Orchestrator pass (`automatic`) | Continues |
| Orchestrator fail at repair cap | Human fix + Continue / re-run |
| `gate_mode: interactive` | Human Continue after pause |

Run state (gitignored): `.specify/workflows/runs/`, `.specify/orchestrator-runs/`.
