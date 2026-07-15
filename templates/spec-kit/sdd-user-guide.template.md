# SDD User Guide

**Keep this file open** while learning Spec-Driven Development (SDD) in this repo.

Deep reference: [SPEC_DRIVEN_DEVELOPMENT.md](./SPEC_DRIVEN_DEVELOPMENT.md) (or org hub [cursor-setup-guide/specify/](https://github.com/Wade-O-Lution-Inc/cursor-setup-guide/tree/main/specify))

---

## Kickoff (one screen)

SDD turns multi-step features into reviewable markdown (`spec.md` → `plan.md` → `tasks.md`) before code. Skip it for one-line fixes.

| Surface | Verb / ID | What it does |
|---------|-----------|--------------|
| **Chat** | `Start SDD: <what/why>` | New feature → `sdd-entry` → orchestrator **specify** |
| **Chat** | `Continue SDD` | Resume feature dir → next ungated phase via orchestrator |
| **CLI** | `specify workflow run sdd …` | Local gated cycle (flags below) |
| **CLI** | `specify workflow run sdd-remote …` | Laptop through tasks, then remote implement/confidence |

Every phase is **orchestrator-gated** (worker → deterministic hooks → judge → `phase-exits.md`). Bare `speckit-*` is the worker procedure only. Cost envelope: `~/.cursor/sdd-orchestrator-ctl/README.md`. Headless Continue twin: `~/.cursor/sdd-orchestrator-ctl/bin/sdd-run`.

### Flags (CLI `sdd` / chat NL)

| Flag | Values | Meaning |
|------|--------|---------|
| `scope` | `full` \| `api-only` \| `frontend-only` | What layers the plan/tasks may touch |
| `stop_at` | `confidence` \| `tasks` \| `plan` | Early exit (RFC ≈ `plan` or `tasks`) |
| `issues` | `true` \| `false` | After tasks, emit GitHub issues and stop |
| `mode` | `full` \| `test-fix` | `test-fix` = implement + test retry + confidence |
| `transfer_only` | on `sdd-remote` | Skip laptop phases; handoff only |

```bash
specify workflow run sdd -i spec="..." -i integration=cursor-agent \
  -i scope=full -i stop_at=confidence -i issues=false -i mode=full

specify workflow run sdd-remote -i spec="..." -i remote_phase=implement -i interval=600
```

**Deprecated aliases** (still run one release): `sdd-full` → `sdd`; `sdd-api` → `scope=api-only`; `sdd-rfc` → `stop_at=tasks`; `sdd-test-fix` → `mode=test-fix`; `sdd-issues` → `issues=true` + `stop_at=tasks`; `sdd-full-remote` / `sdd-remote-handoff` → `sdd-remote` (+ `transfer_only=true`). Upstream `speckit` workflow stays installed but undocumented for daily use.

---

## One-time setup

```bash
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@v0.10.2
specify integration status
specify workflow list   # expect sdd + sdd-remote (plus deprecated aliases)
```

Constitution: `.specify/memory/constitution.md`.

---

## Chat cheat sheet

```
Start SDD: <what and why — no tech stack yet>
Continue SDD
I've reviewed spec.md — proceed to plan
Revise spec: <feedback>
compact
Stop SDD; switch to normal fix mode for <narrow bug>
```

Optional: `scope=api`, `stop at plan`, `emit issues`, `remote after tasks`, `test-fix mode`.

---

## Terminal cheat sheet

```bash
specify workflow run sdd -i spec="..." -i integration=cursor-agent
specify workflow run sdd -i spec="..." -i stop_at=plan
specify workflow run sdd -i spec="..." -i mode=test-fix
specify workflow run sdd -i spec="..." -i issues=true -i stop_at=tasks

specify workflow status
specify workflow resume <run_id>

{LINT_CMD}
{TEST_CMD}

specify workflow run sdd-remote -i spec="..." -i remote_phase=implement -i interval=600
specify workflow run sdd-remote -i transfer_only=true -i remote_phase=confidence -i interval=600
```

---

## Long runs / close laptop (optional)

If your repo supports remote agent handoff (e.g. Mac mini), use `sdd-remote` through **review-tasks**, approve the transfer gate, then let implement + confidence run remotely. Check handoff status with your repo's handoff scripts; on resume, `git pull` and read `.cursor/session-handoff.md` if present.

---

## Phase walkthrough

1. **Specify** — branch `NNN-*`, `spec.md`. No stack, no code.
2. **Clarify** — before plan on multi-boundary work.
3. **Plan / tasks / analyze** — `plan.md`, `tasks.md`, consistency check. Honor `stop_at`.
4. **Implement** — only with `tasks.md`; mark `[X]`; lint + test.
5. **Confidence** — scores 1–5 (complexity inverted); loops ≤3; writes `confidence.md`.

Every phase appends one line to `specs/NNN-*/phase-exits.md` (orchestrator owns that file).

| Phase | Watch |
|-------|--------|
| Specify | `spec.md` |
| Plan | `plan.md`, `research.md`, `confidence-checks.md` |
| Tasks | `tasks.md` |
| Implement | app code + `[X]` |
| Confidence | `confidence.md` |
| Every phase | `phase-exits.md` |
| Always | `.cursor/auto-context.md` Spec Progress (if SDD hook patch applied) |

---

## Stuck?

| Problem | Fix |
|---------|-----|
| Wrong branch | `git checkout NNN-feature-name` |
| Skipped clarify | Continue SDD → clarify before plan |
| Workflow paused | `specify workflow resume <run_id>` |
| Tests fail | `sdd -i mode=test-fix` or fix in chat |
| Context full | `compact` |
| Closing laptop | `sdd-remote` (if configured) |

## Do not

- SDD for hotfixes / single-file changes
- Treat `specs/` as product docs
- Skip clarify on multi-boundary features
- Implement before `tasks.md`
- Call bare `speckit-*` as the chat front door (use `sdd-entry` → orchestrator)
- Merge without `{LINT_CMD}` + `{TEST_CMD}` green

**Reference implementation:** [meeting_notes_workflow](https://github.com/Wade-O-Lution-Inc/meeting_notes_workflow). Replace `{LINT_CMD}`, `{TEST_CMD}`, and repo-specific handoff paths after copy.
