# Quick start (daily SDD)

**Pocket card** while running SDD. Working in meeting_notes? Prefer that repo’s [`SDD_USER_GUIDE.md`](https://github.com/Wade-O-Lution-Inc/meeting_notes_workflow/blob/staging/docs/agents/SDD_USER_GUIDE.md).

Passing phases **auto-continue**. Failures repair up to cap, then **stop**. After confidence: expect `sdd-ctl report`.

Phase order (SSOT): [phase-model.md](./phase-model.md) — includes **converge** before confidence.

Machine once: [../day1.md](../day1.md) (optional Spec Kit section) · New repo: [bootstrap.md](./bootstrap.md).

---

## Chat

```
Start SDD: <what and why — no tech stack yet>
Start SDD: <what and why>. Use balanced.
Continue SDD
Continue SDD using frontier.
Show SDD profile.
I've reviewed spec.md — proceed to plan
Revise spec: <feedback>
compact
Stop SDD; switch to normal fix mode for <narrow bug>
```

Natural-language flags: `scope=api`, `stop at plan`, `emit issues`, `remote after tasks`, `test-fix mode`, `Use lean|balanced|frontier`.  
Choose a **profile**, not model IDs — [orchestrator.md](./orchestrator.md).

Flow: `sdd-entry` → `sdd-orchestrator` (`auto_chain`) → `speckit-*` worker.

---

## Three CLI recipes

```bash
# Status
specify workflow list          # expect sdd + sdd-remote

# Full local cycle
specify workflow run sdd -i spec="..." -i integration=cursor-agent \
  -i model_profile=balanced

# Stop early (RFC-style)
specify workflow run sdd -i spec="..." -i stop_at=plan

# Laptop → Mac mini
specify workflow run sdd-remote -i spec="..." -i remote_phase=implement -i interval=600
```

Flags, deprecated aliases, headless `sdd-run`: [workflows.md](./workflows.md) · [orchestrator.md](./orchestrator.md) · [remote-handoff.md](./remote-handoff.md).

Upstream workflow **`speckit`**: installed, not for daily use.
