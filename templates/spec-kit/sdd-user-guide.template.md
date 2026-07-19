# SDD User Guide

<!-- Template synced from meeting_notes_workflow/docs/agents/SDD_USER_GUIDE.md — see templates/SYNC.md.
     After copy: adapt Doppler/lint/test commands and deep-reference links for this repo.
     Optional deep reference: docs/agents/SPEC_DRIVEN_DEVELOPMENT.md (create or omit). -->

**Keep this file open** while learning Spec-Driven Development (SDD) in this repo.

Deep reference (if present): [SPEC_DRIVEN_DEVELOPMENT.md](./SPEC_DRIVEN_DEVELOPMENT.md) · org adoption: [cursor-setup-guide/specify/](https://github.com/Wade-O-Lution-Inc/cursor-setup-guide/tree/main/specify)

---

## Kickoff (one screen)

SDD turns multi-step features into reviewable markdown (`spec.md` → `plan.md` → `tasks.md`) before code. Skip it for one-line fixes.

| Surface | Verb / ID | What it does |
|---------|-----------|--------------|
| **Chat** | `Start SDD: <what/why>` | New feature → `sdd-entry` → orchestrator **specify** |
| **Chat** | `Continue SDD` | Resume feature dir → next ungated phase via orchestrator |
| **CLI** | `specify workflow run sdd …` | Local auto-continuing cycle (flags below) |
| **CLI** | `specify workflow run sdd-remote …` | Laptop through tasks, then Mac mini implement/confidence |

The standalone `Wade-O-Lution-Inc/sdd-orchestrator` engine is cloned at
`~/.cursor/sdd-orchestrator-ctl`. In Cursor, the UI Task driver dispatches
visible worker/judge tasks (and independent expert swarms when policy requests
them); deterministic `bin/sdd-ctl` plans hooks, records verdicts, and is the
sole writer of `phase-exits.md`. Bare `speckit-*` is the worker procedure only.
Headless twin: `~/.cursor/sdd-orchestrator-ctl/bin/sdd-run`.

Passing phases auto-continue with no human phase pauses. A failed phase repairs
up to its configured cap, then stops and reports. To pause after passing phases,
set `"gate_mode": "interactive"` in `.specify/orchestrator.json`. After the
terminal phase, `sdd-ctl report` produces the end report.

### Flags (CLI `sdd` / chat NL)

| Flag | Values | Meaning |
|------|--------|---------|
| `scope` | `full` \| `api-only` \| `frontend-only` | What layers the plan/tasks may touch |
| `stop_at` | `confidence` \| `tasks` \| `plan` | Early exit (RFC ≈ `plan` or `tasks`) |
| `issues` | `true` \| `false` | After tasks, emit GitHub issues and stop |
| `mode` | `full` \| `test-fix` | `test-fix` = implement + pytest retry + confidence |
| `transfer_only` | on `sdd-remote` | Skip laptop phases; handoff only |

```bash
specify workflow run sdd -i spec="..." -i integration=cursor-agent \
  -i scope=full -i stop_at=confidence -i issues=false -i mode=full

specify workflow run sdd-remote -i spec="..." -i remote_phase=implement -i interval=600
```

Registered workflows are `sdd`, `sdd-remote`, and upstream `speckit`.

---

## One-time setup

```bash
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@v0.10.2
gh repo clone Wade-O-Lution-Inc/sdd-orchestrator ~/.cursor/sdd-orchestrator-ctl
mkdir -p ~/.cursor/skills
ln -sfn ~/.cursor/sdd-orchestrator-ctl/skills/sdd-orchestrator ~/.cursor/skills/sdd-orchestrator
specify integration status
specify workflow list   # expect sdd + sdd-remote + speckit
```

Interactive Cursor UI runs need no additional dependency. For unattended
`sdd-run` use, create its SDK environment once:

```bash
cd ~/.cursor/sdd-orchestrator-ctl
uv venv .venv
uv pip install --python .venv/bin/python cursor-sdk
```

Update the shared engine with
`git -C ~/.cursor/sdd-orchestrator-ctl pull --ff-only`.

Constitution: `.specify/memory/constitution.md`. Mac mini handoff setup: [`.cursor/skills/remote-agent-handoff/SKILL.md`](../../.cursor/skills/remote-agent-handoff/SKILL.md) (`CURSOR_API_KEY` in Doppler `mac_mini`).

---

## Chat cheat sheet

```
Start SDD: <what and why — no tech stack yet>
Continue SDD
Revise spec: <feedback>
compact
Stop SDD; switch to normal fix mode for <narrow bug>
```

Optional: `scope=api`, `stop at plan`, `emit issues`, `remote after tasks`, `test-fix mode`.

---

## Terminal cheat sheet

```bash
specify workflow run sdd -i spec="..." -i integration=cursor-agent
specify workflow run sdd -i spec="..." -i stop_at=plan
specify workflow run sdd -i spec="..." -i mode=test-fix
specify workflow run sdd -i spec="..." -i issues=true -i stop_at=tasks

specify workflow status
specify workflow resume <run_id>

uv run ruff check
doppler run -- uv run python -m pytest tests/ -x -q

specify workflow run sdd-remote -i spec="..." -i remote_phase=implement -i interval=600
specify workflow run sdd-remote -i transfer_only=true -i remote_phase=confidence -i interval=600

bash scripts/remote_agent_preflight.sh
bash scripts/handoff_to_mac_mini.sh --sdd-implement --interval 600
bash scripts/handoff_to_mac_mini.sh --status
```

---

## Long runs / close laptop

Laptop: specify → clarify → plan → tasks auto-continue through the orchestrator. Mini: implement + confidence via `sdd-remote` / handoff scripts.

| Step | Where | Action |
|------|-------|--------|
| 1 | Laptop | `sdd-remote` through tasks/analyze (or chat through tasks) |
| 2 | Laptop | Preflight runs and starts the requested remote handoff |
| 3 | Anywhere | Close laptop — loop on mini |
| 4 | Anywhere | `bash scripts/handoff_to_mac_mini.sh --status` |
| 5 | Laptop | `git pull` + `.cursor/session-handoff.md` |

Runtime on mini (gitignored): `.cursor/remote-agent.pid`, `.cursor/remote-agent-state.json`, `.cursor/session-handoff.md`, `logs/remote-agent.log`.

---

## Phase walkthrough

1. **Specify** — branch `NNN-*`, `spec.md`. No stack, no code.
2. **Clarify** — before plan on multi-boundary work.
3. **Plan / tasks / analyze** — `plan.md`, `tasks.md`, consistency check. Honor `stop_at`.
4. **Implement** — only with `tasks.md`; mark `[X]`; ruff + pytest.
5. **Confidence** — scores 1–5 (complexity inverted); loops ≤3; writes `confidence.md`.

After each validated phase, only `sdd-ctl record` appends one line to
`specs/NNN-*/phase-exits.md`; workers never write it. The repair cap stops a
persistently failing phase. Confidence completion produces an `sdd-ctl report`
end report. PR: `NNN-*` → **staging**.

| Phase | Watch |
|-------|--------|
| Specify | `spec.md` |
| Plan | `plan.md`, `research.md`, `confidence-checks.md` |
| Tasks | `tasks.md` |
| Implement | app code + `[X]` |
| Confidence | `confidence.md` |
| Every phase | `phase-exits.md` |
| Always | `.cursor/auto-context.md` Spec Progress |

---

## Stuck?

| Problem | Fix |
|---------|-----|
| Wrong branch | `git checkout NNN-feature-name` |
| Skipped clarify | Continue SDD → clarify before plan |
| Interactive workflow paused | `specify workflow resume <run_id>` |
| Repair cap exhausted | Read the end report, resolve the blocker, then resume |
| Tests fail | `sdd -i mode=test-fix` or fix in chat |
| Context full | `compact` |
| Closing laptop | `sdd-remote` |
| Remote won't start | `bash scripts/remote_agent_preflight.sh --remote` |

## Do not

- SDD for hotfixes / single-file changes
- Treat `specs/` as product docs
- Skip clarify on multi-boundary features
- Implement before `tasks.md`
- Call bare `speckit-*` as the chat front door (use `sdd-entry` → orchestrator)
- Merge to staging without pytest + ruff green
