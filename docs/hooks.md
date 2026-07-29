# Hooks

Hard stops and side-effects. Prefer **fail-open** observation for non-security hooks; **fail-closed** for secrets / `--no-verify` / credential reads.

---

## Layers

| Layer | Install | Events |
|-------|---------|--------|
| **Global** skill router | `install-global` / `refresh-global` | `beforeSubmitPrompt` → `workspace-skill-router.sh` |
| **Global** SDD specify preflight | `install-global` / `refresh-global` | `beforeSubmitPrompt` → `sdd-specify-preflight.sh` (**inject-only**) |
| **Product** security + compact context | `scaffold-repo` | prompt / shell / tab read / afterFileEdit / stop |
| **Optional product** orchestrator | scripts in `templates/product/hooks/`; wire yourself | `beforeShellExecution`, `subagentStop` |

## Security baseline

Shipped under `templates/product/hooks/` and wired in `templates/product/hooks.json`:

- `detect-secrets.sh` — `beforeSubmitPrompt`
- `block-no-verify.sh` — `beforeShellExecution`
- `block-sensitive-reads.sh` — `beforeTabFileRead`
- `refresh-compact-context.sh` — `afterFileEdit` + `stop`

Minimal shape (see template for full JSON):

```json
{
  "hooks": [
    { "event": "beforeSubmitPrompt", "script": ".cursor/hooks/detect-secrets.sh" },
    { "event": "beforeShellExecution", "script": ".cursor/hooks/block-no-verify.sh" },
    { "event": "beforeTabFileRead", "script": ".cursor/hooks/block-sensitive-reads.sh" }
  ]
}
```

## Optional orchestrator hooks

Also shipped (from MNW gold), **not** in default `hooks.json`:

- `orchestrator-pre-shell.sh` — staging-first / protected branch observation  
- `orchestrator-post-tool.sh` — mixed-concern suggestion after subagents  

Wire like meeting_notes `.cursor/hooks.json` when you want them.

## Global skill router

```bash
./bin/cursor-setup refresh-global   # after router / global-hook PRs
```

`~/.cursor/hooks.json` (from `templates/global/hooks.json`) runs **two** `beforeSubmitPrompt` commands, in order:

1. `hooks/route-skills-before-prompt.sh` → injects `MANDATORY SKILL ROUTING…`
2. `hooks/sdd-specify-preflight.sh` → on Start/Continue SDD (and similar), injects `MANDATORY SDD PREFLIGHT…`

### SDD specify preflight (inject-only)

Does **not** block the prompt (`continue: true`). When the user kicks off SDD it:

- runs `sdd-ctl sync` + `preflight` (reports skip if `SDD_CTL_SKIP_INSTALL_PREFLIGHT` is set)
- checks the global `sdd-orchestrator` skill symlink
- per workspace root: `.specify/`, `sdd-entry`, `orchestrator.json`, vendored skill warning

Smoke: chat `Continue SDD` in an adopted repo and confirm an agent message starting with `MANDATORY SDD PREFLIGHT`. Missing `.specify/` should tell you to run `cursor-setup adopt-sdd`.

After this guide lands router/hook PRs: every machine must `./bin/cursor-setup refresh-global` or the new hook will be missing / wiped.

### Gold dual-router pattern

MNW adds a **repo** `route-skills-before-prompt.sh` that sets `WADE_REPO_KEY` and execs the global router. Scaffold baselines use **global only**. Copy the wrapper from gold if you need per-repo keyword packs. See [product-repo.md](./product-repo.md#gold-dual-router-note).

## Compact handoff

`refresh-compact-context.sh` writes `.cursor/auto-context.md`. Global rule `compact-handoff.mdc` describes the handoff format. SDD patch: `templates/product/hooks/refresh-compact-context-sdd.patch`.

## Writing custom hooks

- Small scripts; ≤1 follow-up message  
- Non-zero exit only when blocking  
- Never embed secrets  
