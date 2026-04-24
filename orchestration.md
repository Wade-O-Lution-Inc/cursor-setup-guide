# Orchestration

How to make Cursor pick the right specialist behavior for each request **without** loading every rule mentally every time.

## The problem

If you write a rule per engineering concern (think-first, stay-in-scope, surgical changes, simplest-working-pattern, testing, security, git, environment, deployment, …) and mark them all `alwaysApply: true`, you get:

- A ~15K–50K character preamble on every session.
- An agent that tries to apply every rule to every edit, which slows routing and sometimes produces conflicting advice.
- Rules that drift out of sync with each other (two rules end up with subtly different "scope traps" lists).

Dropping rules to `alwaysApply: false` with description-based triggers doesn't fully solve it — the agent has to decide *which* rule the description matches, and niche rules get pulled in for tasks they don't cover.

## The pattern: implicit mode routing

Add one small `alwaysApply: true` rule that acts as a router:

1. **Classify the request** into a small fixed set of modes (silent, 1 line, internal).
2. **Adopt that mode's behavior** — point at the corresponding specialist rule or skill, don't replay all of them.
3. **Ask a clarifying question only when routing confidence is low.**

The classification is invisible. The user says "add a feature flag for X" → the orchestrator routes to IMPLEMENT → the agent looks at `project.mdc` for the pattern and `engineering-discipline.mdc` for scope/surgical-edit discipline → writes the feature with tests.

The specialist rules don't need to announce themselves or recap the mode. They just contain the content that's relevant when that mode is active.

## Suggested modes

| Mode | Trigger signals | Primary references |
|---|---|---|
| **IMPLEMENT** | new feature, endpoint, component, migration, config flag, "add", "build", "wire up" | `project.mdc` pattern catalog, `engineering-discipline.mdc`, `testing-conventions.mdc` |
| **REFACTOR** | "rename", "extract", "move", "clean up", "simplify", "dedupe"; no behavior change intended | `engineering-discipline.mdc` (surgical edits), existing tests |
| **DEBUG** | "broken", "failing", error trace, unexpected behavior, "why is …", "it used to work" | `git log`, caller analysis, the service's tests |
| **DOCS** | "document", "README", "diagram", "explain in the docs" | docs index, `project.mdc`, architecture-diagram skill |
| **TEST** | "add tests", "cover", "reproduce the bug in a test" | `testing-conventions.mdc`, `conftest`/fixture patterns |
| **HANDOFF** | "compact", "checkpoint", "handoff", "resume packet", "prep next session" | `compact-handoff.mdc`, `.cursor/auto-context.md` |
| **OPS** | secrets, live DB state, deploy, integration backfill, monitoring, CI | matching skill in `.cursor/skills/` |

You can add or rename modes — but keep the set small. The more modes you have, the more often routing is ambiguous.

## Escalation triggers

Put explicit escalation triggers in the orchestrator so the agent stops and asks instead of silently picking wrong:

- Request could reasonably be IMPLEMENT or REFACTOR and the distinction changes the blast radius.
- Task spans 3+ service boundaries (API + frontend + migrations, for example).
- A security finding surfaces mid-task.

## What the orchestrator does NOT do

- It does not replay every rule at each step. Specialist rules stay lazy-loaded mentally.
- It does not narrate the classification unless asked. One-mode routing stays implicit.
- It does not invent a new mode. If nothing fits, ask.

## Pairing: skills own operational procedures

OPS mode exists specifically so operational workflows route to skills, not rules. Skills have room for the step-by-step detail ("to sync a dashboard, run X; if it fails check Y") that would bloat a rule if kept always-on.

Typical OPS skills in a production repo:

- Secret-manager CLI (Doppler, 1Password, Vault).
- Database CLI (Supabase, `psql`, Prisma).
- Deployment / infra (Railway, Fly.io, Docker Compose, Terraform, Grafana Cloud).
- Integration troubleshooting (webhook ingest, scheduled jobs, third-party APIs).
- Remote host operations (SSH to Mac mini, on-prem box).

See [skills.md](skills.md) for how to structure them.

## Compared to explicit modes

Some agent frameworks ask the user to say "switch to refactor mode." Implicit routing is simpler:

- **No new UI** — the user just describes the task.
- **No mode drift** — the orchestrator re-classifies every request, so a follow-up that changed from IMPLEMENT to DEBUG re-routes naturally.
- **Less to remember** — users don't learn mode names; the agent handles classification.

The cost is that the orchestrator needs good trigger signals. Lean on concrete keywords ("add", "rename", "broken", "tests", "compact") and stack-specific signals (migration filenames, error traces, specific CLI names).

## Canonical example

See [EXAMPLES.md — Canonical Example: meeting_notes_workflow](EXAMPLES.md#canonical-example-meeting_notes_workflow) for a real `.cursor/` tree using this pattern: one orchestrator rule, five consolidated always-on specialists, two glob-gated rules, one requestable rule, and nine skills — at roughly 50% of the context cost of the pre-consolidation shape.

Template starter: [`templates/00-orchestrator.mdc`](templates/00-orchestrator.mdc).
