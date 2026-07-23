# Templates

**Who should touch this:** maintainers syncing gold, or adopters peeking at pack contents.  
**Prefer:** `../bin/cursor-setup` over manual `cp`.

**Sync:** [SYNC.md](./SYNC.md) · **Manifest (authoritative for `sync-check`):** [sync-manifest.json](./sync-manifest.json)

---

## Four trees

| Directory | Destination | Audience |
|-----------|-------------|----------|
| [global/](./global/) | `~/.cursor/` via `install-global` | Every machine |
| [product/](./product/) | `repo/.cursor/` via `scaffold-repo` | Any product repo |
| [skills/](./skills/) | Portable skills (SDD entry, confidence, company-mcp) | Copy into products |
| [spec-kit/](./spec-kit/) | SDD adopt pack via `adopt-sdd` | Spec Kit products |

### Starter vs gold

`product/*.mdc` are **pedagogy starters**. They are **not** a rename of meeting_notes’ mature rules (`00-orchestrator`, `engineering-discipline`, …). See [../docs/ownership.md](../docs/ownership.md#starter-pack-vs-gold-important).

`product/example-skill/` and `search-first-skill/` are teaching aids — not required in production harnesses.

Orchestrator hook **scripts** under `product/hooks/` are optional; default `hooks.json` does not wire them.

---

## Spec Kit (`spec-kit/`)

Workflows, registry, orchestrator policy, confidence templates, portable SDD user guide.  
Replace lint/test via `adopt-sdd --lint-cmd … --test-cmd …`.

## Maintainers

After MNW harness PRs: follow SYNC.md / bump `last_synced` in SYNC + manifest · tell the team to `refresh-global`.  
`./bin/cursor-setup sync-check --mnw /path/to/meeting_notes_workflow` — **maintainer** tool, not day-1.
