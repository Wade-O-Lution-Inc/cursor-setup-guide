# Rules

Rules are `.mdc` files in `.cursor/rules/` that provide persistent context to the AI agent. They load automatically at the start of every session.

## Anatomy of a Rule

```markdown
---
description: One-line summary of what this rule covers
alwaysApply: true
---

# Human-Readable Title

Content goes here. Keep it concise — every token competes for context window space.
```

### Frontmatter Fields

| Field | Required | Values | Purpose |
|-------|----------|--------|---------|
| `description` | Yes | Short string | Helps the agent decide if the rule is relevant |
| `alwaysApply` | No | `true` / `false` | If `true`, loaded every session. If `false`, loaded only when the description matches the task |

**Use `alwaysApply: true` for most rules.** The overhead is small and the benefit of consistent behavior outweighs the token cost. Reserve `alwaysApply: false` for niche rules that only matter in rare scenarios.

## The Core Rules

### 1. `project.mdc` — Project Identity

This is the single most important rule. It tells the agent what the project is, where things live, and how to run it. Without this, the agent spends time exploring your repo structure every session.

**What to include:**
- One-sentence project description
- Entry points (main files, where routers/controllers/models live)
- Key commands (run, test, lint, build, deploy)
- Package managers and dependency files
- Documentation index (point to existing docs the agent can read when needed)

**What NOT to include:**
- Detailed architecture (put that in `docs/` and link to it)
- Long explanations of business logic

**Template:** [templates/project.mdc](templates/project.mdc)

**Real example** (from `meeting_notes_workflow`):

```markdown
---
description: Project identity, entry points, key commands, and documentation index
alwaysApply: true
---

# Meeting Notes Workflow

FastAPI + React knowledge base platform. Ingests meetings from Fireflies,
enriches with Claude, syncs to HubSpot/Slack/Notion.

## Entry Points

- **API server**: `app/main.py` (FastAPI, routers in `app/routers/`)
- **Frontend**: `frontend/src/` (React + Vite + Tailwind/DaisyUI)
- **Config**: `app/config.py` (Pydantic settings from `.env`)

## Key Commands

- **Run backend**: `uvicorn app.main:app --reload --port 8000`
- **Run tests**: `python -m pytest tests/ -x -q`
- **Lint**: `ruff check`

## Documentation Index

- Architecture: `docs/ARCHITECTURE.md`
- API Reference: `docs/API_REFERENCE.md`
```

### 2. `code-style.mdc` — Language Conventions

Prevents the agent from writing code in a style that doesn't match your project. Focus on the conventions that are **non-obvious** or **project-specific** — don't repeat language defaults the agent already knows.

**Good items to include:**
- Where business logic lives vs. where route handlers live
- Import conventions specific to your project
- Testing patterns (framework, fixture location, mock strategy)
- Framework-specific patterns (state management, API client conventions)

**Bad items to include:**
- "Use camelCase for JavaScript variables" (the agent knows this)
- "Add docstrings to functions" (generic advice, not project-specific)

**Template:** [templates/code-style.mdc](templates/code-style.mdc)

### 3. `environment.mdc` — Secret Safety

This is a **safety guardrail**. It tells the agent what it must never touch and how configuration works in your project.

**Must include:**
- Files the agent must never read or display (`.env`, credential files)
- How config flows (environment variables, config files, Pydantic settings, etc.)
- How to add a new configuration value (the step-by-step)

**Template:** [templates/environment.mdc](templates/environment.mdc)

### 4. `git-workflow.mdc` — Deployment Safety

Another safety guardrail. Tells the agent your branching strategy and what operations require human approval.

**Key sections:**
- Branch strategy (where to branch from, where to merge)
- Forbidden operations (force push, direct push to main, etc.)
- What the agent can do without asking (read, test, lint)
- What requires approval (commit, push, deploy, run scripts)

**Template:** [templates/git-workflow.mdc](templates/git-workflow.mdc)

### 5. `security-protocol.mdc` — Security Response Protocol

Establishes a stop-and-report protocol when the agent encounters security issues during coding or review. Instead of silently continuing, the agent stops work, reports the finding with severity, and fixes critical issues before proceeding.

**What to include:**
- The specific patterns that trigger a stop (hardcoded secrets, injection, auth bypass)
- Severity levels and what action each level requires
- Your project's safe patterns (parameterized queries, auth middleware, config patterns)
- Patterns that are always wrong in your codebase

**Template:** [templates/security-protocol.mdc](templates/security-protocol.mdc)

**Real example** (from `meeting_notes_workflow`):

```markdown
---
description: Security response protocol — stop-and-report when security issues are found.
alwaysApply: true
---

# Security Response Protocol

## If You Discover a Security Issue: STOP

1. **Hardcoded secrets** → STOP, fix immediately
2. **SQL injection** → STOP, fix immediately
3. **Missing auth** → Flag and offer to fix
4. **Sensitive data in logs** → Note in PR description

## Safe Patterns Already in Use
- `settings.anthropic_api_key` (from Doppler via env var)
- `db.rpc("function_name", params)` (parameterized Supabase RPCs)
- `Depends(require_user_auth)` on all user-facing routes
```

### 6. `testing-conventions.mdc` — Testing Patterns

Keeps tests consistent across the team and AI agents. Without this, the agent writes tests in random styles — sometimes using mocks, sometimes not, with inconsistent naming and structure.

**What to include:**
- Test structure pattern (Arrange-Act-Assert is recommended)
- Naming convention for test functions
- Pytest markers and when to use them
- What to test vs. what not to test
- Your conftest patterns and fixture conventions

**Template:** [templates/testing-conventions.mdc](templates/testing-conventions.mdc)

### 7. `goal-driven-execution.mdc` — Scope Management

Prevents the agent from scope-creeping. Agents are naturally inclined to "improve" things they pass through — reformatting imports, adding type hints to unchanged functions, creating utility modules "for next time." This rule anchors every edit to the stated task and defines clear done criteria.

**Key sections:**
- Scope traps to avoid (specific anti-patterns agents fall into)
- Done criteria (goal achieved, tests pass, lint clean, no unrelated files)
- Documentation assessment for plan builds (when to update docs after multi-step features)
- When and how scope should expand (stop, communicate, keep in same concern)

**Template:** [templates/goal-driven-execution.mdc](templates/goal-driven-execution.mdc)

### 8. `surgical-changes.mdc` — Minimal Edits

Reinforces making the smallest change that solves the problem. While `goal-driven-execution.mdc` focuses on *what* to do, this rule focuses on *how* — edit only the files the task requires, don't reformat, don't migrate patterns, one concern per commit.

**Key sections:**
- Rules of engagement (edit only what's needed, don't reformat, don't migrate patterns)
- Service boundary awareness (keep changes within one deploy target)
- Don't touch tests you don't need to

**Template:** [templates/surgical-changes.mdc](templates/surgical-changes.mdc)

### 9. `think-before-coding.mdc` — Reason First

Forces the agent to think about which layer a change belongs in, find existing patterns, and check the blast radius before writing any code. Without this, agents jump straight to implementation and sometimes invent new patterns when established ones already exist.

**Key sections:**
- Three questions before writing code (layer, pattern, blast radius)
- Pattern catalog (CRUD, background jobs, config, integrations — with file references)
- Data flow understanding
- Database change planning

**Template:** [templates/think-before-coding.mdc](templates/think-before-coding.mdc)

## Additional Domain Rules

Beyond the core nine, add rules for any domain where the agent consistently needs guidance:

| Rule | When to Add |
|------|------------|
| `database.mdc` | You have migration conventions, schema patterns, or safety rules for DB changes |
| `integrations.mdc` | You connect to external APIs and want the agent to follow established patterns |
| `deployment.mdc` | Your deploy pipeline has specific service boundaries or trigger rules |

## Writing Tips

1. **Be concise.** Every line competes for context window space. Bullet points > paragraphs.
2. **Be specific.** "Use `app/errors.AppError`" beats "Use the custom error hierarchy."
3. **Use NEVER/ALWAYS for safety rules.** The agent respects strong directives.
4. **Link to docs instead of inlining.** Point to `docs/ARCHITECTURE.md` rather than pasting architecture into the rule.
5. **Add a maintenance clause.** Tell the agent to flag stale references:

```markdown
## Rule Maintenance

If you encounter a rule that references a file path or convention that no longer
exists in the codebase, flag it to the user.
```

This keeps rules accurate as the codebase evolves without scheduled maintenance.
