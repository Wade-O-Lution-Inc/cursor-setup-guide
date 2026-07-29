# Orchestrator — invoke and configure

Every Spec Kit phase transition goes through the **global** multi-model orchestrator. Product workflows and `sdd-entry` only *invoke* it.

**Runtime SSOT:** [sdd-orchestrator](https://github.com/Wade-O-Lution-Inc/sdd-orchestrator) at `~/.cursor/sdd-orchestrator-ctl` · always `sdd-ctl sync` → clean `origin/main`.  
**Operator matrices / cost tables:** ctl `README.md` (re-read after sync).  
**Machine install:** [../day1.md](../day1.md) · **Phases:** [phase-model.md](./phase-model.md)

| Path | Location |
|------|----------|
| Interactive skill | `~/.cursor/skills/sdd-orchestrator` (symlink via sync) |
| Control plane | `~/.cursor/sdd-orchestrator-ctl/` |
| `sdd-ctl` / `sdd-run` | `bin/` under ctl |
| Any-repo adoption | ctl [ADOPTION.md](https://github.com/Wade-O-Lution-Inc/sdd-orchestrator/blob/main/docs/ADOPTION.md) |

---

## Driver modes

| Mode | When | Sequencing |
|------|------|------------|
| `auto_chain` | Chat **Start / Continue SDD** | Advances on `continue` |
| `single_phase` | Workflow names one phase | Returns; workflow owns `stop_at` |

## Loop (Task path)

0. `sdd-ctl sync` + `preflight`  
1. `plan-phase` — policy, prompts, role requests  
2. **Worker Task** — matching `speckit-*`  
3. `hooks` — D-hooks + optional implement commands (**no LLM**)  
4. **Judge or swarm** (+ optional advocate / shadow)  
5. Optional **persona_comms** when enabled in repo policy  
6. `record` — sole writer of `phase-exits.md` + run JSONL  
7. Action: `continue` \| `repair` \| `stop` \| `pause`  
8. After confidence: `report`

Anti-patterns: pasting chat into judges; worker writing `phase-exits.md`; dirty ctl feature branch.

## Model profiles

`lean` · `balanced` (default) · `frontier` (+ `legacy`).  
Precedence: session → feature pin → `.specify/orchestrator.json` `model_profile` → ctl default.  
Live role matrix: ctl `phase-models.json` only.

## Repo policy

`.specify/orchestrator.json` deep-merges over ctl defaults. Template: [../../templates/spec-kit/orchestrator.json](../../templates/spec-kit/orchestrator.json).

```json
{
  "gate_mode": "automatic",
  "model_profile": "balanced",
  "allow_repo_commands": true,
  "implement_hooks": ["YOUR_LINT", "YOUR_TEST"],
  "persona_comms": {
    "dissent_resolution": { "enabled": true, "dissent_rounds": 1 },
    "repair_dialogue": { "enabled": true, "repair_questions": 1 },
    "carry_forward": { "enabled": true, "phases": ["analyze", "converge"] }
  }
}
```

`implement_hooks` run only when `allow_repo_commands: true` (trust boundary). Use **your** stack’s commands.

### `persona_comms`

Orthogonal to `model_profile`. Ctl defaults fail-closed off; product repos opt in. Channels: dissent resolution, repair dialogue, carry-forward. Transcripts: `.specify/orchestrator-runs/<feature>.messages.jsonl`.

## Gates

Default `gate_mode: automatic` → pass=`continue`, fail=`repair` until cap then `stop`. Spec Kit YAML human gates are separate ([workflows.md](./workflows.md)).

Do **not** document an alternate interactive gate-mode router as live until ctl feature **003** ships; today’s `gate_mode` is still `automatic` | `interactive` pause-on-fail only.

## Repair caps (repo overlays)

Ctl defaults (`phase-models.json`): most phases `1`; **implement** and **confidence** `2`; **analyze** and **converge** pinned at **1**.

The adopt template raises early phases (specify→tasks) to `2` for an escalated attempt, and keeps **analyze/converge at 1**. Do not raise late-phase caps in repo policy unless you knowingly override the late-phase pin from the 2026-07-29 eval remediation.

## Swarms / cost

Analyze and confidence may use expert swarms; shadow judges are advisory. **Do not** document a fixed “2 LLM calls / phase” rule — see ctl README after `sdd-ctl sync`.

**Interactive swarm dispatch:** when `plan-phase` returns multiple expert roles, the interactive skill must issue **all expert Task dispatches in one message** (`dispatch_mode: "concurrent"`). Sequential expert Tasks forfeit the concurrency barrier — wall time becomes the sum of role latencies (see ctl `gate-reports/e2e-perf-eval-2026-07-29.md` §5 and skill step 7).

### Verdict fields (record)

Every `sdd-ctl record` verdict **MUST** include:

| Field | Rule |
|-------|------|
| `attempt_kind` | Required enum: `initial` \| `repair` \| `rejudge` \| `escalated` (fail-closed) |
| `wall_s` | Non-negative finite seconds from real start/end timestamps (not minute buckets) |
| `dispatch_mode` | Required on swarm phases: `concurrent` \| `sequential`; omit for non-swarm |

## Headless Continue

```bash
# Requires ctl venv + CURSOR_API_KEY for non-mock; interactive UI needs neither
~/.cursor/sdd-orchestrator-ctl/.venv/bin/python \
  ~/.cursor/sdd-orchestrator-ctl/bin/sdd-run \
  --cwd /path/to/repo --feature-dir specs/NNN-name \
  --from-phase specify --to-phase tasks \
  --feature-description "what and why"
```

## What you customize where

| Knob | Where |
|------|-------|
| Profile / persona / gate_mode / implement_hooks | Repo `.specify/orchestrator.json` |
| Role matrices, swarm, shadow_rate, repair caps | ctl `phase-models.json` (+ optional repo `phases` overrides) |
| Checklists / prompts | ctl `checklists/`, `prompts/` |
| Engine version | `sdd-ctl sync` |

Useful verbs: `plan-phase`, `hooks`, `record`, `report`, `messages` — `sdd-ctl --help`.

Next: [managed-vs-custom.md](./managed-vs-custom.md) · [confidence-loop.md](./confidence-loop.md)
