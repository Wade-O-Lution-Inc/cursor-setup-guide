---
name: sdd-bootstrap
description: >-
  One-shot install of sdd-ctl + Spec Kit 0.13.0 for marketplace seats.
  Invoke as /sdd-bootstrap or when SDD preflight reports missing ctl.
disable-model-invocation: true
---

# SDD Bootstrap

One-shot seat bootstrap for Integrity Cursor Team marketplace installs. Engine stays external — never vendor `lib/` or `phase-models.json`. Never check out a feature branch in the runtime clone.

## When to run

- User invokes `/sdd-bootstrap`, or
- `sdd-specify-preflight` / doctor reports missing `sdd-ctl`

## Prerequisites (fail closed)

1. `gh` is on `PATH` and authenticated to **Wade-O-Lution-Inc** (org clone must succeed).
2. `uv` is on `PATH`. If missing, stop and tell the user to install uv — do not improvise.
3. Do **not** proceed if an existing `~/.cursor/sdd-orchestrator-ctl` is dirty or not on clean `origin/main` after sync.

## Procedure

Run in order:

```bash
# 1. Clone ctl runtime (skip if directory already exists)
if [ ! -d "$HOME/.cursor/sdd-orchestrator-ctl" ]; then
  gh repo clone Wade-O-Lution-Inc/sdd-orchestrator ~/.cursor/sdd-orchestrator-ctl
fi

# 2. Sync to clean origin/main (fail closed on dirty / diverged)
python3 ~/.cursor/sdd-orchestrator-ctl/bin/sdd-ctl sync

# 3. Preflight
python3 ~/.cursor/sdd-orchestrator-ctl/bin/sdd-ctl preflight

# 4. Spec Kit 0.13.0 family
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@v0.13.0

# 5. Verify
specify --version   # expect 0.13.0 family
```

## Hard rules

- Never vendor orchestrator `lib/`, `phase-models.json`, or the full ctl tree into a product repo.
- Never leave a feature branch checked out in `~/.cursor/sdd-orchestrator-ctl` — always clean `origin/main` after sync.
- If `gh` cannot access `Wade-O-Lution-Inc/sdd-orchestrator`, stop and report auth failure.
- If `sync` fails (dirty tree / not on main), stop and report — do not continue SDD on a stale ctl.
- If `uv` is missing, stop — do not use pip as a substitute without explicit user request.

## After success

Return to **Start SDD**, **Start SDD Lite**, **Start SDD Review**, or **Continue SDD** via the `sdd-entry` skill.
