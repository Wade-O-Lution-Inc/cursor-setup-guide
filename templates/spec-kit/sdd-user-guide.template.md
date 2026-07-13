# SDD User Guide

**Keep this file open** while learning Spec-Driven Development (SDD) in this repo.

Deep reference: [SPEC_DRIVEN_DEVELOPMENT.md](./SPEC_DRIVEN_DEVELOPMENT.md)

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

**Deprecated aliases** (still run one release): `sdd-full` → `sdd`; `sdd-api` → `scope=api-only`; `sdd-rfc` → `stop_at=tasks`; `sdd-test-fix` → `mode=test-fix`; `sdd-issues` → `issues=true` + `stop_at=tasks`; `sdd-full-remote` / `sdd-remote-handoff` → `sdd-remote`.

---

## One-time setup

```bash
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@v0.10.2
specify integration status
specify workflow list   # expect sdd + sdd-remote
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
```

---

## Do not

- Use SDD for hotfixes / single-file changes
- Call bare `speckit-*` as the chat front door (use `sdd-entry` → orchestrator)
- Implement before `tasks.md`
- Merge without `{LINT_CMD}` + `{TEST_CMD}` green

Repo: `{REPO_NAME}`. Secrets prefix: `{SECRETS_PREFIX}`.
