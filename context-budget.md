# Context Budget

Every `alwaysApply: true` rule, every MCP server enabled workspace-wide, and every long pinned file lives in **every session's context window**. This is the single biggest ambient cost in a Cursor setup, and the easiest to let drift.

## Treat always-on rules as a budget

A reasonable target for a medium-sized repo's `.cursor/rules/` tree:

| Scope | Lines (combined) | Characters (combined) |
|---|---|---|
| Always-on rules | ~500–800 | ~25K–40K |
| Glob-gated rules | unbounded (loaded on demand) | — |
| Requestable rules | unbounded (loaded on trigger) | — |

These are not hard limits — they're the order of magnitude where you should start questioning whether a rule earns its always-on slot. If your `alwaysApply: true` set passes ~1000 lines, either content is duplicated across rules or something belongs behind a glob.

## The four tiers

Place each rule in the cheapest tier that still works:

### 1. Delete

The rule has been superseded, is no longer accurate, or duplicates another rule's content. Remove it entirely. Most "context bloat" fixes are deletions, not reshuffles.

### 2. Requestable (`alwaysApply: false` + trigger words)

The rule matters only when the user explicitly asks for the thing. Good examples: compact/handoff, "explain the architecture," "review this for security issues." The agent pulls the rule in by description match; the tokens don't sit in every session.

### 3. Glob-gated (`globs:`)

The rule matters only when editing specific files or directories. Good examples: deployment conventions (`Dockerfile*`, `.github/workflows/**`), migration patterns (`migrations/**`), frontend-specific style (`frontend/src/**`). The rule loads only when a matching file is in context.

### 4. Always-on (`alwaysApply: true`)

The rule is foundational — the agent should respect it regardless of what task it's doing. Reserve this tier for:

- Project identity + entry points (`project.mdc`).
- Engineering discipline (`engineering-discipline.mdc`).
- Environment / secret safety (`environment-and-commands.mdc`).
- Security + git workflow (`security-and-git.mdc`).
- Testing patterns (`testing-conventions.mdc`).
- The orchestrator itself (`00-orchestrator.mdc`).

That's six files. Most projects can stop there and add glob-gated / requestable rules for the rest.

## Signs a rule shouldn't be always-on

- Its content is genuinely relevant on < 20% of tasks.
- 70%+ of its advice overlaps with another rule.
- Its examples reference a specific subsystem (migrations, deploys, one integration).
- It's a runbook ("to do X, run these 5 commands") — that's a skill, not a rule.
- The agent rarely cites it in actual edits.

If any of these apply, move it to glob-gated, requestable, or delete.

## Consolidation discipline

Overlapping always-on rules are the most common cause of context bloat. A realistic consolidation path:

| Before (many single-concern rules) | After (fewer consolidated rules) |
|---|---|
| `goal-driven-execution.mdc` | `engineering-discipline.mdc` |
| `surgical-changes.mdc` | ″ |
| `think-before-coding.mdc` | ″ |
| `simplicity-first.mdc` | ″ |
| `environment.mdc` | `environment-and-commands.mdc` |
| `cli-operations.mdc` | ″ |
| `python-uv-commands.mdc` | ″ |
| `security-protocol.mdc` | `security-and-git.mdc` |
| `git-workflow.mdc` | ″ |
| `open-source-skill-intake-security.mdc` | ″ |

In the [canonical example](EXAMPLES.md#canonical-example-meeting_notes_workflow), this consolidation took 15 rules (~50K chars) down to 9 (~25K chars) without removing behavior — see the `CONTEXT_BUDGET.md` accounting in that repo.

## Consolidation checklist

When merging N rules into one:

1. **Find the shared spine.** Usually a single progression — *think → scope → edit → verify → done* — underlies several rules.
2. **Strip duplicated intros.** Every rule has a frontmatter, an H1, and a theme-restatement paragraph. Keep one.
3. **Keep concrete examples, drop abstract ones.** Project-specific safe patterns (`settings.anthropic_api_key`, `db.rpc(...)`) earn their space; generic advice ("use parameterized queries") does not.
4. **Index, don't inline.** Long architecture notes belong in `docs/`, not in a rule. Point to the doc.
5. **Verify no behavior loss.** Before deleting an old rule, diff its bullets against the consolidated rule's bullets.

## MCP / plugin cost

MCP servers and plugin tools also load their descriptors into context. The built-in **Notion workspace** plugin is commonly cited as large. Before enabling a plugin workspace-wide:

1. Measure the cost in tokens (Cursor shows this under Context → MCP tools).
2. Consider enabling it only when needed (`settings.json` → `plugins → <name> → enabled: false` as default).
3. Document the on/off pattern in a skill so the agent can flip it.

## Measurement

Count characters per tier:

```bash
# Always-on budget
awk '/alwaysApply: true/{p=1} /^---$/{if(p){p=0}}' .cursor/rules/*.mdc \
  | wc -c

# Total rule bytes (reference)
cat .cursor/rules/*.mdc | wc -c
```

A `.cursor/CONTEXT_BUDGET.md` in the repo that records the current snapshot makes regressions obvious in review.

## Related

- [orchestration.md](orchestration.md) — implicit routing means less pressure to keep every rule always-on.
- [rules.md](rules.md) — per-rule guidance on the target tier.
