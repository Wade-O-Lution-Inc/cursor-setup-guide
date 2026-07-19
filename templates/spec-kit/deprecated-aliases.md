# Deprecated workflow aliases (migration only)

Canonical workflows: **`sdd`** and **`sdd-remote`**. Old IDs are **removed** from the meeting_notes registry. Use flags instead.

| Deprecated ID | Replacement |
|---------------|-------------|
| `sdd-full` | `sdd` (default flags) |
| `sdd-api` | `sdd -i scope=api-only` |
| `sdd-rfc` | `sdd -i stop_at=tasks` (or `plan`) |
| `sdd-test-fix` | `sdd -i mode=test-fix` |
| `sdd-issues` | `sdd -i issues=true -i stop_at=tasks` |
| `sdd-full-remote` | `sdd-remote` |
| `sdd-remote-handoff` | `sdd-remote -i transfer_only=true` |

Do **not** install stub YAML files for these IDs during bootstrap. Registry template: [workflow-registry.template.json](./workflow-registry.template.json) (canonical entries only).
