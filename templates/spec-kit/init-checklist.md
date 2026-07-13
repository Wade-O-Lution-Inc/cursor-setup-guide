# Spec Kit Bootstrap Checklist

**Prefer the narrative checklist:** [../../specify/bootstrap.md](../../specify/bootstrap.md)

Copy-paste steps for adopting SDD. Reference: [meeting_notes_workflow](https://github.com/Wade-O-Lution-Inc/meeting_notes_workflow). Global harness: [../../global-env.md](../../global-env.md). Customization boundaries: [../../specify/managed-vs-custom.md](../../specify/managed-vs-custom.md).

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

## 3. Add org workflows (canonical pair)

```bash
mkdir -p .specify/workflows/sdd .specify/workflows/sdd-remote

cp path/to/cursor-setup-guide/templates/spec-kit/sdd-workflow.yml \
  .specify/workflows/sdd/workflow.yml
cp path/to/cursor-setup-guide/templates/spec-kit/sdd-remote-workflow.yml \
  .specify/workflows/sdd-remote/workflow.yml
```

Replace `{LINT_CMD}` and `{TEST_CMD}`. Register in `workflow-registry.json`.

```bash
specify workflow list          # expect sdd + sdd-remote
specify workflow info sdd
```

## 4–12

Continue with constitution, specify-rules, orchestrator snippet, `sdd-entry`, global orchestrator, user guide, gitignore, and dogfood — see **[../../specify/bootstrap.md](../../specify/bootstrap.md)**.
