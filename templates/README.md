# Templates

Copy sources for adopting the Wade-O-Lution Cursor harness. Prefer reading **[../specify/](../specify/)** first so you know *why* each file exists.

**Live reference:** [meeting_notes_workflow](https://github.com/Wade-O-Lution-Inc/meeting_notes_workflow) (`.specify/`, `.cursor/skills/`, `docs/agents/`).

## Spec Kit (`spec-kit/`)

| File | Purpose |
|------|---------|
| [sdd-workflow.yml](./spec-kit/sdd-workflow.yml) | Canonical local workflow → `.specify/workflows/sdd/workflow.yml` |
| [sdd-remote-workflow.yml](./spec-kit/sdd-remote-workflow.yml) | Laptop + remote handoff → `.specify/workflows/sdd-remote/workflow.yml` |
| [workflow-registry.template.json](./spec-kit/workflow-registry.template.json) | Registry with `sdd`, `sdd-remote`, deprecated aliases |
| [extensions.yml.template](./spec-kit/extensions.yml.template) | Post-phase hooks (agent-context, confidence, confidence-improve) |
| [agent-context-config.yml.template](./spec-kit/agent-context-config.yml.template) | Target rule file for SPECKIT block (`{CONTEXT_FILE}`) |
| [phase-exits-template.md](./spec-kit/phase-exits-template.md) | Append-only binary gate log |
| [confidence-template.md](./spec-kit/confidence-template.md) | Terminal confidence report |
| [confidence-checks-template.md](./spec-kit/confidence-checks-template.md) | Effort checks drafted at plan |
| [plan-template-confidence-section.patch](./spec-kit/plan-template-confidence-section.patch) | Merge into managed `plan-template.md` |
| [deprecated-aliases.md](./spec-kit/deprecated-aliases.md) | Flag mapping for old workflow IDs |
| [sdd-*-workflow.yml](./spec-kit/) (other names) | **Deprecated comment stubs** — use `sdd` flags instead |
| [init-checklist.md](./spec-kit/init-checklist.md) | Bootstrap steps (also [../specify/bootstrap.md](../specify/bootstrap.md)) |
| [sdd-user-guide.template.md](./spec-kit/sdd-user-guide.template.md) | Repo `docs/agents/SDD_USER_GUIDE.md` |
| [constitution-bootstrap-prompt.md](./spec-kit/constitution-bootstrap-prompt.md) | Compile constitution from rules |
| [specify-rules-override.mdc](./spec-kit/specify-rules-override.mdc) | Glob-gated SDD rule |

Replace `{LINT_CMD}`, `{TEST_CMD}`, `{CONTEXT_FILE}` after copy. **Exemplar (meeting_notes):** `uv run ruff check` and `doppler run -- uv run python -m pytest tests/ -x -q`.

## Skills & rules

| Path | Purpose |
|------|---------|
| [skills/sdd-entry/](./skills/sdd-entry/) | Chat front door (Start/Continue SDD) |
| [skills/speckit-confidence/](./skills/speckit-confidence/) | Terminal reflect-and-loop phase |
| [skills/speckit-confidence-improve/](./skills/speckit-confidence-improve/) | Human-gated harness improvement proposals |
| [skills/speckit-agent-context-update/](./skills/speckit-agent-context-update/) | Agent-context extension wrapper |
| [skills/speckit-managed-deltas.md](./skills/speckit-managed-deltas.md) | Re-apply Phase Exit Gate deltas after Spec Kit upgrade |
| [rules/sdd-orchestrator-snippet.mdc](./rules/sdd-orchestrator-snippet.mdc) | Merge into repo orchestrator |
| Core `*.mdc` in this folder | Project rules starters (environment, git, testing, …) |

After copying `speckit-confidence/SKILL.md`, replace `{LINT_CMD}` and `{TEST_CMD}` with your repo's commands.

## Global machine (`global/`)

| Path | Purpose |
|------|---------|
| [global/hooks.json](./global/hooks.json) + [hooks/](./global/hooks/) | Skill router `beforeSubmitPrompt` |
| [global/rules/](./global/rules/) | Always-on cross-repo safety rules |

See [../global-env.md](../global-env.md) and [../specify/orchestrator.md](../specify/orchestrator.md) for `sdd-orchestrator-ctl` (not fully vendored — copy from a known-good machine).

## Hooks (project security)

[hooks/](./hooks/) — detect-secrets, block-no-verify, block-sensitive-reads, refresh-compact-context.

**SDD progress:** apply [hooks/refresh-compact-context-sdd.patch](./hooks/refresh-compact-context-sdd.patch) to your repo's `refresh-compact-context.sh` so `.cursor/auto-context.md` shows Spec Progress from `tasks.md` checkboxes.
