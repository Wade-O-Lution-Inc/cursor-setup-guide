---
name: search-first
description: >-
  Adopt / Extend / Compose / Build decision matrix. Use before writing any
  custom code to check if existing solutions handle the requirement. Prevents
  reinventing the wheel and keeps the codebase lean.
---

# Search-First: Adopt / Extend / Compose / Build

Before writing any custom code, systematically check if an existing solution
already handles the requirement.

## When to Use

Before implementing any new feature, service, or utility.

## Decision Matrix

Work through this matrix top-to-bottom. Stop at the first level that fully satisfies the need.

### Level 1: ADOPT — Use what exists verbatim

**Check these first:**
1. Does the codebase already have this? Search existing services and modules.
2. Is there a database function/RPC that does this? Check migrations.
3. Is there a config flag that enables this? Check the config file.

### Level 2: EXTEND — Add to an existing module

**When to extend:**
- The feature fits naturally into an existing service's responsibility
- It requires < 50 lines of new code
- It doesn't change the service's public interface

### Level 3: COMPOSE — Wire existing services together

**When to compose:**
- The feature needs data from 2+ existing services
- No single service owns the full workflow
- A thin orchestrator function is sufficient

### Level 4: BUILD — Create new module

**Only build when:**
- Levels 1-3 don't work
- The feature introduces a genuinely new concern
- You've confirmed with the user that new code is appropriate

**When building:**
- Follow existing patterns in the codebase
- Add a feature flag defaulting to `false`
- Add tests
- Document in the module docstring

## Quick Checklist Before Writing Code

```
[ ] Searched the codebase for existing functionality
[ ] Checked config for relevant feature flags
[ ] Checked if a database function handles the data operation
[ ] Checked if an existing service can be extended (< 50 lines)
[ ] Checked if existing services can be composed
[ ] Only then: create new module with feature flag
```

## Boundaries

- This skill guides the decision of *what to build*, not *how to build it*
- If level 1-3 applies, the agent should proceed with the existing solution
- If level 4 applies, the agent should confirm the approach with the user before creating new files
