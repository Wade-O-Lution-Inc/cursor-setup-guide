# Spec Kit Bootstrap Checklist

**Prefer the narrative checklist:** [../../specify/bootstrap.md](../../specify/bootstrap.md)

Copy-paste steps for adopting SDD. Templates: [../](../). Reference: [meeting_notes_workflow](https://github.com/Wade-O-Lution-Inc/meeting_notes_workflow).

## 1. Install CLI (once per machine)

```bash
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@v0.10.2
specify version   # expect 0.10.2
```

## 2. Initialize in repo root

```bash
cd your-repo
specify init . --integration cursor-agent --here --force --script sh
specify integration status   # WARNING on modified managed files may be expected after org edits
```

## 3. Canonical workflows + registry

```bash
GUIDE=path/to/cursor-setup-guide/templates

mkdir -p .specify/workflows/sdd .specify/workflows/sdd-remote
cp "$GUIDE/spec-kit/sdd-workflow.yml" .specify/workflows/sdd/workflow.yml
cp "$GUIDE/spec-kit/sdd-remote-workflow.yml" .specify/workflows/sdd-remote/workflow.yml
cp "$GUIDE/spec-kit/workflow-registry.template.json" .specify/workflows/workflow-registry.json
```

Replace `{LINT_CMD}` and `{TEST_CMD}` in both workflow YAMLs.

**Exemplar (meeting_notes):**

| Placeholder | Value |
|-------------|-------|
| `{LINT_CMD}` | `uv run ruff check` |
| `{TEST_CMD}` | `doppler run -- uv run python -m pytest tests/ -x -q` |
| `{CONTEXT_FILE}` | `.cursor/rules/specify-rules.mdc` |

```bash
specify workflow list          # expect sdd + sdd-remote
specify workflow info sdd
```

## 4. Org templates + extensions

```bash
cp "$GUIDE/spec-kit/phase-exits-template.md" .specify/templates/
cp "$GUIDE/spec-kit/confidence-template.md" .specify/templates/
cp "$GUIDE/spec-kit/confidence-checks-template.md" .specify/templates/
cp "$GUIDE/spec-kit/extensions.yml.template" .specify/extensions.yml
mkdir -p .specify/extensions/agent-context
cp "$GUIDE/spec-kit/agent-context-config.yml.template" \
  .specify/extensions/agent-context/agent-context-config.yml
```

Merge [plan-template-confidence-section.patch](../spec-kit/plan-template-confidence-section.patch) into `.specify/templates/plan-template.md`.

## 5. Rules, skills, hooks

```bash
cp "$GUIDE/spec-kit/specify-rules-override.mdc" .cursor/rules/specify-rules.mdc
cp "$GUIDE/skills/sdd-entry/SKILL.md" .cursor/skills/sdd-entry/
cp "$GUIDE/skills/speckit-confidence/SKILL.md" .cursor/skills/speckit-confidence/
cp "$GUIDE/skills/speckit-confidence-improve/SKILL.md" .cursor/skills/speckit-confidence-improve/
cp "$GUIDE/skills/speckit-agent-context-update/SKILL.md" .cursor/skills/speckit-agent-context-update/
# Replace {LINT_CMD}/{TEST_CMD} in specify-rules + speckit-confidence
# Merge rules/sdd-orchestrator-snippet.mdc into orchestrator
# Apply hooks/refresh-compact-context-sdd.patch to refresh-compact-context.sh
```

Re-apply managed deltas: [../skills/speckit-managed-deltas.md](../skills/speckit-managed-deltas.md).

## 6–8

Constitution, user guide, gitignore, global orchestrator, dogfood — see **[../../specify/bootstrap.md](../../specify/bootstrap.md)**.
