# Day-1 machine setup

New laptop or Cloud Agent VM. Works for **any** Wade product repo — you do **not** need meeting_notes_workflow.

Pair with: [ownership.md](./ownership.md) · [product-repo.md](./product-repo.md)

---

## Prerequisites

- [ ] `gh` authenticated to `Wade-O-Lution-Inc`
- [ ] `uv` on `PATH`
- [ ] Cursor Desktop (or Cloud Agent)
- [ ] This guide cloned

Optional later: Doppler (when your product needs secrets) · Tailscale (lab / Mac mini)

---

## 1. Install global harness + orchestrator

```bash
cd cursor-setup-guide
./bin/cursor-setup install-global
./bin/cursor-setup doctor
```

If `doctor` reports missing `sdd-ctl`:

```bash
gh repo clone Wade-O-Lution-Inc/sdd-orchestrator ~/.cursor/sdd-orchestrator-ctl
python3 ~/.cursor/sdd-orchestrator-ctl/bin/sdd-ctl sync
python3 ~/.cursor/sdd-orchestrator-ctl/bin/sdd-ctl preflight
```

`sync` keeps ctl on clean `origin/main` and refreshes `~/.cursor/skills/sdd-orchestrator`. Never leave a feature branch checked out in the runtime clone.

After team router PRs land: `./bin/cursor-setup refresh-global` on **each** machine.

### What the CLI does

| Command | Touches | When |
|---------|---------|------|
| `install-global` | `~/.cursor/hooks*`, `rules/`, pointer stubs under `skills/` | First machine setup |
| `refresh-global` | Overwrites router + global rules from templates | After guide router/rule PRs |
| `doctor` | Read-only checks (+ router unit test) | Anytime |
| `scaffold-repo` | `repo/.cursor/` from `templates/product/` | Bare product repo — [product-repo](./product-repo.md) |
| `adopt-sdd` | `.specify/` + SDD skills (can run `specify init --force`) | Opt-in SDD — [bootstrap](./specify/bootstrap.md) |
| `sync-check` | Compares templates ↔ MNW / `~/.cursor` | **Maintainers** — [SYNC.md](../templates/SYNC.md) |

---

## 2. Smoke

- [ ] `./bin/cursor-setup doctor` exits 0 (WARN on stub skills is OK)
- [ ] `python3 ~/.cursor/sdd-orchestrator-ctl/bin/sdd-ctl preflight` exits 0
- [ ] A Cursor chat that triggers skill routing shows an agent message starting with `MANDATORY SKILL ROUTING`

---

## 3. Open your product repo

Open the repo you actually work in (data-api, integrity-ts, Integrity_Lab, meeting_notes, …).

If it has no `.cursor/` yet → [product-repo.md](./product-repo.md) (`scaffold-repo` + edit `project.mdc`).

Multi-root windows: see [ownership.md](./ownership.md) for what each sibling repo owns.

---

## 4. Optional — Spec Kit / SDD toolchain

Only if you will run Spec Kit features in a product repo:

```bash
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@v0.13.0
specify --version   # 0.13.0 family
```

Then adopt in that repo: [specify/bootstrap.md](./specify/bootstrap.md) or `./bin/cursor-setup adopt-sdd /path/to/repo`.

Daily SDD cheat sheet: [specify/quick-start.md](./specify/quick-start.md).  
Working in MNW: use that repo’s `docs/agents/SDD_USER_GUIDE.md`.

**Optional gold clone** (not required for day-1):

```bash
gh repo clone Wade-O-Lution-Inc/meeting_notes_workflow
```

---

## Next by role

| Role | Next |
|------|------|
| Any eng | [ownership.md](./ownership.md) · code in your product repo |
| Bare / thin harness | [product-repo.md](./product-repo.md) |
| SDD adopter | [specify/bootstrap.md](./specify/bootstrap.md) |
| Company context (FE/sales/PM) | [company-mcp.md](./company-mcp.md) |
| Template maintainer | [templates/SYNC.md](../templates/SYNC.md) |
