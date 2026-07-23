# Adopt SDD in a product repo

Machine day-1 first: [../day1.md](../day1.md) (install Spec Kit CLI in the optional section). Prefer the install CLI:

**Warn:** `adopt-sdd` may run `specify init --force` and overwrite Spec Kit-managed files. Use intentionally.

```bash
cd /path/to/cursor-setup-guide
./bin/cursor-setup adopt-sdd /path/to/your-repo \
  --lint-cmd 'YOUR_LINT' \
  --test-cmd 'YOUR_TEST'
```

That wraps `specify init` (when `specify` is on `PATH`) and copies the org pack from `templates/spec-kit/` + `templates/skills/sdd-entry` (and confidence skills).

### Verify

```bash
cd /path/to/your-repo
specify workflow list    # expect sdd + sdd-remote
specify integration status
# Chat: Start SDD: smoke adopt …
```

## Manual equivalent (appendix — prefer CLI)

```bash
cd /path/to/your-repo
specify init . --integration cursor-agent --here --force --script sh
specify integration status
```

Then copy from this guide:

| Template | Destination |
|----------|-------------|
| `templates/spec-kit/sdd-workflow.yml` | `.specify/workflows/sdd/workflow.yml` |
| `templates/spec-kit/sdd-remote-workflow.yml` | `.specify/workflows/sdd-remote/workflow.yml` |
| `templates/spec-kit/workflow-registry.template.json` | `.specify/workflows/workflow-registry.json` |
| `templates/spec-kit/orchestrator.json` | `.specify/orchestrator.json` |
| `templates/skills/sdd-entry/` | `.cursor/skills/sdd-entry/` |
| confidence / agent-context skills | `.cursor/skills/…` |
| `templates/product/rules/sdd-orchestrator-snippet.mdc` | merge into repo orchestrator rule |

Replace `{LINT_CMD}` / `{TEST_CMD}` / `{CONTEXT_FILE}` when present.

`persona_comms` is opt-in in the template `orchestrator.json` — understand evidence + round caps before enabling ([orchestrator.md](./orchestrator.md)).

## Dogfood

```bash
specify workflow list   # sdd, sdd-remote
# Chat: Start SDD: …
```

Portable ctl adoption notes: [sdd-orchestrator ADOPTION.md](https://github.com/Wade-O-Lution-Inc/sdd-orchestrator/blob/main/docs/ADOPTION.md).

Short checklist: [../../templates/spec-kit/init-checklist.md](../../templates/spec-kit/init-checklist.md).
