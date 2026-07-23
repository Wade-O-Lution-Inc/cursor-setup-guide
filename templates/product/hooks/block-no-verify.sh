#!/bin/bash
# Cursor hook: Prevent agents from running git commands with --no-verify.
# This ensures pre-commit hooks always run.
#
# Event: beforeShellExecution
# Input:  shell command on stdin
# Output: exit 0 to allow, exit 1 to block (stderr shown to user)

INPUT=$(cat)

if echo "$INPUT" | grep -qE '\-\-no-verify|--no-gpg-sign'; then
  echo "BLOCKED: --no-verify and --no-gpg-sign are not allowed." >&2
  echo "Pre-commit hooks must run on all commits." >&2
  exit 1
fi

exit 0
