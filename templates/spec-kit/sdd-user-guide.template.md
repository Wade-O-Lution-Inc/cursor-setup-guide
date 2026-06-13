# SDD User Guide

**Keep this file open** while learning Spec-Driven Development (SDD) in {REPO_NAME}.

Deep reference: [SPEC_DRIVEN_DEVELOPMENT.md](./SPEC_DRIVEN_DEVELOPMENT.md)

---

## Start here

SDD turns multi-step features into **reviewable markdown artifacts** (`spec.md` → `plan.md` → `tasks.md`) before code lands. Use it for features spanning multiple sessions — not for one-line fixes.

**Two modes:**

| Mode | How | When |
|------|-----|------|
| **A — Chat** | Talk to Cursor Agent; orchestrator routes to SDD | Daily default |
| **B — Workflow** | `specify workflow run sdd-full …` in terminal | Long runs with explicit gates |

---

## One-time setup

1. Install CLI (once per machine):

   ```bash
   uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@v0.10.2
   specify version
   ```

2. Repo already initialized if `.specify/` and `.cursor/skills/speckit-*` exist. Otherwise:

   ```bash
   specify init . --integration cursor-agent --here --force --script sh
   ```

3. Verify:

   ```bash
   specify integration status
   specify workflow list
   ```

   Expect: `speckit`, `sdd-full`, `sdd-api`, `sdd-rfc`, `sdd-test-fix`, `sdd-issues`.

4. Constitution lives at `.specify/memory/constitution.md` (compiled from `.cursor/rules/`). Refresh when governance rules change materially.

---

## Which pipeline?

| Situation | Use |
|-----------|-----|
| New feature (full stack or mixed) | **`sdd-full`** or chat SDD |
| API + worker only, no frontend | **`sdd-api`** |
| Architecture RFC, no code yet | **`sdd-rfc`** |
| Have `tasks.md`, tests failing — finish branch | **`sdd-test-fix`** |
| Break tasks into GitHub issues | **`sdd-issues`** |
| One-line fix, typo, ops task | Normal chat (DEBUG / OPS) — **not SDD** |

---

## Chat cheat sheet

Copy-paste into Cursor Agent:

```
Spec this feature: <what and why in plain English — no tech stack yet>
```

```
Continue SDD on branch <NNN-feature-name>; next phase from tasks.md
```

```
I've reviewed spec.md — proceed to plan
```

```
Revise spec: <your feedback>
```

```
compact
```

```
create handoff
```

```
Stop SDD; switch to normal fix mode for <narrow bug>
```

---

## Terminal cheat sheet

```bash
# Full cycle (default)
specify workflow run sdd-full \
  -i spec="Your feature description" \
  -i integration=cursor-agent

# Variants
specify workflow run sdd-api -i spec="..."
specify workflow run sdd-rfc -i spec="..."
specify workflow run sdd-test-fix -i spec="Continue from tasks.md"
specify workflow run sdd-issues -i spec="..."

# While paused at a gate
specify workflow status
specify workflow resume <run_id>

# Quality gates (manual)
{LINT_CMD}
{TEST_CMD}
```

---

## First feature walkthrough

### Session 1 — Spec (~15–30 min)

| You | Agent / system |
|-----|----------------|
| Type: `Spec this feature: …` | Creates branch `NNN-name`, `specs/NNN-name/spec.md` |
| Read **spec.md** in editor | Runs clarify; updates spec |
| Answer clarification questions | Updates spec |
| Say `compact` if context is heavy | Handoff includes spec path |

**Do not** pick tech stack yet. **Do not** write code yet.

### Session 2 — Plan (~20–40 min)

| You | Agent / system |
|-----|----------------|
| `Continue SDD on branch NNN-name. Plan with …` | Writes plan.md, research.md, tasks.md |
| Read **plan.md** — catch over-engineering | Runs analyze |
| Approve: `proceed to implement` or run workflow resume at gate | — |

### Session 3+ — Implement (hours, chunked)

| You | Agent / system |
|-----|----------------|
| `Implement next phase from tasks.md` | Marks tasks `[X]`, writes code |
| Review diffs | Runs ruff + pytest at checkpoints |
| `compact` overnight | Handoff + `.cursor/auto-context.md` shows task progress |

### PR

- Branch `NNN-*` → PR to **staging** with spec/plan/tasks in repo.

---

## Files to watch

| Phase | Files updated |
|-------|----------------|
| Specify | `specs/NNN-*/spec.md` |
| Plan | `plan.md`, `research.md`, `data-model.md`, `contracts/` |
| Tasks | `tasks.md` |
| Implement | App code + `[X]` in `tasks.md` |
| Always | `.cursor/auto-context.md` (Spec Progress section on SDD branches) |

---

## Stuck?

| Problem | Fix |
|---------|-----|
| Wrong branch | `git checkout NNN-feature-name` |
| Skipped clarify | Run clarify before plan |
| Workflow paused | `specify workflow status` → `specify workflow resume <run_id>` |
| Tests fail after implement | `specify workflow run sdd-test-fix` or fix in chat |
| Context full | `compact` → new chat with handoff |
| Agent implements too early | Point to `tasks.md`; use orchestrator SDD guards |

---

## Do not

- Use SDD for hotfixes (`fix/` branches, single-file changes)
- Treat `specs/` as product docs or Agent OS memory
- Skip clarify on multi-boundary features
- Implement before `tasks.md` exists (unless explicit spike)
- Merge to staging without pytest + ruff green

---


---

## Guide feedback

_(Fill after first real SDD feature in {REPO_NAME}.)_

