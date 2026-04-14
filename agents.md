# AGENTS.md

`AGENTS.md` is a special file that Cursor Cloud Agents read automatically when they start a session. It provides instructions specific to the Cloud Agent VM environment — which is different from a developer's local machine.

## Why You Need It

Cloud Agents run in ephemeral VMs without access to your local tools, secret managers, or network. `AGENTS.md` bridges that gap by telling the agent:

- How to run the project without your secret manager (e.g., Doppler, 1Password CLI)
- Which environment variables are required vs optional
- What's different about the Cloud Agent environment compared to local dev
- Known quirks the agent should expect (degraded health checks, pre-existing lint warnings)

## Where It Goes

`AGENTS.md` lives at the **root of your repo**, next to `README.md`. Cursor Cloud Agents automatically discover and read it.

```
your-repo/
├── AGENTS.md          # Cloud Agent instructions
├── README.md          # Human instructions
├── .cursor/
│   └── rules/         # Always-on AI context (loaded in all environments)
└── ...
```

## What to Include

### 1. Project Overview (Brief)

One paragraph: what the project is, what stack it uses, how it runs locally. Keep it shorter than your README — the agent doesn't need the full backstory.

### 2. Running Without Your Secret Manager

Most projects use Doppler, 1Password, or similar tools that aren't available in Cloud Agent VMs. Provide the minimum env vars needed to start the app with placeholder values:

```markdown
### Running without Doppler

The codebase expects secrets via `doppler run --`, but in Cloud Agent VMs
Doppler is not configured. Instead, pass required env vars directly:

```bash
SUPABASE_URL=https://fake.supabase.co
SUPABASE_SERVICE_KEY=fake-service-key
SLACK_BOT_TOKEN=xoxb-fake-token
```

Only list the **minimum required** env vars. Use obviously-fake values so the agent doesn't accidentally call real services.

### 3. Key Commands

A table of common actions with the exact commands. Emphasize any tooling quirks:

```markdown
| Action | Command |
|--------|---------|
| Install deps | `uv sync --group dev` |
| Run backend | `SUPABASE_URL=... uv run uvicorn app.main:app --reload` |
| Run tests | `SUPABASE_URL=... uv run python -m pytest tests/ -x -q` |
| Lint | `uv run ruff check` |
```

### 4. PR Target Branch

If your repo uses a non-obvious merge target (e.g., `staging` instead of `main`), say it clearly:

```markdown
### PR Target Branch

**All PRs MUST target `staging`** — never `main`.
```

### 5. Tooling Quirks

Call out anything non-obvious about the development environment:

```markdown
### Non-obvious notes

- `uv` must be on PATH — install with `pip install uv` if missing
- `python` may not be on PATH on macOS — use `uv run python` instead
- Tests run with fake env vars and all external services mocked
- The health endpoint returns "degraded" with fake credentials — this is expected
- The frontend has pre-existing lint errors — these are not regressions
```

### 6. Feature Flags (Optional)

If your project uses feature flags that affect agent behavior:

```markdown
### Feature flags

| Flag | Default | Purpose |
|------|---------|---------|
| `FEATURE_X_ENABLED` | `false` | Enables new X behavior |
```

### 7. Cross-References

Point the agent to rules and skills it should know about:

```markdown
### Cursor hooks and rules

The repo ships hooks in `.cursor/hooks.json` and `.cursor/hooks/`:
- `detect-secrets.sh` — blocks prompts containing API keys
- `block-no-verify.sh` — prevents `--no-verify` in git commands

See `.cursor/rules/testing-conventions.mdc` for test patterns.
See `.cursor/skills/search-first/SKILL.md` for the development decision matrix.
```

## AGENTS.md vs Rules

| | AGENTS.md | Rules (`.cursor/rules/`) |
|---|-----------|-------------------------|
| **Read by** | Cloud Agents only | All Cursor sessions (local + cloud) |
| **Purpose** | Environment setup, tooling quirks | Code conventions, safety guardrails |
| **Tone** | Operational: "here's how to run things" | Prescriptive: "here's how to write code" |
| **Contains** | Env vars, commands, known issues | Patterns, forbidden operations, checklists |

Don't duplicate rule content in `AGENTS.md`. Instead, cross-reference: "See `.cursor/rules/git-workflow.mdc` for branching conventions."

## Template

```markdown
# AGENTS.md

## Overview

[One paragraph: what this project is and how it runs.]

## Running without [Your Secret Manager]

[Minimum env vars with placeholder values.]

## Key commands

| Action | Command |
|--------|---------|
| Install deps | `[command]` |
| Run backend | `[command]` |
| Run tests | `[command]` |
| Lint | `[command]` |

## PR Target Branch

**All PRs MUST target `[branch]`** — never `main`.

## Non-obvious notes

- [Tooling quirk 1]
- [Tooling quirk 2]
- [Known pre-existing issues]
```

## Security Notes

- NEVER put real secret values in `AGENTS.md` — use obviously-fake placeholders
- The file is committed to git and visible to anyone with repo access
- Env var names are fine to list; values must always be fake
