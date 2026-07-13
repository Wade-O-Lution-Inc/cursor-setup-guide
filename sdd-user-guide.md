# SDD User Guide (Portable Template)

**Keep this file open** while learning Spec-Driven Development in a Wade-O-Lution repo.

Copy [templates/spec-kit/sdd-user-guide.template.md](./templates/spec-kit/sdd-user-guide.template.md) into your repo as `docs/agents/SDD_USER_GUIDE.md` and replace placeholders:

| Placeholder | Example (meeting_notes_workflow) |
|-------------|----------------------------------|
| `{LINT_CMD}` | `uv run ruff check` |
| `{TEST_CMD}` | `doppler run -- uv run python -m pytest tests/ -x -q` |
| `{SECRETS_PREFIX}` | `doppler run --` |
| `{REPO_NAME}` | `meeting_notes_workflow` |

**Reference implementation:** [meeting_notes_workflow/docs/agents/SDD_USER_GUIDE.md](https://github.com/Wade-O-Lution-Inc/meeting_notes_workflow/blob/staging/docs/agents/SDD_USER_GUIDE.md)

**Global harness:** [global-env.md](./global-env.md) — `sdd-orchestrator` + `sdd-orchestrator-ctl`.

---

## Kickoff (one screen)

SDD turns multi-step features into reviewable markdown (`spec.md` → `plan.md` → `tasks.md`) before code. Skip it for one-line fixes.

| Surface | Verb / ID | What it does |
|---------|-----------|--------------|
| **Chat** | `Start SDD: <what/why>` | New feature → `sdd-entry` → orchestrator **specify** |
| **Chat** | `Continue SDD` | Resume feature dir → next ungated phase via orchestrator |
| **CLI** | `specify workflow run sdd …` | Local gated cycle (flags below) |
| **CLI** | `specify workflow run sdd-remote …` | Laptop through tasks, then Mac mini implement/confidence |

Every phase is **orchestrator-gated** (worker → deterministic hooks → judge → `phase-exits.md`). Bare `speckit-*` is the worker procedure only. Cost envelope: `~/.cursor/sdd-orchestrator-ctl/README.md`. Headless Continue twin: `~/.cursor/sdd-orchestrator-ctl/bin/sdd-run`.

### Flags (CLI `sdd` / chat NL)

| Flag | Values | Meaning |
|------|--------|---------|
| `scope` | `full` \| `api-only` \| `frontend-only` | What layers the plan/tasks may touch |
| `stop_at` | `confidence` \| `tasks` \| `plan` | Early exit (RFC ≈ `plan` or `tasks`) |
| `issues` | `true` \| `false` | After tasks, emit GitHub issues and stop |
| `mode` | `full` \| `test-fix` | `test-fix` = implement + pytest retry + confidence |
| `transfer_only` | on `sdd-remote` | Skip laptop phases; handoff only |

```bash
specify workflow run sdd -i spec="..." -i integration=cursor-agent \
  -i scope=full -i stop_at=confidence -i issues=false -i mode=full

specify workflow run sdd-remote -i spec="..." -i remote_phase=implement -i interval=600
```

**Deprecated aliases** (still run one release): `sdd-full` → `sdd`; `sdd-api` → `scope=api-only`; `sdd-rfc` → `stop_at=tasks`; `sdd-test-fix` → `mode=test-fix`; `sdd-issues` → `issues=true` + `stop_at=tasks`; `sdd-full-remote` / `sdd-remote-handoff` → `sdd-remote`. Upstream `speckit` stays installed but undocumented.

---

## One-time setup

```bash
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@v0.10.2
specify init . --integration cursor-agent --here --force --script sh
specify integration status
specify workflow list   # expect sdd + sdd-remote
```

Copy org workflows from [templates/spec-kit/](./templates/spec-kit/) (`sdd-workflow.yml`, `sdd-remote-workflow.yml`). See [init-checklist.md](./templates/spec-kit/init-checklist.md).

---

## Chat cheat sheet

```
Start SDD: <what and why — no tech stack yet>
Continue SDD
I've reviewed spec.md — proceed to plan
compact
```

Optional NL flags: `scope=api`, `stop at plan`, `emit issues`, `remote after tasks`, `test-fix mode`.

---

## Terminal cheat sheet

```bash
specify workflow run sdd -i spec="..." -i integration=cursor-agent
specify workflow run sdd -i spec="..." -i stop_at=plan
specify workflow run sdd-remote -i spec="..." -i remote_phase=implement -i interval=600
specify workflow status
specify workflow resume <run_id>
{LINT_CMD}
{TEST_CMD}
```

---

## Deep reference

After copying the template into your repo, add `docs/agents/SPEC_DRIVEN_DEVELOPMENT.md` (see meeting_notes reference) and link from your docs index.

Org architecture: [spec-driven-development.md](./spec-driven-development.md)
