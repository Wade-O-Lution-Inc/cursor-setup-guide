#!/usr/bin/env bash
# beforeSubmitPrompt hook: route prompts to skills across all workspace repos.
set -euo pipefail
exec "${HOME}/.cursor/hooks/workspace-skill-router.sh"
