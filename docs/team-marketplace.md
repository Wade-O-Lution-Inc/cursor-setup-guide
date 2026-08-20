# Team marketplace — Integrity Cursor

Admin runbook and packaging SSOT for distributing SDD Full / Lite / Review to named seats on the **Integrity Cursor Team**.

## Verdict

- Package this repo as **Cursor Plugins** on the **one** Team marketplace (`integrity-cursor`).
- **SDD is not an MCP server.** Orchestration stays on external `sdd-ctl` (`~/.cursor/sdd-orchestrator-ctl` on clean `origin/main`).
- Marketplace plugins and `./bin/cursor-setup install-global` are **dual-path** — complementary, not exclusive.

## Plugin map

| Plugin | Role | Install mode (human Dashboard) |
|--------|------|--------------------------------|
| `integrity-sdd` | Start SDD / Lite / Review, bootstrap, preflight, front-door rule | **Required** after Standard-seat smoke |
| `integrity-safety` | git-safety, supply-chain-defense, skill router | **Required** after smoke |
| `integrity-company-context` | company-mcp skill only (IntegrityKB) | **Default On** |

Install modes are documented here only — **do not** mark plugins Required/Default On from git.

## File tree

```text
.cursor-plugin/marketplace.json
plugins/
├── integrity-sdd/
│   ├── .cursor-plugin/plugin.json
│   ├── skills/sdd-entry/          # gold: sdd-orchestrator main
│   ├── skills/sdd-bootstrap/
│   ├── rules/sdd-front-door.mdc
│   ├── rules/skill-routing-mandate.mdc
│   ├── hooks/hooks.json           # official path
│   ├── hooks/sdd-specify-preflight.sh
│   └── commands/
├── integrity-safety/
│   ├── .cursor-plugin/plugin.json
│   ├── rules/git-safety.mdc
│   ├── rules/supply-chain-defense.mdc
│   ├── hooks/hooks.json           # ./hooks/workspace-skill-router.sh
│   └── hooks/workspace-skill-router*.sh (+ wrapper copy)
└── integrity-company-context/
    ├── .cursor-plugin/plugin.json
    ├── skills/company-mcp/
    └── README.md                  # no mcp.json secrets
```

## Dual-path

| Path | What it delivers |
|------|------------------|
| **Team marketplace** `plugins/**` | Primary for named seats after Dashboard Required / Default On |
| **CLI** `templates/global/**` + `bin/cursor-setup` | Fallback / machine harness (`install-global`, `refresh-global`) |

Keep both. Do not remove `install-global`.

### Official hook path deviation

Cursor Plugin discovery expects hooks at **`plugins/<name>/hooks/hooks.json`** (not plugin-root `hooks.json`). Both Integrity plugins follow that layout.

### Safety hook: sibling router, not HOME wrapper

`integrity-safety` `hooks/hooks.json` invokes **`./hooks/workspace-skill-router.sh`** (plugin-sibling real router). Do **not** wire `route-skills-before-prompt.sh` as the plugin hook — that wrapper `exec`s `~/.cursor/hooks/...` and breaks plugin-only seats. The wrapper file is still copied for CLI dual-path content parity.

Do **not** double-inject the same `beforeSubmitPrompt` handler from both Team plugin scope and user `~/.cursor/hooks.json` on one seat after plugins are Required — pick one distribution path per machine for the router (plugin Team scope primary after Required; `install-global` user hooks are fallback). Cloud Agents do **not** load `~/.cursor/hooks.json`.

## Human Dashboard steps (leftover — agent cannot click)

Do these in Cursor Team Dashboard, in order:

1. **Import** this repo (`cursor-setup-guide`) as the Integrity Team marketplace source.
2. Set **marketplace access** for named Integrity Cursor Team seats.
3. Keep **Auto Refresh OFF** until Standard-seat smoke passes.
4. After smoke: set `integrity-sdd` and `integrity-safety` to **Required**; set `integrity-company-context` to **Default On**.
5. Add an **enforced Team Rule** (text below).
6. Connect **IntegrityKB** via Integrations & MCP → Team MCP (auth stays in Dashboard — never in git `mcp.json`).

### Enforced Team Rule (document only — paste in Dashboard)

```text
SDD front door. In product repos that have .specify/, new multi-file work starts with
Start SDD, Start SDD Lite, or Start SDD Review. Continue with Continue SDD.
Never invoke bare speckit-* as the top-level skill. Never use Review to implement,
and never use Full/Lite to merge a PR. Suggest SDD route is advisory only.
```

## New-hire path (after import)

1. Join Integrity Cursor Team → plugins appear from Team marketplace.
2. Still run **`/sdd-bootstrap` once** (ctl + Spec Kit 0.13.0) if preflight reports missing ctl.
3. Fallback if marketplace delayed: `./bin/cursor-setup install-global` from this guide clone.

## Smoke test (Standard seat)

- [ ] Three plugins visible; enable SDD + safety (+ company-context).
- [ ] Chat **Start SDD Lite:** … enters Lite workflow (or Continue SDD resumes pin).
- [ ] Skill routing injects `MANDATORY SKILL ROUTING` (safety plugin or CLI hooks).
- [ ] SDD kickoff injects `MANDATORY SDD PREFLIGHT` when applicable.
- [ ] No secrets under `plugins/` (`mcp.json` with URLs/tokens absent).
- [ ] Local: `python3 -c` JSON-load marketplace + plugin.json; `bash templates/global/hooks/workspace-skill-router.test.sh`; `./bin/cursor-setup doctor` (stub WARN OK).

## Do-not list

- No second marketplace repository
- No secrets / URLs / tokens in `mcp.json` in this repo
- No wrapping `sdd-ctl` as MCP
- No marking plugins **Required** from git
- No merge from agent (human merges PR)
- No enabling **Auto Refresh** from agent
- No vendoring orchestrator `lib/` or `phase-models.json`
