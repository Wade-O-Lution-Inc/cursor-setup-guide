# Rules

Rules are `.mdc` files in `.cursor/rules/` that provide persistent context to the AI agent. They can load automatically at session start (`alwaysApply: true`), on file matches (`globs: [...]`), or on description match from the user's request (`alwaysApply: false`).

This guide recommends the **orchestrator + consolidated specialists** pattern. See [orchestration.md](orchestration.md) for the routing layer and [context-budget.md](context-budget.md) for why consolidation matters.

## Anatomy of a Rule

```markdown
---
description: One-line summary of what this rule covers
alwaysApply: true
globs: []
---

# Human-Readable Title

Content goes here. Keep it concise — every always-on line costs tokens on every session.
```

### Frontmatter Fields

| Field | Required | Values | Purpose |
|---|---|---|---|
| `description` | Yes | Short string | Used when the rule is requestable, to match the user's phrasing |
| `alwaysApply` | No | `true` / `false` | If `true`, loaded every session |
| `globs` | No | Array of glob patterns | If non-empty, rule loads only when a matching file is in context |

**Pick the cheapest tier that works.** See [context-budget.md](context-budget.md) for tier guidance.

## Recommended Target Shape

A minimal, realistic set for a production repo:

| File | Scope | Purpose |
|---|---|---|
| `00-orchestrator.mdc` | always-on | Implicit routing from request → mode → specialist |
| `project.mdc` | always-on | Project identity, architecture, key commands, pattern catalog, doc index |
| `engineering-discipline.mdc` | always-on | Think-first, stay-in-scope, surgical edits, simplest-working-pattern, done criteria |
| `environment-and-commands.mdc` | always-on | Secret manager, run commands, feature flags, secret safety |
| `security-and-git.mdc` | always-on | Security stop-and-report, multi-agent git workflow, OSS skill intake |
| `testing-conventions.mdc` | always-on | AAA, naming, conftest/fixtures, markers, ship-with-tests policy |
| `compact-handoff.mdc` | requestable | Dense operational handoff when the user says `compact` / `checkpoint` |
| `deployment.mdc` | glob-gated | Deploy/infra conventions (loads on Dockerfile / deploy/ / workflows) |
| [domain-specific rule] | glob-gated | Loads when editing the relevant module(s) |

Seven-to-nine rules total. Six always-on. The remainder glob-gated or requestable.

## The Six Always-On Rules

### 1. `00-orchestrator.mdc` — Implicit Routing

Classifies each request into one primary mode (IMPLEMENT / REFACTOR / DEBUG / DOCS / TEST / HANDOFF / OPS) and points at the specialist rule or skill that owns that mode. The agent does **not** mentally replay every rule on every turn.

See [orchestration.md](orchestration.md) for the full pattern. Template: [`templates/00-orchestrator.mdc`](templates/00-orchestrator.mdc).

### 2. `project.mdc` — Project Identity

The single most impactful rule. Tells the agent what the project is, where things live, and how to run it. Without this, the agent spends time exploring your repo structure every session.

**Include:**
- One-sentence project description
- Entry points (main files; where routers/controllers/models live)
- Key commands (run, test, lint, build, deploy)
- Package manager(s) and dependency files
- A pattern catalog: "for CRUD see X, for background jobs see Y, for integrations see Z"
- High-conflict files (files where parallel edits cause pain)
- Documentation index (point to `docs/`, don't inline)

**Don't include:**
- Detailed architecture (put that in `docs/ARCHITECTURE.md` and link to it)
- Long explanations of business logic

Template: [`templates/project.mdc`](templates/project.mdc).

### 3. `engineering-discipline.mdc` — Think / Scope / Surgical / Simple / Done

Consolidates the old *think-before-coding*, *goal-driven-execution*, *surgical-changes*, and *simplicity-first* rules into one:

1. **Think first** — which layer, which existing pattern, what's the blast radius.
2. **Stay in scope** — every edit traces back to the stated task; list scope traps explicitly.
3. **Surgical edits** — edit only what's required; don't reformat; one concern per commit.
4. **Simplest working pattern** — use existing abstractions; don't add dependencies or abstract prematurely.
5. **Done criteria** — goal achieved, tests ship with the feature, lint clean, no unrelated files touched.

Template: [`templates/engineering-discipline.mdc`](templates/engineering-discipline.mdc).

### 4. `environment-and-commands.mdc` — Environments, Secret Manager, Run Commands

Consolidates *environment*, *cli-operations*, and *python-uv-commands* (or the equivalent for your stack). Covers:

- Every deploy target (local / staging / production / on-prem hosts).
- Secret manager CLI patterns (`<secret-manager> run -- <command>`).
- The exact run-command shape for tests, dev server, migrations, worker.
- Feature flag mechanism.
- What the agent must **never** read, display, or commit.

Template: [`templates/environment-and-commands.mdc`](templates/environment-and-commands.mdc).

### 5. `security-and-git.mdc` — Security, Git Workflow, OSS Skill Intake

Consolidates *security-protocol*, *git-workflow*, and *open-source-skill-intake-security*. Covers:

- **Security stop-and-report** for hardcoded secrets, SQL injection, auth bypass, etc.
- **Git workflow** — PR target (`staging` vs `main`), branch naming, scope boundaries, commit conventions, PR etiquette, conflict resolution.
- **OSS skill intake gate** — provenance, content scan, supply-chain check, sandboxed adoption, decision policy.

Template: [`templates/security-and-git.mdc`](templates/security-and-git.mdc).

### 6. `testing-conventions.mdc` — Test Patterns

Keeps tests consistent across the team and AI agents. Template: [`templates/testing-conventions.mdc`](templates/testing-conventions.mdc).

Include:
- AAA (Arrange-Act-Assert) structure.
- Naming convention (`test_<unit>_<scenario>_<expected_outcome>` or equivalent).
- `conftest` / fixture conventions.
- Pytest markers and when to use each.
- What to test vs. what not to test.
- Ship-with-tests policy: features without tests are incomplete.

## Glob-Gated Rules

Glob-gated rules load only when a matching file is in context. Good candidates:

| File | Typical globs |
|---|---|
| `deployment.mdc` | `Dockerfile*`, `deploy/**`, `railway.json`, `.github/workflows/**` |
| `database.mdc` | `migrations/**`, `**/schema.sql`, `scripts/migrate*` |
| `frontend-style.mdc` | `frontend/src/**`, `**/*.tsx`, `**/*.jsx` |
| `worktree-orchestrator.mdc` | `scripts/orchestrator/**` |

## Requestable Rules

Requestable rules have `alwaysApply: false` and are pulled in when the user's request matches the description. Good candidates:

| File | Trigger |
|---|---|
| `compact-handoff.mdc` | `compact`, `checkpoint`, `handoff`, `resume packet` |
| `architecture-review.mdc` | `review the architecture`, `design audit` |
| `security-review.mdc` | `security review`, `audit this for auth issues` |

## Writing Tips

1. **Be concise.** Every always-on line lives in every session. Bullet points > paragraphs.
2. **Be specific.** "Use `app/errors.AppError`" beats "Use the custom error hierarchy."
3. **Use NEVER/ALWAYS for safety rules.** The agent respects strong directives.
4. **Link to docs instead of inlining.** Point to `docs/ARCHITECTURE.md` rather than pasting architecture into the rule.
5. **Add a maintenance clause.**

```markdown
## Rule Maintenance

If you encounter a rule that references a file path or convention that no longer
exists in the codebase, flag it to the user.
```

## Legacy: The 9-Rule Pattern

The original version of this guide recommended nine separate always-on rules, one per engineering concern. That shape is preserved in [`templates/legacy-9-rule-pattern/`](templates/legacy-9-rule-pattern/) for reference. The consolidated pattern above reduces context cost by roughly 50% on a real production repo — see the [canonical example](EXAMPLES.md#canonical-example-meeting_notes_workflow). Start with the consolidated shape; drop to the legacy shape only if you've tried the merged rules and found them insufficient.
