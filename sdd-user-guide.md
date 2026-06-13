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

---

## Start here

SDD turns multi-step features into **reviewable markdown artifacts** before code lands.

| Mode | How | When |
|------|-----|------|
| **A — Chat** | Talk to Cursor Agent; orchestrator routes to SDD | Daily default |
| **B — Workflow** | `specify workflow run sdd-full …` | Long runs with explicit gates |

---

## One-time setup

```bash
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@v0.10.2
specify init . --integration cursor-agent --here --force --script sh
specify integration status
specify workflow list
```

Copy org workflow YAMLs from [cursor-setup-guide/templates/spec-kit/](./templates/spec-kit/) into `.specify/workflows/` and register in `workflow-registry.json`.

---

## Which pipeline?

| Situation | Use |
|-----------|-----|
| New feature | **`sdd-full`** or chat SDD |
| API/service only | **`sdd-api`** |
| Architecture RFC | **`sdd-rfc`** |
| Tests failing — finish branch | **`sdd-test-fix`** |
| Break into GitHub issues | **`sdd-issues`** |
| One-line fix | Normal chat — **not SDD** |

---

## Chat cheat sheet

```
Spec this feature: <what and why — no tech stack yet>
Continue SDD on branch <NNN-feature-name>; next phase from tasks.md
I've reviewed spec.md — proceed to plan
compact
```

---

## Terminal cheat sheet

```bash
specify workflow run sdd-full -i spec="..." -i integration=cursor-agent
specify workflow status
specify workflow resume <run_id>
{LINT_CMD}
{TEST_CMD}
```

---

## Deep reference

After copying the template into your repo, add `docs/agents/SPEC_DRIVEN_DEVELOPMENT.md` (see meeting_notes reference) and link from your docs index.

Org architecture: [spec-driven-development.md](./spec-driven-development.md)
