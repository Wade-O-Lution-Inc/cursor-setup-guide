#!/bin/bash
# Cursor hook: After a Task/subagent completes, check if the working tree
# has become a mixed-concern state and inject orchestrator guidance.
#
# Runs after subagent stop events. Fail-open.

INPUT=$(cat)

# Only act after subagent completion
EVENT=$(echo "$INPUT" | jq -r '.event // empty' 2>/dev/null)

# Check if working tree has changes spanning multiple service boundaries
CHANGED_FILES=$(git status --porcelain 2>/dev/null | awk '{print $2}')
if [ -z "$CHANGED_FILES" ]; then
  exit 0
fi

BOUNDARIES=""
for f in $CHANGED_FILES; do
  case "$f" in
    app/services/*|app/routers/*|app/main.py) BOUNDARIES="$BOUNDARIES api" ;;
    frontend/*) BOUNDARIES="$BOUNDARIES frontend" ;;
    worker.py|app/workers/*) BOUNDARIES="$BOUNDARIES worker" ;;
    migrations/*) BOUNDARIES="$BOUNDARIES migrations" ;;
  esac
done

UNIQUE_BOUNDARIES=$(echo "$BOUNDARIES" | tr ' ' '\n' | sort -u | grep -v '^$' | wc -l | tr -d ' ')

if [ "$UNIQUE_BOUNDARIES" -ge 3 ]; then
  echo '{
    "followup_message": "The working tree now spans '"$UNIQUE_BOUNDARIES"' service boundaries (api, frontend, worker, migrations). Consider running the worktree orchestrator to split into focused PRs: uv run python -m scripts.orchestrator report"
  }'
  exit 0
fi

# Check for high-conflict file accumulation
HC_COUNT=0
for f in $CHANGED_FILES; do
  case "$f" in
    app/main.py|app/config.py|frontend/src/App.tsx|frontend/src/services/kb.ts|migrations/MANIFEST|requirements.txt|worker.py|.env.example)
      HC_COUNT=$((HC_COUNT + 1))
      ;;
  esac
done

if [ "$HC_COUNT" -ge 3 ]; then
  echo '{
    "followup_message": "'"$HC_COUNT"' high-conflict files are modified. These files cause frequent merge conflicts in multi-agent repos. Consider splitting changes before committing: uv run python -m scripts.orchestrator report"
  }'
  exit 0
fi

exit 0
