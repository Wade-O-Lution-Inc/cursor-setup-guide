# Bootstrap — new repo or machine

Canonical templates: [../templates/](../templates/) ([SYNC.md](../templates/SYNC.md)).  
**Live product reference:** [meeting_notes_workflow](https://github.com/Wade-O-Lution-Inc/meeting_notes_workflow).  
**Orchestrator runtime:** [sdd-orchestrator](https://github.com/Wade-O-Lution-Inc/sdd-orchestrator).

Day-1 checklist (machine): [../day1-setup.md](../day1-setup.md).

## Machine (once)

1. Spec Kit CLI + orchestrator clone + global harness — follow [../day1-setup.md](../day1-setup.md).

```bash
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@v0.10.2
gh repo clone Wade-O-Lution-Inc/sdd-orchestrator ~/.cursor/sdd-orchestrator-ctl
mkdir -p ~/.cursor/skills
ln -sfn ~/.cursor/sdd-orchestrator-ctl/skills/sdd-orchestrator ~/.cursor/skills/sdd-orchestrator
python3 ~/.cursor/sdd-orchestrator-ctl/bin/sdd-ctl plan-phase --help
```

2. Global hooks/rules from [../templates/global/](../templates/global/) — [../global-env.md](../global-env.md).

3. Optional Spec Kit pointer stubs under `~/.cursor/skills/speckit-*/`.

4. Verify router: `bash ~/.cursor/hooks/workspace-skill-router.test.sh` (if present).

Do **not** treat “copy ctl from a known-good machine” as the primary path — clone GitHub, then `git pull` to update.

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
# Update installed_at / updated_at timestamps if desired

# Replace placeholders in workflow YAMLs:
#   {LINT_CMD}  e.g. uv run ruff check
#   {TEST_CMD}  e.g. doppler run -- uv run python -m pytest tests/ -x -q
```

Canonical IDs only: **`sdd`**, **`sdd-remote`**. Alias migration: [../templates/spec-kit/deprecated-aliases.md](../templates/spec-kit/deprecated-aliases.md).

```bash
specify workflow list
specify workflow info sdd
```

### Repo orchestrator policy

```bash
cp "$GUIDE/spec-kit/orchestrator.json" .specify/orchestrator.json
# Edit implement_hooks; keep allow_repo_commands: true only if you trust those commands
echo '.specify/orchestrator-runs/' >> .gitignore
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
```

### Constitution

Compile from your `.cursor/rules/` using [../templates/spec-kit/constitution-bootstrap-prompt.md](../templates/spec-kit/constitution-bootstrap-prompt.md) → `.specify/memory/constitution.md`.

Include SDD quality gates (clarify before plan, analyze before implement when needed, no implement without `tasks.md`, confidence terminal gate, orchestrator-owned phase exits with auto-continue / repair-cap stop). See meeting_notes constitution for the pattern.

### Rules + entry skill

```bash
cp "$GUIDE/spec-kit/specify-rules-override.mdc" .cursor/rules/specify-rules.mdc
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
```

Re-apply managed `speckit-*` Phase Exit Gate deltas after any `specify integration upgrade --force`: [../templates/skills/speckit-managed-deltas.md](../templates/skills/speckit-managed-deltas.md).

Optional: `remote-agent-handoff` from meeting_notes if using Mac mini.

### Docs + gitignore

```bash
mkdir -p docs/agents
cp "$GUIDE/spec-kit/sdd-user-guide.template.md" docs/agents/SDD_USER_GUIDE.md
```

```
.specify/workflows/runs/
.specify/presets/.cache/
.specify/orchestrator-runs/
```

### Dogfood

1. Chat: `Start SDD: …` — confirm router suggests `sdd-entry` + `sdd-orchestrator`; phases auto-continue until repair-cap stop or `stop_at`
2. Or CLI: `specify workflow run sdd -i stop_at=plan -i spec="…"`
3. End of run: agent should run `sdd-ctl report` for the feature

Next: [managed-vs-custom.md](./managed-vs-custom.md) · [../templates/spec-kit/init-checklist.md](../templates/spec-kit/init-checklist.md) · [../day1-setup.md](../day1-setup.md)
