# Legacy: 9-rule pattern (pre-consolidation)

These templates are kept for reference only. They represent the pre-consolidation shape of the `.cursor/rules/` tree, where each engineering/safety concern had its own always-on `.mdc` file:

| Legacy file | Consolidated into |
|---|---|
| `goal-driven-execution.mdc` | `engineering-discipline.mdc` |
| `surgical-changes.mdc` | `engineering-discipline.mdc` |
| `think-before-coding.mdc` | `engineering-discipline.mdc` |
| `code-style.mdc` | `project.mdc` (project-specific style) + `engineering-discipline.mdc` (simplest-working-pattern) |
| `environment.mdc` | `environment-and-commands.mdc` |
| `security-protocol.mdc` | `security-and-git.mdc` |
| `git-workflow.mdc` | `security-and-git.mdc` |

## Why consolidate?

Every always-on rule competes for context-window space on every session. Nine separate files averaged a lot of preamble overhead (frontmatter, H1 title, restatement of "always" themes) without adding information the agent couldn't infer from a denser merged version.

The [meeting_notes_workflow canonical example](../../EXAMPLES.md#canonical-example-meeting_notes_workflow) shows the same behavior captured in five consolidated rules plus an orchestrator, at roughly half the token cost.

## When you might still want these

- **You're bootstrapping a small repo and want one rule per concern while you figure out what you actually need.** Start here, then consolidate once the rules stabilize.
- **You prefer `alwaysApply: false` per-concern loading.** If most of these are off by default and the agent pulls them in by description match, the context cost argument weakens — though you should still think hard about whether each rule is actually triggered often enough to justify the file.
- **You want to compare the merged versions against the originals before adopting.** Diff `engineering-discipline.mdc` against `goal-driven-execution.mdc` + `surgical-changes.mdc` + `think-before-coding.mdc` to see the consolidation.

## Recommended path

Start with the top-level consolidated templates in [`templates/`](..). Add a legacy template only if you've tried the consolidated version and found it genuinely insufficient for your project.
