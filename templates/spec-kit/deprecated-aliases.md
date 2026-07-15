# Deprecated workflow aliases

Spec Kit v2 org model uses **two canonical workflows**: `sdd` and `sdd-remote` with flags. Older IDs remain registered for one release so existing scripts and muscle memory keep working.

## Flag mapping (preferred)

| Deprecated ID | Replacement |
|---------------|-------------|
| `sdd-full` | `sdd` (default flags) |
| `sdd-api` | `sdd -i scope=api-only` |
| `sdd-rfc` | `sdd -i stop_at=tasks` |
| `sdd-test-fix` | `sdd -i mode=test-fix` |
| `sdd-issues` | `sdd -i issues=true -i stop_at=tasks` |
| `sdd-full-remote` | `sdd-remote` |
| `sdd-remote-handoff` | `sdd-remote -i transfer_only=true` |

## Optional one-release install

Copy alias workflow dirs from [meeting_notes_workflow `.specify/workflows/`](https://github.com/Wade-O-Lution-Inc/meeting_notes_workflow/tree/staging/.specify/workflows) **or** register entries only in `workflow-registry.template.json` and point humans at flag mapping above.

Comment-only stubs in this guide (`templates/spec-kit/sdd-*-workflow.yml`) document historical IDs — they are **not** installed as live workflows during bootstrap.

## Registry

Use [workflow-registry.template.json](./workflow-registry.template.json) — it includes all alias metadata with `DEPRECATED` descriptions. Update `installed_at` / `updated_at` timestamps when copying into your repo.
