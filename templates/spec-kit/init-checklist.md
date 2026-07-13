# Spec Kit Bootstrap Checklist

Copy-paste steps for adopting SDD in a Wade-O-Lution repo. Reference: [meeting_notes_workflow](https://github.com/Wade-O-Lution-Inc/meeting_notes_workflow). Global harness: [global-env.md](../../global-env.md).

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

## 3. Add org workflows (canonical pair)

```bash
mkdir -p .specify/workflows/sdd .specify/workflows/sdd-remote

cp path/to/cursor-setup-guide/templates/spec-kit/sdd-workflow.yml \
  .specify/workflows/sdd/workflow.yml
cp path/to/cursor-setup-guide/templates/spec-kit/sdd-remote-workflow.yml \
  .specify/workflows/sdd-remote/workflow.yml
```

Replace `{LINT_CMD}` and `{TEST_CMD}` in each YAML with your repo's lint/test commands.

Register in `.specify/workflows/workflow-registry.json` (see meeting_notes for a full example with deprecated aliases).

Verify:

```bash
specify workflow list          # expect sdd + sdd-remote
specify workflow info sdd
specify workflow info sdd-remote
```

Optional: copy deprecated alias workflows from meeting_notes if you need old IDs (`sdd-full`, …) for one release.

## 4. Constitution

Run the prompt in [constitution-bootstrap-prompt.md](./constitution-bootstrap-prompt.md) against your existing `.cursor/rules/`. Output → `.specify/memory/constitution.md`.

## 5. Glob-gated specify rules

```bash
cp templates/spec-kit/specify-rules-override.mdc .cursor/rules/specify-rules.mdc
```

Confirm `alwaysApply: false` and globs `specs/**`, `.specify/**`.

## 6. Orchestrator SDD mode

Merge [../rules/sdd-orchestrator-snippet.mdc](../rules/sdd-orchestrator-snippet.mdc) into your repo's orchestrator rule.

## 7. Bridge skill

```bash
mkdir -p .cursor/skills/sdd-entry
cp templates/skills/sdd-entry/SKILL.md .cursor/skills/sdd-entry/SKILL.md
```

## 8. Global always-on orchestrator (once per machine)

Confirm `~/.cursor/skills/sdd-orchestrator/SKILL.md` and `~/.cursor/sdd-orchestrator-ctl/` exist. See [global-env.md](../../global-env.md). Without these, chat phases cannot gate correctly.

## 9. User guide

```bash
mkdir -p docs/agents
cp templates/spec-kit/sdd-user-guide.template.md docs/agents/SDD_USER_GUIDE.md
# Replace {LINT_CMD}, {TEST_CMD}, {SECRETS_PREFIX}, {REPO_NAME}
```

## 10. Optional: auto-context Spec Progress

Apply [../hooks/refresh-compact-context-sdd.patch](../hooks/refresh-compact-context-sdd.patch) to `.cursor/hooks/refresh-compact-context.sh`.

## 11. Gitignore

```
.specify/workflows/runs/
.specify/presets/.cache/
```

## 12. Verify

```bash
specify integration status
{LINT_CMD}
{TEST_CMD}
```

Dogfood: `Start SDD: …` in chat (must route via `sdd-entry` → `sdd-orchestrator`) or `specify workflow run sdd -i stop_at=plan -i spec="…"`.
