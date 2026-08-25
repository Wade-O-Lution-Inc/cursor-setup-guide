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
| **Team marketplace** `plugins/**` | Intended primary after Dashboard Required / Default On — **blocked on Teams Default** (see below) |
| **CLI** `templates/global/**` + `bin/cursor-setup` | **Team-wide path until Cursor fixes Default** (`install-global`, `refresh-global`) |

Keep both. Do not remove `install-global`.

## Team-wide path until Cursor fixes Default

Cursor Teams auto-creates a **Default** marketplace when IntegrityKB (or any Team MCP) is linked via Integrations & MCP → Add to Team Marketplace. That slot cannot be renamed or deleted. Importing this repo’s plugins onto Default fails:

```text
POST /api/dashboard/register-marketplace-and-plugins → 400
marketplaceName: "__DEFAULT__"
detail: Marketplace name must be kebab-case (lowercase alphanumeric with hyphens)
```

Do **not** uninstall Default to make room. Delete is rejected (`The default team marketplace cannot be deleted`). If it succeeded, Cursor can also delete the linked Team MCP (IntegrityKB) for local seats and Cloud Agents. Default also occupies the only Teams marketplace slot, so a second git-backed marketplace is not available.

**Until Cursor accepts `__DEFAULT__` on that API, every named seat uses the CLI path.**

```bash
gh repo clone Wade-O-Lution-Inc/cursor-setup-guide
cd cursor-setup-guide
git checkout main
git pull --ff-only
./bin/cursor-setup install-global
./bin/cursor-setup doctor
```

If `doctor` reports missing `sdd-ctl`, finish [day1.md](./day1.md) (clone `sdd-orchestrator` → `sdd-ctl sync`). After harness / router / hook PRs land on `main`, each machine runs `./bin/cursor-setup refresh-global`.

| Still on Dashboard (leave it) | Not available until Cursor fixes Default |
|-------------------------------|------------------------------------------|
| `integrity-kb-company` Team MCP on Default | Import `cursor-setup-guide` plugins onto Default |
| IntegrityKB auth in Integrations & MCP | Required / Default On for `integrity-sdd` / `integrity-safety` / `integrity-company-context` |

Optional per-seat (does not use the Team slot): Cursor → Customize → Add Marketplace → `https://github.com/Wade-O-Lution-Inc/cursor-setup-guide`. That is not team-wide. Cloud Agents do **not** load `~/.cursor/hooks.json` — they stay on Team plugins / Team MCP once Default import works.

When Cursor fixes Default: import this repo onto the existing marketplace, smoke, then Required / Default On. Seats that already ran `install-global` must drop the duplicate `beforeSubmitPrompt` router from `~/.cursor/hooks.json` so only the safety plugin injects it.

### Official hook path deviation

Cursor Plugin discovery expects hooks at **`plugins/<name>/hooks/hooks.json`** (not plugin-root `hooks.json`). Both Integrity plugins follow that layout.

### Safety hook: sibling router, not HOME wrapper

`integrity-safety` `hooks/hooks.json` invokes **`./hooks/workspace-skill-router.sh`** (plugin-sibling real router). Do **not** wire `route-skills-before-prompt.sh` as the plugin hook — that wrapper `exec`s `~/.cursor/hooks/...` and breaks plugin-only seats. The wrapper file is still copied for CLI dual-path content parity.

Do **not** double-inject the same `beforeSubmitPrompt` handler from both Team plugin scope and user `~/.cursor/hooks.json` on one seat after plugins are Required — pick one distribution path per machine for the router (plugin Team scope primary after Required; `install-global` user hooks are fallback). Cloud Agents do **not** load `~/.cursor/hooks.json`.

## Human Dashboard steps (leftover — agent cannot click)

**Blocked on Teams Default** until Cursor fixes the kebab-case `400` above. Use [Team-wide path until Cursor fixes Default](#team-wide-path-until-cursor-fixes-default) now. When import works, do these in Cursor Team Dashboard, in order:

1. **Import** this repo (`cursor-setup-guide`) onto the **existing** Default marketplace (do not delete Default; do not create a second marketplace).
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

## New-hire path (until Default import works)

1. Join Integrity Cursor Team (IntegrityKB MCP still comes from Default / Team MCP).
2. Clone this guide and run **`./bin/cursor-setup install-global`** then **`./bin/cursor-setup doctor`** (commands above).
3. Still run **`/sdd-bootstrap` once** (ctl + Spec Kit 0.13.0) if preflight reports missing ctl.

After Cursor fixes Default import: plugins appear from the Team marketplace; keep `install-global` as the machine-harness fallback only.

## Smoke test (Standard seat)

While Default import is blocked, use the CLI path: `install-global` + `doctor`, then the routing / preflight checks below (skip “three plugins visible”).

- [ ] Three plugins visible; enable SDD + safety (+ company-context).
- [ ] Chat **Start SDD Lite:** … enters Lite workflow (or Continue SDD resumes pin).
- [ ] Skill routing injects `MANDATORY SKILL ROUTING` (safety plugin or CLI hooks).
- [ ] SDD kickoff injects `MANDATORY SDD PREFLIGHT` when applicable.
- [ ] No secrets under `plugins/` (`mcp.json` with URLs/tokens absent).
- [ ] Local: `python3 -c` JSON-load marketplace + plugin.json; `bash templates/global/hooks/workspace-skill-router.test.sh`; `./bin/cursor-setup doctor` (stub WARN OK).

## Do-not list

- No deleting or renaming the Default team marketplace
- No second marketplace repository
- No secrets / URLs / tokens in `mcp.json` in this repo
- No wrapping `sdd-ctl` as MCP
- No marking plugins **Required** from git
- No merge from agent (human merges PR)
- No enabling **Auto Refresh** from agent
- No vendoring orchestrator `lib/` or `phase-models.json`
