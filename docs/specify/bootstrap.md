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

Also confirm the machine hook chain (day-1 global install):

1. `./bin/cursor-setup doctor` reports the skill router **and** `sdd-specify-preflight` wired in `~/.cursor/hooks.json`
2. Chat `Continue SDD` injects `MANDATORY SDD PREFLIGHT` (ctl sync/preflight, `.specify/`, `sdd-entry`, `orchestrator.json`)
3. Unset `SDD_CTL_SKIP_INSTALL_PREFLIGHT` on product machines — that env var skips ctl install preflight (ctl self-dev only)

If preflight says missing `.specify/`, re-run `adopt-sdd` (or the manual copy table below).

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

---

## What you can change

| Layer | Owned by | Upgrade risk |
|-------|----------|--------------|
| `specify` CLI | Upstream Spec Kit | `specify self upgrade` |
| Hash-tracked managed files | Spec Kit manifests | `specify integration upgrade --force` may overwrite |
| Org workflows / custom skills / constitution / repo policy | You (product repo) | Safe; not in upstream manifest |
| Global orchestrator ctl | [sdd-orchestrator](https://github.com/Wade-O-Lution-Inc/sdd-orchestrator) | `sdd-ctl sync` → `origin/main` |
| This guide’s templates | Adoption copies | Sync from meeting_notes — [SYNC.md](../../templates/SYNC.md) |

### Fully custom (safe to own)

| Asset | Notes |
|-------|-------|
| `.specify/workflows/sdd/`, `sdd-remote/` | Local registry |
| `.specify/orchestrator.json` | Repo policy for ctl |
| `.cursor/skills/sdd-entry/` | Chat front door |
| `speckit-confidence`, `speckit-confidence-improve`, `speckit-agent-context-update` | Not in Spec Kit manifest |
| `.specify/memory/constitution.md` | Compiled from rules |
| Orchestrator snippet / `specify-rules.mdc` | Repo harness |
| `~/.cursor/sdd-orchestrator-ctl` | Clone of GitHub; not product git |

### Customization surfaces

| Want to change… | Edit |
|-----------------|------|
| Flags / stop points / remote flow | Workflow YAML + registry |
| Lint/test commands | Workflow shells **and** `orchestrator.json` `implement_hooks` |
| Auto-continue vs pause-after-pass | `gate_mode` in `.specify/orchestrator.json` |
| Models / swarms / shadow_rate / repair_cap | ctl `phase-models.json` (+ optional repo `phases` overrides) |
| Judge/worker/expert prompts | ctl `prompts/` |

Managed `speckit-*` skills may show `specify integration status` **WARNING** when org Phase Exit Gate edits diverge — expected. After upstream bumps, review diffs then re-apply [speckit-managed-deltas.md](../../templates/skills/speckit-managed-deltas.md).

### Do not

- Vendor a second copy of the orchestrator into a product repo  
- Daily-use the upstream `speckit` workflow  
- Let `confidence-improve` auto-edit skills or constitution  
- Treat `specs/` as durable product docs
