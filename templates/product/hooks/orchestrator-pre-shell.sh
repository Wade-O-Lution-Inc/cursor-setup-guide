#!/bin/bash
# Cursor hook: Observe git operations and warn when agents push to protected
# branches or bypass the staging-first workflow.
#
# Runs before shell execution. Fail-open (exit 0) so it never blocks work
# in observer mode. Emits agent_message warnings for policy violations.

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.command // empty' 2>/dev/null)

if [ -z "$COMMAND" ]; then
  echo '{"permission": "allow"}'
  exit 0
fi

# Block direct push to protected branches
if echo "$COMMAND" | grep -qE 'git\s+push\s+.*\b(main|staging)\b'; then
  if ! echo "$COMMAND" | grep -qE '\-\-delete'; then
    echo '{
      "permission": "ask",
      "user_message": "An agent is attempting to push directly to a protected branch (main or staging). All changes must go through PRs targeting staging.",
      "agent_message": "POLICY: Do not push directly to main or staging. Create a feature branch and open a PR targeting staging instead."
    }'
    exit 0
  fi
fi

# Warn on force-push to any branch
if echo "$COMMAND" | grep -qE 'git\s+push\s+.*(\-\-force|\-f)\b'; then
  echo '{
    "permission": "ask",
    "user_message": "An agent wants to force-push. This rewrites history and can lose other agents'\'' work.",
    "agent_message": "POLICY: Force-push is discouraged in this multi-agent repo. Prefer git merge over rebase for agent branches."
  }'
  exit 0
fi

# Warn when creating branches not from staging
if echo "$COMMAND" | grep -qE 'git\s+checkout\s+\-b\s+'; then
  CURRENT=$(git branch --show-current 2>/dev/null)
  if [ -n "$CURRENT" ] && [ "$CURRENT" != "staging" ]; then
    STAGING_SHA=$(git rev-parse origin/staging 2>/dev/null)
    HEAD_SHA=$(git rev-parse HEAD 2>/dev/null)
    MERGE_BASE=$(git merge-base HEAD origin/staging 2>/dev/null)
    if [ "$MERGE_BASE" != "$STAGING_SHA" ] 2>/dev/null; then
      echo '{
        "permission": "allow",
        "agent_message": "NOTE: You are creating a branch from '"$CURRENT"' which may not be up to date with staging. Consider branching from origin/staging for cleaner PRs."
      }'
      exit 0
    fi
  fi
fi

echo '{"permission": "allow"}'
exit 0
