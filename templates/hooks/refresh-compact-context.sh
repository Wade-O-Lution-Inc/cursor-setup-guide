#!/usr/bin/env bash
# Cursor hook: Write a fresh repo-state snapshot to .cursor/auto-context.md.
# Triggered by afterFileEdit and stop events.
# Pure side-effect — reads no stdin, always exits 0.
set -euo pipefail

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
OUT_DIR="$ROOT/.cursor"
OUT_FILE="$OUT_DIR/auto-context.md"

mkdir -p "$OUT_DIR"
cd "$ROOT"

NOW="$(date -u +"%Y-%m-%d %H:%M:%SZ")"
BRANCH="$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'no-git-branch')"
HEAD_SHA="$(git rev-parse --short HEAD 2>/dev/null || echo 'no-head')"

{
  echo "# Auto Context"
  echo
  echo "- Updated: $NOW"
  echo "- Branch: $BRANCH"
  echo "- HEAD: $HEAD_SHA"
  echo

  echo "## Git Status"
  echo '```'
  git status --short --branch 2>/dev/null || true
  echo '```'
  echo

  echo "## Changed Files"
  echo '```'
  git diff --name-only HEAD 2>/dev/null || true
  echo '```'
  echo

  echo "## Diff Stat"
  echo '```'
  git diff --stat HEAD 2>/dev/null || true
  echo '```'
  echo

  echo "## Recent Commits"
  echo '```'
  git log --oneline -n 8 2>/dev/null || true
  echo '```'
  echo

  echo "## Untracked Files"
  echo '```'
  git ls-files --others --exclude-standard 2>/dev/null || true
  echo '```'
  echo

  echo "## Notes For Compact Rule"
  echo "- Use this file as repo-state evidence."
  echo "- Prefer current modified files and diff stat over stale chat assumptions."
  echo "- If \`.cursor/session-handoff.md\` exists, update it only when explicitly asked."
} > "$OUT_FILE"

exit 0
