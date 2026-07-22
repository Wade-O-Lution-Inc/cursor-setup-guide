# Spec Kit Bootstrap Checklist

**Machine day-1:** [../../day1-setup.md](../../day1-setup.md)  
**Full narrative:** [../../specify/bootstrap.md](../../specify/bootstrap.md)  
**Sync:** [../SYNC.md](../SYNC.md)

## 1. Machine (once)

- [ ] Spec Kit 0.13.0
- [ ] `sdd-ctl sync` + `preflight` green (ctl on `origin/main`)
- [ ] Clone `sdd-orchestrator` → `~/.cursor/sdd-orchestrator-ctl` + skill symlink
- [ ] Global hooks/rules from `templates/global/`
- [ ] `python3 ~/.cursor/sdd-orchestrator-ctl/bin/sdd-ctl plan-phase --help`

## 2. Initialize repo

```bash
cd your-repo
specify init . --integration cursor-agent --here --force --script sh
```

## 3. Canonical workflows + policy

```bash
GUIDE=path/to/cursor-setup-guide/templates

mkdir -p .specify/workflows/sdd .specify/workflows/sdd-remote
cp "$GUIDE/spec-kit/sdd-workflow.yml" .specify/workflows/sdd/workflow.yml
cp "$GUIDE/spec-kit/sdd-remote-workflow.yml" .specify/workflows/sdd-remote/workflow.yml
cp "$GUIDE/spec-kit/workflow-registry.template.json" .specify/workflows/workflow-registry.json
cp "$GUIDE/spec-kit/orchestrator.json" .specify/orchestrator.json
# Edit implement_hooks; keep allow_repo_commands only if trusted
```

Replace `{LINT_CMD}` / `{TEST_CMD}` in workflow YAMLs if present.

```bash
specify workflow list   # expect sdd + sdd-remote (+ upstream speckit)
```

## 4. Skills, templates, constitution, docs

Continue from **[../../specify/bootstrap.md](../../specify/bootstrap.md)** steps: org templates, extensions, constitution, `sdd-entry`, confidence skills, user guide, gitignore (include `.specify/orchestrator-runs/`), dogfood.
