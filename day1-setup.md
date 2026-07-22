# Day-1 machine setup

Checklist for a new laptop or Cloud Agent VM before running SDD or multi-repo Cursor work.

Pair with: [global-env.md](./global-env.md) · [specify/bootstrap.md](./specify/bootstrap.md) · [scope.md](./scope.md)

---

## Prerequisites

- [ ] GitHub CLI (`gh`) authenticated to `Wade-O-Lution-Inc`
- [ ] `uv` on `PATH` (`curl -LsSf https://astral.sh/uv/install.sh | sh`)
- [ ] Cursor Desktop (or Cloud Agent) installed

Optional (lab / remote SDD):

- [ ] Doppler CLI linked to project `knowledge-base` (`doppler login` + `doppler setup`)
- [ ] Tailscale connected (Mac mini / lab hostnames)

---

## 1. Spec Kit CLI

```bash
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@v0.13.0
specify --version   # expect 0.13.0 family
```

---

## 2. Portable SDD orchestrator (one install, every repo)

The engine is **machine-global**, not per product repo. Always track **`origin/main`**.

```bash
gh repo clone Wade-O-Lution-Inc/sdd-orchestrator ~/.cursor/sdd-orchestrator-ctl
python3 ~/.cursor/sdd-orchestrator-ctl/bin/sdd-ctl sync
python3 ~/.cursor/sdd-orchestrator-ctl/bin/sdd-ctl preflight
```

`sync` checks out `main`, ff-only pulls `origin/main`, and refreshes
`~/.cursor/skills/sdd-orchestrator`. Prefer this over a bare `git pull`.
Never leave a feature branch checked out in the runtime clone — develop ctl
changes in a separate worktree.

Smoke (stdlib only — no API key):

```bash
python3 ~/.cursor/sdd-orchestrator-ctl/bin/sdd-ctl plan-phase --help
python3 ~/.cursor/sdd-orchestrator-ctl/bin/sdd-ctl preflight
```

**Headless `sdd-run` only** (interactive Cursor UI does not need this):

```bash
cd ~/.cursor/sdd-orchestrator-ctl
uv venv .venv
uv pip install --python .venv/bin/python cursor-sdk
```

Adoption for a new product repo: [specify/bootstrap.md](./specify/bootstrap.md) ·
ctl [ADOPTION.md](https://github.com/Wade-O-Lution-Inc/sdd-orchestrator/blob/main/docs/ADOPTION.md).

---

## 3. Global Cursor harness

Copy from this guide’s [templates/global/](./templates/global/):

| Source | Destination |
|--------|-------------|
| `templates/global/hooks.json` | `~/.cursor/hooks.json` |
| `templates/global/hooks/*.sh` | `~/.cursor/hooks/` (executable) |
| `templates/global/rules/*.mdc` | `~/.cursor/rules/` |

```bash
chmod +x ~/.cursor/hooks/*.sh
```

**This is the live auto-router.** Cursor reads `~/.cursor/hooks/workspace-skill-router.sh` on every prompt — not the template sitting in git. When the team merges router keyword updates (e.g. `company-mcp`), pull `cursor-setup-guide` and **re-copy** those hook files onto your machine (see [global-env.md → Live routing is per-machine](./global-env.md#live-routing-is-per-machine-team-must-refresh)).

Details: [global-env.md](./global-env.md).

---

## 4. Product repo (gold reference)

```bash
gh repo clone Wade-O-Lution-Inc/meeting_notes_workflow
cd meeting_notes_workflow
specify integration status
specify workflow list   # expect: sdd, sdd-remote, upstream speckit
```

Daily SDD driver for that product: `docs/agents/SDD_USER_GUIDE.md`.

---

## 5. Workspace

Open a multi-root window that matches how you work (typical: `meeting_notes_workflow` + `Integrity_Lab` + `repo-index`). See [scope.md](./scope.md) for what each repo owns.

---

## 6. Smoke

- [ ] `specify workflow list` shows `sdd` and `sdd-remote`
- [ ] `python3 ~/.cursor/sdd-orchestrator-ctl/bin/sdd-ctl sync` then `preflight` both exit 0
- [ ] `python3 ~/.cursor/sdd-orchestrator-ctl/bin/sdd-ctl plan-phase --help` exits 0
- [ ] A Cursor chat that triggers skill routing shows an agent message starting with `MANDATORY SKILL ROUTING`
- [ ] (Optional) Doppler: `doppler configs` lists `dev` / `stg` / `prd` / `mac_mini` when linked

---

## Next

- Run SDD: [specify/quick-start.md](./specify/quick-start.md)
- Adopt SDD in another product repo: [specify/bootstrap.md](./specify/bootstrap.md)
