# Overview — Spec Kit vs Wade-O-Lution layers

```mermaid
flowchart TB
  subgraph upstream [Upstream Spec Kit 0.10.2]
    CLI["specify CLI"]
    Init[".specify/ scripts + templates"]
    Skills["Managed speckit-* skills"]
    Bundled["workflow: speckit"]
  end
  subgraph org [Wade-O-Lution customizations]
    WF["workflows: sdd + sdd-remote"]
    Entry["sdd-entry chat front door"]
    Conf["speckit-confidence + confidence-improve"]
    Const["constitution + phase-exits + confidence-checks"]
    Policy[".specify/orchestrator.json"]
  end
  subgraph global [Machine global ~/.cursor]
    Orch["sdd-orchestrator skill"]
    Ctl["sdd-orchestrator-ctl: sdd-ctl + sdd-run"]
    Router["skill router hooks"]
  end
  subgraph artifacts [Feature artifacts]
    Spec["specs/NNN-*/spec.md → plan → tasks"]
    PE["phase-exits.md"]
    CM["confidence.md"]
  end
  CLI --> Init
  Init --> Skills
  Skills --> Entry
  Entry --> Orch
  Orch --> Skills
  Orch --> Ctl
  Ctl --> PE
  WF --> Orch
  Orch --> Spec
  Conf --> CM
  Policy --> Ctl
  Router --> Entry
```

## Three surfaces

| Surface | Command / verb | Who owns gating |
|---------|----------------|-----------------|
| **Chat** | `Start SDD: …` / `Continue SDD` | `sdd-entry` → **`sdd-orchestrator`** (`auto_chain`) |
| **CLI interactive** | `specify workflow run sdd …` | Workflow sequencing + orchestrator `single_phase` per step |
| **CLI headless** | `sdd-run --from-phase … --to-phase …` | Orchestrator control plane only |

Bare `speckit-*` skills are **workers**. They are not a front door.

## What upstream Spec Kit gives you

After `specify init . --integration cursor-agent --here --script sh`:

- `.specify/scripts/bash/` — feature branch + plan/tasks helpers
- `.specify/templates/` — spec, plan, tasks, checklist, constitution templates
- `.cursor/skills/speckit-{specify,clarify,plan,tasks,analyze,implement,constitution,checklist,taskstoissues}/`
- Bundled workflow **`speckit`**: specify → plan → tasks → implement (2 human gates only)
- Optional **`agent-context`** extension
- Preset catalog cache under `.specify/presets/.cache/`

## What we added (org)

| Layer | Customization |
|-------|----------------|
| Workflows | **`sdd`**, **`sdd-remote`** with flags — [templates/spec-kit/](../templates/spec-kit/) |
| Chat entry | **`sdd-entry`** — [templates/skills/sdd-entry/](../templates/skills/sdd-entry/) |
| Phase exits | Binary checklists; **orchestrator** sole writer of `phase-exits.md` |
| Confidence | **`speckit-confidence`**, swarms + advocate via ctl, **`speckit-confidence-improve`** |
| Repo policy | `.specify/orchestrator.json` — [orchestrator.json](../templates/spec-kit/orchestrator.json) |
| Constitution | Compiled from `.cursor/rules/`; SDD quality gates |
| Remote | `sdd-remote` + `remote-agent-handoff` + handoff scripts |
| Global | **`sdd-orchestrator`** + **`sdd-ctl` / `sdd-run`** from GitHub |

## What we deliberately did *not* change

- Spec Kit CLI engine / hash manifests
- Upstream bundled `speckit` workflow (left installed, **undocumented** for daily use)
- Treating this guide as the orchestrator SSOT — that is [sdd-orchestrator](https://github.com/Wade-O-Lution-Inc/sdd-orchestrator)

Cost / shadow / swarm knobs: see [orchestrator.md](./orchestrator.md) and the ctl README after `git pull`.

Next: [quick-start.md](./quick-start.md) · [managed-vs-custom.md](./managed-vs-custom.md)
