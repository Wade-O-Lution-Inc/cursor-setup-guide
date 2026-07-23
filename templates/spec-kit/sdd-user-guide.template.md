# SDD User Guide

**Keep this file open** while learning Spec-Driven Development (SDD) in this repo.

Deep reference: [SPEC_DRIVEN_DEVELOPMENT.md](./SPEC_DRIVEN_DEVELOPMENT.md)

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
| `model_profile` | `lean` \| `balanced` \| `frontier` | Cost/reliability intent (default `balanced`) |
| `transfer_only` | on `sdd-remote` | Skip laptop phases; handoff only |

`persona_comms` (in `.specify/orchestrator.json`) is independent of
`model_profile`. Channels — dissent resolution, repair dialogue, and
cross-phase carry-forward — use the same caps under lean / balanced /
frontier / legacy. Defaults in the orchestrator ctl are fail-closed
(`enabled: false`); this repo enables them for analyze/converge carry-forward
plus bounded dissent/repair rounds. Transcripts land in
`.specify/orchestrator-runs/<feature>.messages.jsonl` via `sdd-ctl relay` /
`record` (no LLM).

```bash
specify workflow run sdd -i spec="..." -i integration=cursor-agent \
  -i scope=full -i stop_at=confidence -i issues=false -i mode=full \
  -i model_profile=balanced

specify workflow run sdd-remote -i spec="..." -i remote_phase=implement \
  -i interval=600 -i model_profile=lean
```

Registered workflows are `sdd`, `sdd-remote`, and upstream `speckit`.

---

## One-time setup

```bash
uv tool install specify-cli --from git+https://github.com/github/spec-kit.git@v0.13.0
gh repo clone Wade-O-Lution-Inc/sdd-orchestrator ~/.cursor/sdd-orchestrator-ctl
# Always track main (never leave a feature branch checked out on operator hosts)
git -C ~/.cursor/sdd-orchestrator-ctl checkout main
python3 ~/.cursor/sdd-orchestrator-ctl/bin/sdd-ctl sync
mkdir -p ~/.cursor/skills
# sync refreshes the skill symlink; keep this for first-time boots before sync:
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

**Keep every machine on `origin/main`.** Start/Continue SDD runs
`sdd-ctl sync` then `sdd-ctl preflight`. `plan-phase` fails closed if the
install is dirty, not on `main`, or not identical to `origin/main`.

```bash
python3 ~/.cursor/sdd-orchestrator-ctl/bin/sdd-ctl sync
python3 ~/.cursor/sdd-orchestrator-ctl/bin/sdd-ctl preflight
```

Do not develop ctl changes inside the runtime clone — use a separate worktree.
Ctl developers may set `SDD_CTL_SKIP_INSTALL_PREFLIGHT=1` locally only.

Constitution: `.specify/memory/constitution.md`. Mac mini handoff setup: [`.cursor/skills/remote-agent-handoff/SKILL.md`](../../.cursor/skills/remote-agent-handoff/SKILL.md) (`CURSOR_API_KEY` in Doppler `mac_mini`).

---

## Chat cheat sheet

```
Start SDD: <what and why — no tech stack yet>
Start SDD: <what and why>. Use balanced.
Continue SDD
Continue SDD using frontier.
Show SDD profile.
Explain current SDD routing.
Revise spec: <feedback>
compact
Stop SDD; switch to normal fix mode for <narrow bug>
```

Optional: `scope=api`, `stop at plan`, `emit issues`, `remote after tasks`,
`test-fix mode`, `Use lean|balanced|frontier`.

### Model profiles

| Profile | When to use |
|---------|-------------|
| `lean` | Cheap clarify/tasks-heavy exploration |
| `balanced` | Default (evaluated ctl default; repo policy) |
| `frontier` | Highest correctness priority |

Choose a **profile**, not individual model IDs. Precedence: chat/CLI session →
feature pin → `.specify/orchestrator.json` → ctl default. Mid-feature switches
need an explicit confirmation. Full matrix lives in
`~/.cursor/sdd-orchestrator-ctl/phase-models.json` (do not duplicate here).

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

Laptop: specify → clarify → plan → tasks auto-continue through the orchestrator. Mini: implement → converge → confidence via `sdd-remote` / handoff scripts (specify-cli ≥ 0.13.0 on the mini).

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
5. **Converge** — assess code vs spec/plan/tasks; append-only Convergence tasks if gaps remain. May re-enter implement up to **2** rounds, then advances to confidence (residual gaps named).
6. **Confidence** — scores 1–5 (complexity inverted); loops ≤3; writes `confidence.md`.

Requires `specify-cli` **v0.13.0+**. Upgrade CLI with `specify self upgrade --tag v0.13.0`.

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
| Converge | append-only Convergence section in `tasks.md` (or no change) |
| Confidence | `confidence.md` |
| Every phase | `phase-exits.md` |
| Always | `.cursor/auto-context.md` Spec Progress |

---

## Other teams / other repos

This guide is the **product** quick start. The engine is shared:

1. Machine once — [cursor-setup-guide docs/day1.md](https://github.com/Wade-O-Lution-Inc/cursor-setup-guide/blob/main/docs/day1.md) (`./bin/cursor-setup install-global` + `sdd-ctl sync` → clean `main`).
2. New Spec Kit product — [`cursor-setup adopt-sdd`](https://github.com/Wade-O-Lution-Inc/cursor-setup-guide/blob/main/docs/specify/bootstrap.md) + ctl [ADOPTION.md](https://github.com/Wade-O-Lution-Inc/sdd-orchestrator/blob/main/docs/ADOPTION.md).
3. Copy/adapt `.specify/orchestrator.json` (including optional `persona_comms`) and repo-local `sdd-entry`; do **not** vendor `lib/` or `phase-models.json`.
4. Mac mini / Cloud Agents — same `sync` + `preflight` before remote SDD.

Architecture boundaries: [SPEC_DRIVEN_DEVELOPMENT.md](./SPEC_DRIVEN_DEVELOPMENT.md).

---

## Stuck?

| Problem | Fix |
|---------|-----|
| Wrong branch | `git checkout NNN-feature-name` |
| Skipped clarify | Continue SDD → clarify before plan |
| Interactive workflow paused | `specify workflow resume <run_id>` |
| Repair cap exhausted | Fix the failing artifact, then `Continue SDD` — retries the **same** failing phase (do not implement off-chain). Early phases use `repair_cap: 2` in `.specify/orchestrator.json` so the escalated attempt runs before stop. |
| Ctl preflight fails | `sdd-ctl sync` — install must be clean `origin/main` (not a feature branch) |
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
- Leave `~/.cursor/sdd-orchestrator-ctl` on a feature branch
- Merge to staging without pytest + ruff green
