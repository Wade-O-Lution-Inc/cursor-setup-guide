#!/usr/bin/env bash
# beforeSubmitPrompt (inject-only): when the user kicks off SDD, check
# Spec Kit adoption + shared ctl install and inject findings for the agent.
# Never blocks the prompt (always continue/allow).
set -euo pipefail

CTL="${HOME}/.cursor/sdd-orchestrator-ctl"
CTL_BIN="${CTL}/bin/sdd-ctl"
SKILL_LINK="${HOME}/.cursor/skills/sdd-orchestrator"

emit_allow() {
  if command -v jq >/dev/null 2>&1 && [ -n "${1:-}" ]; then
    jq -n --arg msg "$1" '{"continue":true,"permission":"allow","agent_message":$msg}'
  elif [ -n "${1:-}" ]; then
    # Minimal fallback — keep JSON safe enough for short ASCII messages.
    python3 -c 'import json,sys; print(json.dumps({"continue":True,"permission":"allow","agent_message":sys.argv[1]}))' "$1"
  else
    printf '%s\n' '{"continue":true,"permission":"allow"}'
  fi
  exit 0
}

INPUT="$(cat || true)"
if [ -z "$INPUT" ]; then
  emit_allow ""
fi

PROMPT=""
ROOTS_JSON="[]"
if command -v jq >/dev/null 2>&1; then
  PROMPT="$(printf '%s' "$INPUT" | jq -r '.prompt // .message // .text // .input // empty' 2>/dev/null || true)"
  ROOTS_JSON="$(printf '%s' "$INPUT" | jq -c '.workspace_roots // []' 2>/dev/null || echo '[]')"
else
  PROMPT="$INPUT"
fi

LOWER="$(printf '%s' "$PROMPT" | tr '[:upper:]' '[:lower:]')"
case "$LOWER" in
  *'start sdd'*|*'continue sdd'*|*'spec this feature'*|*'spec this'*| \
  *'/sdd'*|*'sdd-remote'*|*'sdd /'*|*'run sdd'*|*'full sdd'*|*'sdd loop'*)
    ;;
  *)
    emit_allow ""
    ;;
esac

# Collect candidate repo roots from workspace_roots + git toplevels.
ROOTS=()
if command -v jq >/dev/null 2>&1; then
  while IFS= read -r root; do
    [ -n "$root" ] && ROOTS+=("$root")
  done < <(printf '%s' "$ROOTS_JSON" | jq -r '.[]?' 2>/dev/null || true)
fi
if [ "${#ROOTS[@]}" -eq 0 ]; then
  git_root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
  [ -n "$git_root" ] && ROOTS+=("$git_root")
fi

# Expand each workspace folder to a git root when nested.
RESOLVED=()
for root in "${ROOTS[@]+"${ROOTS[@]}"}"; do
  if [ -d "$root/.git" ] || [ -f "$root/.git" ]; then
    RESOLVED+=("$root")
  elif git -C "$root" rev-parse --show-toplevel >/dev/null 2>&1; then
    RESOLVED+=("$(git -C "$root" rev-parse --show-toplevel 2>/dev/null)")
  else
    RESOLVED+=("$root")
  fi
done

# Dedupe
UNIQUE=()
for root in "${RESOLVED[@]+"${RESOLVED[@]}"}"; do
  skip=0
  for u in "${UNIQUE[@]+"${UNIQUE[@]}"}"; do
    [ "$u" = "$root" ] && skip=1 && break
  done
  [ "$skip" -eq 0 ] && UNIQUE+=("$root")
done

LINES=()
LINES+=("MANDATORY SDD PREFLIGHT (inject-only — always continue; do not skip these checks):")

# Shared ctl install
if [ ! -x "$CTL_BIN" ]; then
  LINES+=("- ctl: MISSING $CTL_BIN — clone Wade-O-Lution-Inc/sdd-orchestrator to ~/.cursor/sdd-orchestrator-ctl")
else
  # Best-effort sync (do not fail the hook on sync errors).
  sync_out="$(python3 "$CTL_BIN" sync 2>&1 || true)"
  pre_out="$(python3 "$CTL_BIN" preflight 2>&1 || true)"
  if command -v jq >/dev/null 2>&1; then
    synced="$(printf '%s' "$sync_out" | jq -r 'select(type=="object") | .synced // empty' 2>/dev/null | tail -1)"
    head="$(printf '%s' "$sync_out" | jq -r 'select(type=="object") | .head // empty' 2>/dev/null | tail -1)"
    branch="$(printf '%s' "$sync_out" | jq -r 'select(type=="object") | .branch // empty' 2>/dev/null | tail -1)"
    skill_ok="$(printf '%s' "$sync_out" | jq -r 'select(type=="object") | .skill_ok // empty' 2>/dev/null | tail -1)"
    pre_ok="$(printf '%s' "$pre_out" | jq -r 'select(type=="object") | .ok // empty' 2>/dev/null | tail -1)"
    pre_skip="$(printf '%s' "$pre_out" | jq -r 'select(type=="object") | .skipped // false' 2>/dev/null | tail -1)"
    pre_reason="$(printf '%s' "$pre_out" | jq -r 'select(type=="object") | .reason // empty' 2>/dev/null | tail -1)"
  else
    synced=""; head=""; branch=""; skill_ok=""; pre_ok=""; pre_skip="false"; pre_reason=""
  fi
  short_head="$(printf '%s' "$head" | cut -c1-8)"
  if [ "$synced" = "true" ] && [ "$branch" = "main" ]; then
    LINES+=("- ctl: OK main@${short_head:-?} skill_ok=${skill_ok:-?} (synced)")
  else
    LINES+=("- ctl: CHECK — branch=${branch:-?} synced=${synced:-?} head=${short_head:-?} skill_ok=${skill_ok:-?}. Run: python3 ~/.cursor/sdd-orchestrator-ctl/bin/sdd-ctl sync")
  fi
  if [ "$pre_skip" = "true" ]; then
    LINES+=("- ctl preflight: SKIPPED (${pre_reason:-SDD_CTL_SKIP_INSTALL_PREFLIGHT}). Unset skip for product-repo SDD so drift fail-closes.")
  elif [ "$pre_ok" = "true" ]; then
    LINES+=("- ctl preflight: OK")
  else
    LINES+=("- ctl preflight: FAIL — ${pre_reason:-see sdd-ctl preflight}. Fix install before orchestrating.")
  fi
fi

if [ -L "$SKILL_LINK" ]; then
  LINES+=("- global skill symlink: OK → $(readlink "$SKILL_LINK" 2>/dev/null || true)")
elif [ -e "$SKILL_LINK" ]; then
  LINES+=("- global skill symlink: WARN — $SKILL_LINK exists but is not a symlink (should point at ctl skills/sdd-orchestrator)")
else
  LINES+=("- global skill symlink: MISSING $SKILL_LINK — run sdd-ctl sync")
fi

if [ "${#UNIQUE[@]}" -eq 0 ]; then
  LINES+=("- workspace: no roots resolved — cannot verify .specify/; confirm the product repo is open")
else
  for root in "${UNIQUE[@]}"; do
    name="$(basename "$root")"
    # Skip pure ctl runtime install noise when it's the only product concern
    if [ ! -d "$root/.specify" ]; then
      LINES+=("- ${name}: MISSING .specify/ — stop and run: cursor-setup adopt-sdd \"$root\" (or --force with lint/test cmds)")
      continue
    fi
    entry="$root/.cursor/skills/sdd-entry/SKILL.md"
    if [ -f "$entry" ]; then
      entry_note="sdd-entry OK"
    else
      entry_note="MISSING sdd-entry — copy/adapt from cursor-setup adopt-sdd"
    fi
    orch="$root/.specify/orchestrator.json"
    if [ -f "$orch" ]; then
      if python3 -c 'import json,sys; json.load(open(sys.argv[1]))' "$orch" 2>/dev/null; then
        orch_note="orchestrator.json OK"
      else
        orch_note="orchestrator.json INVALID JSON"
      fi
    else
      orch_note="orchestrator.json absent (optional overlay)"
    fi
    local_orch="$root/.cursor/skills/sdd-orchestrator"
    if [ -L "$local_orch" ]; then
      vend_note="local sdd-orchestrator symlink OK"
    elif [ -d "$local_orch" ]; then
      vend_note="WARN vendored .cursor/skills/sdd-orchestrator dir — prefer global symlink; remove fork to avoid drift"
    else
      vend_note="no local sdd-orchestrator fork"
    fi
    LINES+=("- ${name}: .specify OK; ${entry_note}; ${orch_note}; ${vend_note}")
    LINES+=("  path: $root")
  done
fi

LINES+=("Next: follow ~/.cursor/skills/sdd-entry/SKILL.md then ~/.cursor/skills/sdd-orchestrator/SKILL.md. Do not invent a Spec Kit tree by hand.")

MSG="$(printf '%s\n' "${LINES[@]}")"
emit_allow "$MSG"
