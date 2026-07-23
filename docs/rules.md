# Rules (`.mdc`)

Always-on or glob-gated guardrails. Prefer **short**, **scoped**, **one concern per file**.

**Install:** [product-repo](./product-repo.md) (`scaffold-repo`) · [day1](./day1.md) (`install-global` for machine rules) · [ownership](./ownership.md)

---

## Anatomy

```markdown
---
description: One line for when this applies
alwaysApply: true          # or use globs: instead
# globs:
#   - "specs/**"
#   - ".specify/**"
---

# Title

When … do …
```

## Good vs bad

| Do | Don’t |
|----|--------|
| Trigger + policy in ~30–80 lines | Novel-length architecture essays |
| Point to a skill for multi-step ops | Embed secrets, host IPs, tokens |
| Glob-gate Spec Kit phase rules | `alwaysApply: true` for SDD phase order |
| One concern per file / PR | Bundle unrelated policies |

## Where rules live

| Kind | Path | Install |
|------|------|---------|
| Product starters | `templates/product/*.mdc` → `repo/.cursor/rules/` | `scaffold-repo` |
| SDD snippet / specify override | `templates/product/rules/`, `templates/spec-kit/` | `adopt-sdd` |
| Machine always-on + on-demand | `templates/global/rules/` → `~/.cursor/rules/` | `install-global` / `refresh-global` |

### Starter pack vs gold

Scaffold pedagogy (`think-before-coding`, `surgical-changes`, …) ≠ MNW mature names (`00-orchestrator`, `engineering-discipline`, …). Details: [ownership.md](./ownership.md#starter-pack-vs-gold-important).

## Maintenance

- After changing global rules in this guide, teammates run `refresh-global`.
- Maintainers: `sync-check` compares machine global rules to templates.
