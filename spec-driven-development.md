# Spec-Driven Development (SDD)

Org adoption guide for GitHub [Spec Kit](https://github.com/github/spec-kit) in Wade-O-Lution repos.

**Start here (quick reference):** [sdd-user-guide.md](./sdd-user-guide.md)

**Live reference implementation:** [meeting_notes_workflow](https://github.com/Wade-O-Lution-Inc/meeting_notes_workflow) — `.specify/`, `specs/`, `docs/agents/SDD_USER_GUIDE.md`, `.cursor/skills/sdd-entry/`.

**Global always-on orchestrator:** [global-env.md](./global-env.md) — `~/.cursor/skills/sdd-orchestrator/` + `~/.cursor/sdd-orchestrator-ctl/`.

---

## What SDD is

SDD drives multi-step features through **git-tracked planning artifacts** on feature branches:

```
.specify/memory/constitution.md
specs/NNN-feature/
  spec.md → plan.md → tasks.md → confidence.md
  phase-exits.md   # orchestrator-owned append-only gate log
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

## Entry model (locked)

```
Start / Continue SDD  →  chat: sdd-entry  →  sdd-orchestrator (per phase)
CLI local             →  specify workflow run sdd …
CLI close laptop      →  specify workflow run sdd-remote …
Headless Continue     →  ~/.cursor/sdd-orchestrator-ctl/bin/sdd-run
```

- **Do not** invoke bare `speckit-*` as the chat front door — those skills are the **worker procedure** inside the orchestrator.
- Every phase: worker Task → deterministic hooks → judge → validate → `phase-exits.md` + JSONL → hard/soft gate.

---

## Bootstrap checklist

See [templates/spec-kit/init-checklist.md](./templates/spec-kit/init-checklist.md).

Summary:

1. `uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@v0.10.2`
2. `specify init . --integration cursor-agent --here --force --script sh`
3. Copy `templates/spec-kit/sdd-workflow.yml` → `.specify/workflows/sdd/workflow.yml`
4. Copy `templates/spec-kit/sdd-remote-workflow.yml` → `.specify/workflows/sdd-remote/workflow.yml` (optional if you use Mac mini handoff)
5. Replace `{LINT_CMD}` / `{TEST_CMD}`; refresh `workflow-registry.json`
6. Compile constitution ([constitution-bootstrap-prompt.md](./templates/spec-kit/constitution-bootstrap-prompt.md))
7. Add glob-gated [specify-rules-override.mdc](./templates/spec-kit/specify-rules-override.mdc) → `.cursor/rules/specify-rules.mdc`
8. Merge [sdd-orchestrator-snippet.mdc](./templates/rules/sdd-orchestrator-snippet.mdc) into orchestrator rule
9. Copy [sdd-entry skill](./templates/skills/sdd-entry/SKILL.md) → `.cursor/skills/sdd-entry/`
10. Ensure global `sdd-orchestrator` + `sdd-orchestrator-ctl` exist on the machine ([global-env.md](./global-env.md))
11. Copy [sdd-user-guide.template.md](./templates/spec-kit/sdd-user-guide.template.md) → `docs/agents/SDD_USER_GUIDE.md`

---

## Workflow IDs

| ID | Purpose |
|----|---------|
| **`sdd`** | Canonical local cycle — flags: `scope`, `stop_at`, `issues`, `mode` |
| **`sdd-remote`** | Laptop through tasks, then Mac mini implement/confidence (`transfer_only`) |
| `speckit` | Upstream bundled (leave installed; undocumented) |
| Deprecated aliases | `sdd-full`, `sdd-api`, `sdd-rfc`, `sdd-test-fix`, `sdd-issues`, `sdd-full-remote`, `sdd-remote-handoff` |

Templates: `templates/spec-kit/sdd-workflow.yml`, `sdd-remote-workflow.yml`. Older `sdd-*-workflow.yml` files remain as historical aliases — prefer the two canonical IDs.

---

## Context budget

**Do not** add always-on SDD rules. Use glob-gated `specify-rules.mdc` (`alwaysApply: false`, globs: `specs/**`, `.specify/**`). SDD routing lives in the orchestrator + `sdd-entry`.

---

## Scope: project vs global

| Asset | Scope |
|-------|-------|
| `.specify/`, `specs/`, SDD docs, `sdd-entry`, `sdd` / `sdd-remote` workflows | **Project** (committed) |
| `sdd-orchestrator` skill + `sdd-orchestrator-ctl` | **Global** (`~/.cursor/`) |
| Global `speckit-*` stubs | **Global** pointers → project/canonical copies |
| Org templates | **cursor-setup-guide** (this repo) |

See [scope.md](./scope.md#spec-driven-development-sdd) and [global-env.md](./global-env.md).

---

## Phase order (brownfield)

1. constitution (once)
2. specify → **clarify** → plan → tasks → **analyze** → implement → **confidence**

Quality gates: replace `{LINT_CMD}` and `{TEST_CMD}` in workflows and user guide.

---

## Related docs

- [sdd-user-guide.md](./sdd-user-guide.md) — portable quick reference
- [global-env.md](./global-env.md) — machine harness
- [skills.md](./skills.md#spec-kit-managed-skills-vs-bridge-skills) — speckit-* vs sdd-entry vs orchestrator
- [rules.md](./rules.md#glob-gated-sdd-rules) — specify-rules pattern
- [EXAMPLES.md](./EXAMPLES.md#11-spec-driven-development-sdd) — terminal run/resume example
