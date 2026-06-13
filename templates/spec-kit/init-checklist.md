# Spec Kit Bootstrap Checklist

Copy-paste steps for adopting SDD in a Wade-O-Lution repo. Reference: [meeting_notes_workflow](https://github.com/Wade-O-Lution-Inc/meeting_notes_workflow).

## 1. Install CLI (once per machine)

```bash
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@v0.10.2
specify version   # expect 0.10.2
```

## 2. Initialize in repo root

```bash
cd your-repo
specify init . --integration cursor-agent --here --force --script sh
specify integration status   # expect OK
```

## 3. Add org workflows

```bash
mkdir -p .specify/workflows/sdd-full .specify/workflows/sdd-api \
  .specify/workflows/sdd-rfc .specify/workflows/sdd-test-fix .specify/workflows/sdd-issues

cp path/to/cursor-setup-guide/templates/spec-kit/sdd-full-workflow.yml .specify/workflows/sdd-full/workflow.yml
cp path/to/cursor-setup-guide/templates/spec-kit/sdd-api-workflow.yml .specify/workflows/sdd-api/workflow.yml
cp path/to/cursor-setup-guide/templates/spec-kit/sdd-rfc-workflow.yml .specify/workflows/sdd-rfc/workflow.yml
cp path/to/cursor-setup-guide/templates/spec-kit/sdd-test-fix-workflow.yml .specify/workflows/sdd-test-fix/workflow.yml
cp path/to/cursor-setup-guide/templates/spec-kit/sdd-issues-workflow.yml .specify/workflows/sdd-issues/workflow.yml
```

Replace `{LINT_CMD}` and `{TEST_CMD}` in each YAML with your repo's lint/test commands.

Register workflows in `.specify/workflows/workflow-registry.json` (or use `specify workflow add` if not SameFileError).

Verify:

```bash
specify workflow list
specify workflow info sdd-full
```

## 4. Constitution

Run the prompt in [constitution-bootstrap-prompt.md](./constitution-bootstrap-prompt.md) against your existing `.cursor/rules/`. Output → `.specify/memory/constitution.md`.

## 5. Glob-gated specify rules

```bash
cp templates/spec-kit/specify-rules-override.mdc .cursor/rules/specify-rules.mdc
```

Confirm `alwaysApply: false` and globs `specs/**`, `.specify/**`.

## 6. Orchestrator SDD mode

Merge [../rules/sdd-orchestrator-snippet.mdc](../rules/sdd-orchestrator-snippet.mdc) into your repo's orchestrator rule (or add as standalone SDD section).

## 7. Bridge skill

```bash
mkdir -p .cursor/skills/sdd-entry
cp templates/skills/sdd-entry/SKILL.md .cursor/skills/sdd-entry/SKILL.md
```

Edit paths in SKILL.md to match your repo's doc locations.

## 8. User guide

```bash
mkdir -p docs/agents
cp templates/spec-kit/sdd-user-guide.template.md docs/agents/SDD_USER_GUIDE.md
# Replace {LINT_CMD}, {TEST_CMD}, {SECRETS_PREFIX}, {REPO_NAME}
```

Add deep reference doc (copy structure from meeting_notes `SPEC_DRIVEN_DEVELOPMENT.md`).

## 9. Optional: auto-context Spec Progress

Apply [../hooks/refresh-compact-context-sdd.patch](../hooks/refresh-compact-context-sdd.patch) to `.cursor/hooks/refresh-compact-context.sh`.

## 10. Gitignore

Add to `.gitignore`:

```
.specify/workflows/runs/
```

## 11. Verify

```bash
specify integration status
{LINT_CMD}
{TEST_CMD}
```

Dogfood one feature using **only** `docs/agents/SDD_USER_GUIDE.md`.
