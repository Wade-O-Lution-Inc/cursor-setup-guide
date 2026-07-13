# Templates

Copy sources for adopting the Wade-O-Lution Cursor harness. Prefer reading **[../specify/](../specify/)** first so you know *why* each file exists.

## Spec Kit (`spec-kit/`)

| File | Purpose |
|------|---------|
| [sdd-workflow.yml](./spec-kit/sdd-workflow.yml) | Canonical local workflow → `.specify/workflows/sdd/workflow.yml` |
| [sdd-remote-workflow.yml](./spec-kit/sdd-remote-workflow.yml) | Laptop + Mac mini → `.specify/workflows/sdd-remote/workflow.yml` |
| [sdd-*-workflow.yml](./spec-kit/) (other names) | **Deprecated stubs** — use `sdd` flags instead |
| [init-checklist.md](./spec-kit/init-checklist.md) | Bootstrap steps (also [../specify/bootstrap.md](../specify/bootstrap.md)) |
| [sdd-user-guide.template.md](./spec-kit/sdd-user-guide.template.md) | Repo `docs/agents/SDD_USER_GUIDE.md` |
| [constitution-bootstrap-prompt.md](./spec-kit/constitution-bootstrap-prompt.md) | Compile constitution from rules |
| [specify-rules-override.mdc](./spec-kit/specify-rules-override.mdc) | Glob-gated SDD rule |

Replace `{LINT_CMD}` / `{TEST_CMD}` after copy.

## Skills & rules

| Path | Purpose |
|------|---------|
| [skills/sdd-entry/](./skills/sdd-entry/) | Chat front door (Start/Continue SDD) |
| [rules/sdd-orchestrator-snippet.mdc](./rules/sdd-orchestrator-snippet.mdc) | Merge into repo orchestrator |
| Core `*.mdc` in this folder | Project rules starters (environment, git, testing, …) |

## Global machine (`global/`)

| Path | Purpose |
|------|---------|
| [global/hooks.json](./global/hooks.json) + [hooks/](./global/hooks/) | Skill router `beforeSubmitPrompt` |
| [global/rules/](./global/rules/) | Always-on cross-repo safety rules |

See [../global-env.md](../global-env.md) and [../specify/orchestrator.md](../specify/orchestrator.md) for `sdd-orchestrator-ctl` (not fully vendored — copy from a known-good machine).

## Hooks (project security)

[hooks/](./hooks/) — detect-secrets, block-no-verify, block-sensitive-reads, refresh-compact-context (+ SDD patch).
