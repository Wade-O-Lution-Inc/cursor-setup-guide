#!/usr/bin/env bash
# Smoke tests for workspace-skill-router.sh cross-repo coverage (Component 1,
# global_env_improvement plan). Run from any directory:
#   bash ~/.cursor/hooks/workspace-skill-router.test.sh
set -euo pipefail

HOOK="${HOME}/.cursor/hooks/workspace-skill-router.sh"
WADE_ROOT="${HOME}/Projects/Wade-O-Lution-Inc"

if [[ ! -f "$HOOK" ]]; then
  echo "workspace-skill-router.test: hook not found at ${HOOK}" >&2
  exit 1
fi

run_hook_in() {
  local repo_dir="$1" prompt="$2"
  (cd "$repo_dir" && printf '%s' "{\"prompt\":$(jq -Rn --arg p "$prompt" '$p')}" | "$HOOK")
}

assert_contains() {
  local output="$1" needle="$2" label="$3"
  if ! printf '%s' "$output" | grep -Fq "$needle"; then
    echo "workspace-skill-router.test: ${label} — expected: ${needle}" >&2
    printf '%s\n' "$output" >&2
    exit 1
  fi
}

# 1. meeting_notes_workflow + speckit -> repo orchestrator/project rules + sdd-entry + global sdd-orchestrator
out="$(run_hook_in "${WADE_ROOT}/meeting_notes_workflow" 'run speckit on this feature')"
assert_contains "$out" 'meeting_notes_workflow/.cursor/rules/00-orchestrator.mdc' 'meeting_notes speckit: orchestrator rule'
assert_contains "$out" 'meeting_notes_workflow/.cursor/skills/sdd-entry/SKILL.md' 'meeting_notes speckit: sdd-entry'
assert_contains "$out" '.cursor/skills/sdd-orchestrator/SKILL.md' 'meeting_notes speckit: global sdd-orchestrator'

# 2. meeting_notes_workflow + doppler -> repo doppler-secrets skill
out="$(run_hook_in "${WADE_ROOT}/meeting_notes_workflow" 'doppler secrets rotate CURSOR_API_KEY')"
assert_contains "$out" 'meeting_notes_workflow/.cursor/skills/doppler-secrets/SKILL.md' 'meeting_notes doppler'

# 3. Integrity_Lab + mac mini -> global lab-host-ssh only (repo-local Lab
#    skills already come from Integrity_Lab's own route-lab-skills-before-prompt.sh)
out="$(run_hook_in "${WADE_ROOT}/Integrity_Lab" 'ssh to the mac mini and restart alloy')"
assert_contains "$out" '.cursor/skills/lab-host-ssh/SKILL.md' 'Integrity_Lab mac mini: global lab-host-ssh'

# 4. meeting_notes_workflow + ponytail alias -> overengineering-review/audit
out="$(run_hook_in "${WADE_ROOT}/meeting_notes_workflow" 'run a ponytail-review on this diff')"
assert_contains "$out" 'meeting_notes_workflow/.cursor/skills/overengineering-review/SKILL.md' 'meeting_notes ponytail alias'

# 5. meeting_notes_workflow + oss skill install -> skill-supply-chain-review (repo + global)
out="$(run_hook_in "${WADE_ROOT}/meeting_notes_workflow" 'can you install this github-hosted skill for me')"
assert_contains "$out" 'meeting_notes_workflow/.cursor/skills/skill-supply-chain-review/SKILL.md' 'meeting_notes oss skill install (repo)'
assert_contains "$out" '.cursor/skills/skill-supply-chain-review/SKILL.md' 'meeting_notes oss skill install (global)'

# 6. Component 3 ops-discovery fixture: "ssh to mammoth" -> global lab-host-ssh
out="$(run_hook_in "${WADE_ROOT}/meeting_notes_workflow" 'ssh to mammoth to check disk space')"
assert_contains "$out" '.cursor/skills/lab-host-ssh/SKILL.md' 'ops discovery: ssh to mammoth'

# 7. Component 3 ops-discovery fixture: "playwright fill form" -> global browser-automation
out="$(run_hook_in "${WADE_ROOT}/meeting_notes_workflow" 'use playwright fill form on the checkout page')"
assert_contains "$out" '.cursor/skills/browser-automation/SKILL.md' 'ops discovery: playwright fill form'

# 8. Component 3 ops-discovery fixture: "enable Notion MCP" -> repo notion-integration
out="$(run_hook_in "${WADE_ROOT}/meeting_notes_workflow" 'how do I enable Notion MCP for this session')"
assert_contains "$out" 'meeting_notes_workflow/.cursor/skills/notion-integration/SKILL.md' 'ops discovery: enable Notion MCP'

echo "workspace-skill-router.test: all fixtures passed"
