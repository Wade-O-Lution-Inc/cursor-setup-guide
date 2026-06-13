# Spec-Driven Development (SDD)

Org adoption guide for GitHub [Spec Kit](https://github.com/github/spec-kit) in Wade-O-Lution repos.

**Start here (quick reference):** [sdd-user-guide.md](./sdd-user-guide.md)

**Live reference implementation:** [meeting_notes_workflow](https://github.com/Wade-O-Lution-Inc/meeting_notes_workflow) — `.specify/`, `specs/`, `docs/agents/SDD_USER_GUIDE.md`, `.cursor/skills/sdd-entry/`.

---

## What SDD is

SDD drives multi-step features through **git-tracked planning artifacts** on feature branches:

```
.specify/memory/constitution.md
specs/NNN-feature/
  spec.md → plan.md → tasks.md
```

Resume across sessions via `tasks.md` checkboxes, compact handoff, and optional auto-context Spec Progress.

## What SDD is not

| Not SDD | Where that lives |
|---------|------------------|
| Product runtime memory | App DB / Agent OS (repo-specific) |
| Durable product docs | `docs/` |
| One-line fixes | Normal IMPLEMENT / DEBUG |

`specs/` is **ephemeral planning** on feature branches — not platform memory.

---

## Bootstrap checklist

See [templates/spec-kit/init-checklist.md](./templates/spec-kit/init-checklist.md).

Summary:

1. `uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@v0.10.2`
2. `specify init . --integration cursor-agent --here --force --script sh`
3. Copy org workflow templates from `templates/spec-kit/sdd-*-workflow.yml` → `.specify/workflows/`
4. Compile constitution ([constitution-bootstrap-prompt.md](./templates/spec-kit/constitution-bootstrap-prompt.md))
5. Add glob-gated [specify-rules-override.mdc](./templates/spec-kit/specify-rules-override.mdc) → `.cursor/rules/specify-rules.mdc`
6. Merge [sdd-orchestrator-snippet.mdc](./templates/rules/sdd-orchestrator-snippet.mdc) into orchestrator rule
7. Copy [sdd-entry skill](./templates/skills/sdd-entry/SKILL.md) → `.cursor/skills/sdd-entry/`
8. Optional: apply [refresh-compact-context-sdd.patch](./templates/hooks/refresh-compact-context-sdd.patch) for Spec Progress in auto-context
9. Copy [sdd-user-guide.template.md](./templates/spec-kit/sdd-user-guide.template.md) → `docs/agents/SDD_USER_GUIDE.md` (fill `{LINT_CMD}`, `{TEST_CMD}`, `{SECRETS_PREFIX}`)

---

## Workflow IDs (`sdd-*`)

| ID | Purpose |
|----|---------|
| `speckit` | Upstream GitHub default |
| `sdd-full` | Org default full cycle with gates |
| `sdd-api` | API/service only |
| `sdd-rfc` | Plan only, no implement |
| `sdd-test-fix` | Implement → test → fix loop |
| `sdd-issues` | Spec → tasks → GitHub issues |

Templates: `templates/spec-kit/sdd-*-workflow.yml`

---

## Context budget

**Do not** add always-on SDD rules. Use glob-gated `specify-rules.mdc` (`alwaysApply: false`, globs: `specs/**`, `.specify/**`). SDD routing (~40 lines) lives in the orchestrator.

See meeting_notes `.cursor/CONTEXT_BUDGET.md` for before/after accounting.

---

## Scope: project vs global

| Asset | Scope |
|-------|-------|
| `.specify/`, `specs/`, SDD docs, `sdd-entry` skill | **Project** (committed) |
| `~/.specify/workflow-catalogs.yml` | Spec Kit **global** (optional) |
| Org templates | **cursor-setup-guide** (this repo) |

See [scope.md](./scope.md#spec-driven-development-sdd).

---

## Phase order (brownfield)

1. constitution (once)
2. specify → **clarify** → plan → tasks → **analyze** → implement

Quality gates: replace `{LINT_CMD}` and `{TEST_CMD}` in workflows and user guide.

---

## Related docs

- [sdd-user-guide.md](./sdd-user-guide.md) — portable quick reference
- [skills.md](./skills.md#spec-kit-managed-skills-vs-bridge-skills) — speckit-* vs sdd-entry
- [rules.md](./rules.md#glob-gated-sdd-rules) — specify-rules pattern
- [EXAMPLES.md](./EXAMPLES.md#11-spec-driven-development-sdd-full) — terminal run/resume example
