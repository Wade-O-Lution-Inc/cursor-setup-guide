# Always-on orchestrator

Every Spec Kit phase transition goes through the **global** multi-model orchestrator. Project workflows and `sdd-entry` only *invoke* it; they do not replace it.

| Path | Location |
|------|----------|
| Interactive skill (Task worker + judge) | `~/.cursor/skills/sdd-orchestrator/SKILL.md` |
| Control plane | `~/.cursor/sdd-orchestrator-ctl/` |
| Headless CLI | `~/.cursor/sdd-orchestrator-ctl/bin/sdd-run` |
| Operator README | `~/.cursor/sdd-orchestrator-ctl/README.md` |

Machine bootstrap: [../global-env.md](../global-env.md).

## Loop (Task path)

1. **Worker Task** — model from `phase-models.json`; follows matching `speckit-*` skill  
2. **Deterministic hooks (D-first)** — `diff_risks`, blast radius, and for implement also lint/test — **no LLM**  
3. **Judge Task** — blind fail-seeking; different model; outputs verdict JSON only  
4. **Validate** → append `phase-exits.md` → JSONL under `runs/` → apply hard/soft gate / repair  

Anti-patterns: pasting chat history into Tasks; worker self-judging; worker writing `phase-exits.md`; skipping D-hooks.

## Phase policy (live defaults)

From `~/.cursor/sdd-orchestrator-ctl/phase-models.json` (edit carefully; this is the customization surface for models/gates):

| Phase | Worker (default) | Judge (default) | Gate | repair_cap |
|-------|------------------|-----------------|------|------------|
| specify | claude-opus-4-8-thinking-high | claude-sonnet-5-thinking-high | hard | 1 |
| clarify | cursor-grok-4.5-high-fast | claude-sonnet-5-thinking-high | soft | 1 |
| plan | claude-opus-4-8-thinking-high | claude-sonnet-5-thinking-high | hard | 1 |
| tasks | cursor-grok-4.5-high-fast | claude-sonnet-5-thinking-high | hard | 1 |
| analyze | claude-opus-4-8-thinking-high | claude-opus-4-8-thinking-high | soft | 1 |
| implement | gpt-5.3-codex | claude-sonnet-5-thinking-high | hard | 2 |
| confidence | claude-opus-4-8-thinking-high | claude-opus-4-8-thinking-high | hard | 1 |

Also in ctl: `checklists/`, `prompts/`, `schemas/judge-verdict.schema.json`, `lib/`, `promotion-thresholds.json`, `bin/sdd-orchestrator-promote`.

## Cost envelope (locked)

- Happy path: **2 LLM calls per phase** (worker + judge)  
- Each repair: +2 calls, capped by `repair_cap`  
- **`shadow: false`, `epsilon: 0.0`** until Slice D human approval — do not enable from the skill  

## Headless twin of Continue

```bash
~/.cursor/sdd-orchestrator-ctl/.venv/bin/python \
  ~/.cursor/sdd-orchestrator-ctl/bin/sdd-run \
  --cwd /path/to/repo \
  --feature-dir specs/NNN-name \
  --from-phase specify --to-phase tasks
# --mock for structural smoke without CURSOR_API_KEY
```

Requires `CURSOR_API_KEY` for non-mock runs. Prefer the ctl venv (has `cursor-sdk`); do not `pip install` into Homebrew Python.

## What you can customize here

| File / knob | Safe change |
|-------------|-------------|
| `phase-models.json` | Models, gate hard/soft, repair_cap, deterministic_hooks lists |
| `checklists/<phase>.md` | Binary checklist items for the judge |
| `prompts/<phase>.md` + `-judge.md` | Worker / judge instructions |
| `promotion-thresholds.json` | Slice A–D eval criteria |

Do **not** re-enable shadow/epsilon without an explicit Slice D GO.

Next: [phase-model.md](./phase-model.md) · [managed-vs-custom.md](./managed-vs-custom.md)
