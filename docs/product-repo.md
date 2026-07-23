# Product repo harness

Add or adapt Cursor harness on any Wade product repo **without** cloning meeting_notes first.

---

## When you need this

- Repo has no `.cursor/`, or only ad-hoc files
- You want the security hook baseline + starter rules
- Later: optional Spec Kit / SDD

---

## Scaffold — what you get

```bash
cd /path/to/cursor-setup-guide
./bin/cursor-setup scaffold-repo /path/to/your-repo
```

| Lands in `your-repo/.cursor/` | Notes |
|------------------------------|--------|
| `rules/*.mdc` | Pedagogy starters — see [starter vs gold](./ownership.md#starter-pack-vs-gold-important) |
| `hooks.json` + security trio + `refresh-compact-context.sh` | Wired by default |
| `hooks/orchestrator-*.sh` | **Scripts only** — not wired; add to `hooks.json` if you want staging-first / mixed-concern observation |
| `mcp.json` | Placeholder |
| `example-skill/`, `search-first-skill/` | Pedagogy — not required in production |

Then:

1. Edit `.cursor/rules/project.mdc` for **this** codebase (entry points, commands, PR target).
2. Commit `.cursor/`.

`scaffold-repo` chmod’s copied `*.sh`. Re-run with `--force` only when you intend to overwrite.

### Gold dual-router note

meeting_notes also wires a **repo** `route-skills-before-prompt.sh` that delegates to the global router with `WADE_REPO_KEY=…`. The scaffold baseline relies on the **global** router alone. Copy the MNW wrapper pattern only if you need repo-specific routing keywords.

---

## Adopt SDD (optional)

Warn: `adopt-sdd` may run `specify init --force` and overwrite Spec Kit-managed files. Use on a clean/ intentional adopt.

```bash
./bin/cursor-setup adopt-sdd /path/to/your-repo \
  --lint-cmd 'YOUR_LINT_CMD' \
  --test-cmd 'YOUR_TEST_CMD'
```

Use stack-appropriate commands (not only Python). Then:

1. Merge `sdd-orchestrator-snippet.mdc` into your repo orchestrator / always-on routing rule (or keep as a separate always-on rule).
2. Copy `templates/spec-kit/sdd-user-guide.template.md` → your docs path (e.g. `docs/agents/SDD_USER_GUIDE.md`).
3. `specify workflow list` → expect `sdd`, `sdd-remote`.

Full runbook: [specify/bootstrap.md](./specify/bootstrap.md) · daily: [specify/quick-start.md](./specify/quick-start.md).

---

## Compare to gold (optional)

Maintainers / curious adopters:

```bash
./bin/cursor-setup sync-check --mnw /path/to/meeting_notes_workflow
```

MNW is the mature reference for SDD + Company MCP — not a day-1 dependency. Ops skills (Doppler, Fireflies, …) live in gold; copy from MNW into your repo only if you need them.
