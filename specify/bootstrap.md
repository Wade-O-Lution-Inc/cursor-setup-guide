# Bootstrap — new repo or machine

## Machine (once)

1. Install CLI:

```bash
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@v0.10.2
specify version   # expect 0.10.2
```

2. Install global harness ([../global-env.md](../global-env.md)):
   - `~/.cursor/hooks.json` + skill router scripts
   - Always-on global rules
   - `~/.cursor/skills/sdd-orchestrator/`
   - `~/.cursor/sdd-orchestrator-ctl/`
   - Optional Spec Kit pointer stubs under `~/.cursor/skills/speckit-*/`

3. Verify router: `bash ~/.cursor/hooks/workspace-skill-router.test.sh` (if present)

## Repo

```bash
cd your-repo
specify init . --integration cursor-agent --here --force --script sh
specify integration status
```

### Install org workflows

```bash
mkdir -p .specify/workflows/sdd .specify/workflows/sdd-remote
cp path/to/cursor-setup-guide/templates/spec-kit/sdd-workflow.yml \
  .specify/workflows/sdd/workflow.yml
cp path/to/cursor-setup-guide/templates/spec-kit/sdd-remote-workflow.yml \
  .specify/workflows/sdd-remote/workflow.yml
# Replace {LINT_CMD} and {TEST_CMD}
```

Register in `.specify/workflows/workflow-registry.json` (copy shape from meeting_notes). Optional: copy deprecated alias workflows from meeting_notes for one release.

```bash
specify workflow list
specify workflow info sdd
```

### Constitution

Compile from your `.cursor/rules/` using [../templates/spec-kit/constitution-bootstrap-prompt.md](../templates/spec-kit/constitution-bootstrap-prompt.md) → `.specify/memory/constitution.md`.

Include SDD quality gates (clarify before plan, analyze before implement when needed, no implement without `tasks.md`, confidence terminal gate, per-phase exit gates). See meeting_notes constitution v1.2.0 for the pattern.

### Rules + entry skill

```bash
cp templates/spec-kit/specify-rules-override.mdc .cursor/rules/specify-rules.mdc
# alwaysApply: false; globs: specs/**, .specify/**

# Merge templates/rules/sdd-orchestrator-snippet.mdc into your orchestrator rule

mkdir -p .cursor/skills/sdd-entry
cp templates/skills/sdd-entry/SKILL.md .cursor/skills/sdd-entry/SKILL.md
```

### Org templates (copy from meeting_notes if not already present)

| File | Role |
|------|------|
| `.specify/templates/phase-exits-template.md` | Append-only binary gate log |
| `.specify/templates/confidence-template.md` | Terminal score artifact |
| `.specify/templates/confidence-checks-template.md` | Effort checks drafted at plan |
| Plan template Confidence Checks section | Managed file — expect `integration status` WARNING |

### Custom skills (not in Spec Kit manifest)

Copy from meeting_notes as needed:

- `speckit-confidence`, `speckit-confidence-improve`
- `speckit-agent-context-update` (if using agent-context extension)
- `remote-agent-handoff` (if using Mac mini)

### Extensions hooks

Wire `.specify/extensions.yml` (meeting_notes pattern):

| Hook | Command |
|------|---------|
| `after_specify` / `after_plan` | `speckit.agent-context.update` (optional) |
| `after_implement` | `speckit.confidence` (optional) |
| `after_confidence` | `speckit.confidence-improve` (optional) |

### Docs + gitignore

```bash
cp templates/spec-kit/sdd-user-guide.template.md docs/agents/SDD_USER_GUIDE.md
# Prefer linking this guide's specify/ hub as org source of truth
```

```
.specify/workflows/runs/
.specify/presets/.cache/
```

### Dogfood

1. Chat: `Start SDD: …` — confirm router suggests `sdd-entry` + `sdd-orchestrator`
2. Or CLI: `specify workflow run sdd -i stop_at=plan -i spec="…"`

Next: [managed-vs-custom.md](./managed-vs-custom.md) · [../templates/spec-kit/init-checklist.md](../templates/spec-kit/init-checklist.md)
