# Skills

Skills are step-by-step procedures in `.cursor/skills/*/SKILL.md` that the agent follows when performing specific tasks. Think of them as executable runbooks.

## Rules vs Skills

| | Rules | Skills |
|---|-------|--------|
| **Format** | `.mdc` file in `rules/` | `SKILL.md` in `skills/your-skill/` |
| **Loaded** | Automatically, every session | On-demand, when the task matches the description |
| **Purpose** | Context and guardrails | Step-by-step procedures |
| **Length** | Short (20-50 lines typical) | Longer (50-100 lines typical) |
| **Analogy** | Team norms everyone knows | Runbook you pull off the shelf for a specific task |

**Rule of thumb:** If it's "always know this" → rule. If it's "do these steps when X" → skill.

## Anatomy of a Skill

```markdown
---
name: your-skill-name
description: >-
  What this skill does and when to use it. The agent uses this description
  to decide when to apply the skill, so be specific.
---

# Human-Readable Title

## When to Use

One or two sentences describing the trigger scenario.

## Required Inputs

What the agent needs from the user before starting.

## Procedure

### Step 1: ...
### Step 2: ...
### Step 3: ...

## Boundaries

What this skill does NOT do. Where the agent should stop and wait for human approval.

## Expected Output

What artifacts the skill produces.
```

### Key Sections

**`description` (frontmatter)** — This is how the agent discovers the skill. Write it in third person, be specific about trigger terms:
- Good: "Write a safe, idempotent SQL migration for the Supabase PostgreSQL database. Use when adding tables, columns, indexes, or RPC functions."
- Bad: "Helps with database stuff."

**`When to Use`** — Reinforces the description in plain language for clarity.

**`Required Inputs`** — What the agent should ask for before proceeding. Prevents the agent from guessing.

**`Procedure`** — The numbered steps. This is where the real value lives. Be prescriptive: name exact files, commands, and patterns.

**`Boundaries`** — Equally important as the procedure. Tells the agent where to stop. "This skill produces the file; it does NOT apply the migration" prevents the agent from going rogue.

## Real Examples

### Database Migration Skill

From `meeting_notes_workflow` — a high-stakes, low-freedom procedure where getting it wrong could break production:

```markdown
---
name: migration-workflow
description: >-
  Write a safe, idempotent SQL migration for the Supabase PostgreSQL database.
  Use when adding tables, columns, indexes, RPC functions, or modifying the
  database schema.
---

# Write a Database Migration

## When to Use
User asks to add a table, column, index, RPC function, or make any schema change.

## Required Inputs
- What schema change is needed
- Which schema it belongs to (core, meetings, docs, biz, ops, ai, auth_app)

## Procedure

### Step 1: Review conventions
Read `docs/MIGRATION_PRACTICES.md`. Key constraints:
- Additive only: `IF NOT EXISTS` everywhere
- Idempotent: safe to run multiple times
- No `DROP COLUMN` or `DROP TABLE`

### Step 2: Check existing schema
Read `docs/ARCHITECTURE.md` section 3 to understand current tables.

### Step 3: Write the migration file
Create `migrations/YYYYMMDD_description.sql` using today's date.

### Step 4: Register in MANIFEST
Append the filename to `migrations/MANIFEST`. Never reorder.

### Step 5: Verify
Run `python -m scripts.migrate --dry-run`.

## Boundaries
- Does NOT apply the migration (requires human approval)
- Does NOT modify application code (separate step)

## Expected Output
- One new `.sql` file in `migrations/`
- One line appended to `migrations/MANIFEST`
```

Notice the pattern: **read conventions → check current state → do the thing → register → verify → stop**. The boundaries are explicit — the agent writes the migration but never runs it.

### Infrastructure Deployment Skill

From `Integrity_Lab` — a lower-stakes, higher-freedom procedure:

```markdown
---
name: add-dashboard
description: >-
  Add a new Grafana Cloud dashboard via Terraform. Use when creating a new
  monitoring dashboard for a service, pipeline, or infrastructure component.
---

# Add a Grafana Dashboard

## Procedure

### Step 1: Create the dashboard JSON
Create `terraform/dashboards/your-dashboard-name.json`.
Use an existing dashboard JSON as a template.

### Step 2: Add the Terraform resource
In `terraform/main.tf`, add a `grafana_dashboard` resource.

### Step 3: Plan and verify
Run `terraform plan`. Do NOT apply without human approval.

## Boundaries
- `terraform apply` always requires human approval
```

This skill is shorter because the task is more straightforward. The key value is the boundary: "do NOT apply without human approval."

## When to Create a New Skill

Create a skill when you notice:

1. **The agent keeps getting a multi-step procedure wrong** — It forgets a step, does them in the wrong order, or misses a convention
2. **There are safety constraints** — Database migrations, deployments, integration changes where doing it wrong has real consequences
3. **You're re-explaining the same workflow** — If you've corrected the agent on the same procedure twice, encode it as a skill

## When NOT to Create a Skill

- **The task is a single step** — Just put it in a rule
- **The agent already gets it right** — Don't over-specify
- **The procedure changes frequently** — Skills that need constant updating are worse than no skill

## Template

See [templates/example-skill/SKILL.md](templates/example-skill/SKILL.md) for a starter template.
