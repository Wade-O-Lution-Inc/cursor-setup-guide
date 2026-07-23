# Cloud Agents / `AGENTS.md`

Root `AGENTS.md` is the thin index Cloud Agents (and humans) read first. Keep it short; put behavior in `.cursor/rules/` and procedures in skills.

**Not** a substitute for [day1.md](./day1.md) (machine) or deep `docs/agents/*` (product architecture).

---

## Skeleton

```markdown
# AGENTS.md

One paragraph: what this repo is + link to always-on rules
(e.g. `.cursor/rules/project.mdc`).

## Cloud / no-secrets bootstrap

Minimum env vars (fake OK if unused) so the app starts.
Install commands (`uv`, `npm`, …) for this stack.

## PR target

State the default base branch (e.g. `staging`).

## Gotchas

PATH, test markers, blank UI without frontend env, …
```

## What to include

1. Product identity + link to always-on rules (do not duplicate `project.mdc`).
2. How to run without real secrets (placeholders).
3. Minimum bootstrap for this stack (`uv` / `npm` / `sdd-ctl sync` only if SDD).
4. PR target for *this* repo.
5. Non-obvious gotchas that save a day of thrash.

## Gold pattern

[meeting_notes_workflow/AGENTS.md](https://github.com/Wade-O-Lution-Inc/meeting_notes_workflow/blob/staging/AGENTS.md) — adapt structure; do not copy MNW Doppler/pytest lines into a non-Python repo.

## Relationship

| Doc | Audience |
|-----|----------|
| [day1.md](./day1.md) | Any engineer’s machine |
| Product `AGENTS.md` | Agents opening **that** repo |
| Product `docs/agents/*` | Humans + architecture depth |

Do not paste this whole setup guide into `AGENTS.md`.
