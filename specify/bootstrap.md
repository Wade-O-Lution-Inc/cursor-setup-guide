# Bootstrap — new repo or machine

Canonical templates live in [../templates/](../templates/). **Live reference:** [meeting_notes_workflow](https://github.com/Wade-O-Lution-Inc/meeting_notes_workflow).

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
GUIDE=path/to/cursor-setup-guide/templates

mkdir -p .specify/workflows/sdd .specify/workflows/sdd-remote
cp "$GUIDE/spec-kit/sdd-workflow.yml" .specify/workflows/sdd/workflow.yml
cp "$GUIDE/spec-kit/sdd-remote-workflow.yml" .specify/workflows/sdd-remote/workflow.yml

cp "$GUIDE/spec-kit/workflow-registry.template.json" .specify/workflows/workflow-registry.json
# Update installed_at / updated_at timestamps in registry if desired

# Replace placeholders in workflow YAMLs:
#   {LINT_CMD}  e.g. uv run ruff check
#   {TEST_CMD}  e.g. doppler run -- uv run python -m pytest tests/ -x -q
```

Optional deprecated alias dirs: see [../templates/spec-kit/deprecated-aliases.md](../templates/spec-kit/deprecated-aliases.md).

```bash
specify workflow list
specify workflow info sdd
```

### Org templates

```bash
cp "$GUIDE/spec-kit/phase-exits-template.md" .specify/templates/
cp "$GUIDE/spec-kit/confidence-template.md" .specify/templates/
cp "$GUIDE/spec-kit/confidence-checks-template.md" .specify/templates/
# Merge plan-template-confidence-section.patch into .specify/templates/plan-template.md
```

### Extensions + agent context

```bash
cp "$GUIDE/spec-kit/extensions.yml.template" .specify/extensions.yml
mkdir -p .specify/extensions/agent-context
cp "$GUIDE/spec-kit/agent-context-config.yml.template" \
  .specify/extensions/agent-context/agent-context-config.yml
# Set context_file (default .cursor/rules/specify-rules.mdc)
```

### Constitution

Compile from your `.cursor/rules/` using [../templates/spec-kit/constitution-bootstrap-prompt.md](../templates/spec-kit/constitution-bootstrap-prompt.md) → `.specify/memory/constitution.md`.

Include SDD quality gates (clarify before plan, analyze before implement when needed, no implement without `tasks.md`, confidence terminal gate, per-phase exit gates). See meeting_notes constitution v1.2.0 for the pattern.

### Rules + entry skill

```bash
cp "$GUIDE/spec-kit/specify-rules-override.mdc" .cursor/rules/specify-rules.mdc
# alwaysApply: false; globs: specs/**, .specify/**
# Replace {LINT_CMD} and {TEST_CMD} in the SPECKIT block

# Merge templates/rules/sdd-orchestrator-snippet.mdc into your orchestrator rule

mkdir -p .cursor/skills/sdd-entry
cp "$GUIDE/skills/sdd-entry/SKILL.md" .cursor/skills/sdd-entry/SKILL.md
```

### Custom skills (not in Spec Kit manifest)

```bash
mkdir -p .cursor/skills/speckit-confidence .cursor/skills/speckit-confidence-improve \
  .cursor/skills/speckit-agent-context-update

cp "$GUIDE/skills/speckit-confidence/SKILL.md" .cursor/skills/speckit-confidence/
cp "$GUIDE/skills/speckit-confidence-improve/SKILL.md" .cursor/skills/speckit-confidence-improve/
cp "$GUIDE/skills/speckit-agent-context-update/SKILL.md" .cursor/skills/speckit-agent-context-update/

# Replace {LINT_CMD} and {TEST_CMD} in speckit-confidence/SKILL.md
```

Re-apply managed `speckit-*` Phase Exit Gate deltas after any `specify integration upgrade --force`: [../templates/skills/speckit-managed-deltas.md](../templates/skills/speckit-managed-deltas.md).

Optional: `remote-agent-handoff` from meeting_notes if using Mac mini.

### Hooks (SDD progress in auto-context)

Apply [../templates/hooks/refresh-compact-context-sdd.patch](../templates/hooks/refresh-compact-context-sdd.patch) to `.cursor/hooks/refresh-compact-context.sh`.

### Docs + gitignore

```bash
mkdir -p docs/agents
cp "$GUIDE/spec-kit/sdd-user-guide.template.md" docs/agents/SDD_USER_GUIDE.md
# Replace {LINT_CMD}, {TEST_CMD}, and repo-specific handoff notes
```

```
.specify/workflows/runs/
.specify/presets/.cache/
```

### Dogfood

1. Chat: `Start SDD: …` — confirm router suggests `sdd-entry` + `sdd-orchestrator`
2. Or CLI: `specify workflow run sdd -i stop_at=plan -i spec="…"`

Next: [managed-vs-custom.md](./managed-vs-custom.md) · [../templates/spec-kit/init-checklist.md](../templates/spec-kit/init-checklist.md)
