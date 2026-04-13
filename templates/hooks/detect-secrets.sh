#!/bin/bash
# Cursor hook: Scan agent prompts/outputs for leaked secrets before submission.
# Blocks if any known secret patterns are detected.
#
# Event: beforeSubmitPrompt
# Input:  prompt text on stdin
# Output: exit 0 to allow, exit 1 to block (stderr shown to user)

INPUT=$(cat)

PATTERNS=(
  'sk-[a-zA-Z0-9]{20,}'
  'ghp_[a-zA-Z0-9]{36}'
  'AKIA[A-Z0-9]{16}'
  'xoxb-[0-9]+-[a-zA-Z0-9]+'
  'xoxp-[0-9]+-[a-zA-Z0-9]+'
  'eyJhbGciOi[a-zA-Z0-9_-]+\.[a-zA-Z0-9_-]+\.[a-zA-Z0-9_-]+'
  'secret_[a-zA-Z0-9-]{20,}'
  'Bearer [a-zA-Z0-9_-]{20,}'
)

# Add project-specific patterns below:
# PATTERNS+=('your-custom-pattern')

for pattern in "${PATTERNS[@]}"; do
  if echo "$INPUT" | grep -qEi "$pattern"; then
    echo "BLOCKED: Potential secret detected matching pattern: $pattern" >&2
    echo "Remove secrets before submitting to the agent." >&2
    exit 1
  fi
done

exit 0
