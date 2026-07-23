# Skills

On-demand procedures (`SKILL.md`). Rules = policy; skills = how.

**Ownership / stubs:** [ownership.md](./ownership.md) · stub names: [`templates/sync-manifest.json`](../templates/sync-manifest.json)

---

## Rules vs skills

| | Rules | Skills |
|---|-------|--------|
| Load | Always / glob | When routed or invoked |
| Size | Short | Can be long playbooks |
| Example | “PRs target staging” | “How to run a Doppler rotation” |

## Anatomy

```
.cursor/skills/my-skill/
└── SKILL.md    # YAML frontmatter + markdown body
```

Useful frontmatter: `name`, `description` (routing signal), optional `disable-model-invocation: true` (stubs).

## Stub vs full (critical)

- Full bodies for shared Spec Kit / ops skills are **repo-canonical** (gold: meeting_notes for many).
- `~/.cursor/skills/<name>/` for those names should be **pointer stubs**.
- `install-global` creates stubs from the manifest; **never** expands them into a second SSOT.
- Personal skills (`lab-host-ssh`, …) stay full on the machine; CLI will not overwrite them.
- **When not to stub:** a skill that only exists on your laptop (personal ops) — keep it full under `~/.cursor/skills/`, do not add to the guide manifest.

Promote a reusable skill: land full body in the owning product repo → optional stub globally → sync into guide `templates/skills/` if adopters need it.

## Org catalog (roles)

| Skill | Scope | Role |
|-------|-------|------|
| `sdd-entry` | Product | Chat Start/Continue SDD |
| `speckit-*` | Product (+ global stubs) | Phase workers |
| `sdd-orchestrator` | Global (ctl symlink) | Phase gating |
| Ops (Doppler, Fireflies, …) | Product | Copy from gold if your repo needs them |
| `company-mcp` | Product | [company-mcp.md](./company-mcp.md) |

Pedagogy under `templates/product/example-skill/` — teaching only, not production.

## Spec Kit managed vs org

[specify/managed-vs-custom.md](./specify/managed-vs-custom.md). After `specify integration upgrade`, re-apply org deltas (`templates/skills/speckit-managed-deltas.md`).
