# Always-on orchestrator

Every Spec Kit phase transition goes through the **global** multi-model orchestrator. Project workflows and `sdd-entry` only *invoke* it; they do not replace it.

**Runtime SSOT:** [Wade-O-Lution-Inc/sdd-orchestrator](https://github.com/Wade-O-Lution-Inc/sdd-orchestrator) cloned at `~/.cursor/sdd-orchestrator-ctl`. Do not copy a private tree from another laptop as the primary install — clone and `git pull`.

| Path | Location |
|------|----------|
| Interactive skill (Task driver) | `~/.cursor/skills/sdd-orchestrator/SKILL.md` (symlink into ctl) |
| Control plane | `~/.cursor/sdd-orchestrator-ctl/` |
| Deterministic CLI | `~/.cursor/sdd-orchestrator-ctl/bin/sdd-ctl` |
| Headless SDK CLI | `~/.cursor/sdd-orchestrator-ctl/bin/sdd-run` |
| Operator README | ctl `README.md` / GitHub README |

Machine bootstrap: [../day1-setup.md](../day1-setup.md) · [../global-env.md](../global-env.md).

## Driver modes

| Mode | When | Sequencing |
|------|------|------------|
| `auto_chain` | Chat **Start SDD** / **Continue SDD** | Orchestrator advances phases on `continue` |
| `single_phase` | Spec Kit workflow names one phase | Return after that phase; workflow owns `stop_at` / transfer |

## Loop (Task path)

1. `sdd-ctl plan-phase` — resolve policy, render prompts, emit worker / judge / expert / advocate / shadow requests  
2. **Worker Task** — model from plan; follows matching `speckit-*` skill  
3. `sdd-ctl hooks` — D-hooks + optional implement commands (**no LLM**)  
4. **Judge or swarm** — ordinary judge, or independent experts + merge (analyze / confidence); optional advocate; optional shadow sample  
5. `sdd-ctl record` — sole writer of `phase-exits.md` + JSONL under `.specify/orchestrator-runs/`  
6. Obey action: `continue` | `repair` | `stop` | `pause` (interactive only)  
7. After confidence: `sdd-ctl report`

Anti-patterns: pasting chat history into Tasks; worker self-judging; worker writing `phase-exits.md`; skipping D-hooks.

## `sdd-ctl` verbs

```bash
python3 ~/.cursor/sdd-orchestrator-ctl/bin/sdd-ctl plan-phase \
  --repo-root /repo --feature-dir /repo/specs/NNN-feature --phase plan \
  --feature-description "what and why"   # required for new specify

python3 ~/.cursor/sdd-orchestrator-ctl/bin/sdd-ctl hooks \
  --repo-root /repo --feature-dir /repo/specs/NNN-feature --phase plan

python3 ~/.cursor/sdd-orchestrator-ctl/bin/sdd-ctl record \
  --repo-root /repo --verdict-file /tmp/verdict.json

python3 ~/.cursor/sdd-orchestrator-ctl/bin/sdd-ctl report \
  --repo-root /repo --feature-dir /repo/specs/NNN-feature
```

`sdd-ctl` uses only the Python stdlib, makes **no** LLM/API calls, and needs no API key.

## Gates (current model)

Default `gate_mode` is **`automatic`**:

| Verdict outcome | Action |
|-----------------|--------|
| Pass | `continue` (auto-chain) or return to workflow (`single_phase`) |
| Fail, repairs remaining | `repair` with concrete failure context |
| Fail at repair cap | `stop` — escalate to human |
| Pass with `"gate_mode": "interactive"` in repo policy | `pause` |

There are **no** routine per-phase hard-gate human pauses in the orchestrator. Spec Kit workflow YAML may still define human gates (`review-spec`, etc.) — those are separate ([workflows.md](./workflows.md)).

## Repo policy

Optional `.specify/orchestrator.json` deep-merges over ctl defaults:

```json
{
  "gate_mode": "automatic",
  "allow_repo_commands": true,
  "implement_hooks": [
    "uv run ruff check",
    "doppler run -- uv run python -m pytest tests/ -x -q"
  ]
}
```

`implement_hooks` run only when `allow_repo_commands: true` is set in that same file (explicit trust boundary). Template: [../templates/spec-kit/orchestrator.json](../templates/spec-kit/orchestrator.json).

## Swarms, advocate, shadow

Configured in ctl `phase-models.json` (edit carefully; full tables live in the ctl README, not here):

| Pattern | Behavior |
|---------|----------|
| Analyze swarm | Worker + independent experts + merge (no ordinary single judge) |
| Confidence swarm | Worker + experts + **mandatory** advocate + merge |
| Advisory advocate | May run on clean non-swarm passes when configured |
| Shadow judge | Sampled alternative judge; advisory disagreement in report |

## Cost envelope (locked in ctl)

From the live ctl README (re-read after `git pull`):

- Ordinary phase: 1 worker + 1 judge; configured advocate may add one clean-pass call  
- Repairs: +calls up to `repair_cap` (implement and confidence often higher)  
- Analyze / confidence swarms cost more than a single judge  
- Shadow: sampled (advisory), not a happy-path requirement  

Do **not** invent a “2 LLM calls / phase forever” rule in adopters’ docs — swarms break that.

## Headless twin of Continue

```bash
~/.cursor/sdd-orchestrator-ctl/.venv/bin/python \
  ~/.cursor/sdd-orchestrator-ctl/bin/sdd-run \
  --cwd /path/to/repo \
  --feature-dir specs/NNN-name \
  --from-phase specify --to-phase tasks \
  --feature-description "what and why"
# --mock for structural smoke without CURSOR_API_KEY
```

Requires `CURSOR_API_KEY` for non-mock runs. Prefer the ctl venv (`cursor-sdk`); do not `pip install` into Homebrew Python. Interactive Cursor UI needs **no** SDK venv.

## What you customize where

| Knob | Where |
|------|-------|
| Models, repair_cap, swarm roles, shadow_rate | ctl `phase-models.json` (+ optional repo `phases` overrides) |
| Gate auto vs pause-after-pass | `.specify/orchestrator.json` → `gate_mode` |
| Implement lint/test commands | `.specify/orchestrator.json` → `implement_hooks` + `allow_repo_commands` |
| Checklists / prompts | ctl `checklists/`, `prompts/` |
| Promotion eval criteria | ctl `promotion-thresholds.json` |

Next: [phase-model.md](./phase-model.md) · [managed-vs-custom.md](./managed-vs-custom.md)
