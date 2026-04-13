#!/bin/bash
# Cursor hook: Block Tab/agent from reading sensitive files.
# Prevents accidental exposure of key material.
#
# Event: beforeTabFileRead
# Input:  file path on stdin
# Output: exit 0 to allow, exit 1 to block (stderr shown to user)

INPUT=$(cat)

BLOCKED_PATTERNS=(
  '\.env$'
  '\.env\.'
  '\.key$'
  '\.pem$'
  '\.p12$'
  '\.pfx$'
  'credentials\.json'
  'service[-_]?account.*\.json'
  'id_rsa'
  'id_ed25519'
)

# Add project-specific patterns below:
# BLOCKED_PATTERNS+=('your-sensitive-file-pattern')

for pattern in "${BLOCKED_PATTERNS[@]}"; do
  if echo "$INPUT" | grep -qEi "$pattern"; then
    echo "BLOCKED: Reading sensitive file matching: $pattern" >&2
    exit 1
  fi
done

exit 0
