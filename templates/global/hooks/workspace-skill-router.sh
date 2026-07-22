#!/usr/bin/env bash
# Wade-O-Lution workspace skill router — repo copy for CI; prefer ~/.cursor/hooks/ for local overrides.
set -euo pipefail

resolve_wade_root() {
  if [ -n "${WADE_O_LUTION_WORKSPACE:-}" ] && [ -d "${WADE_O_LUTION_WORKSPACE}" ]; then
    printf '%s' "${WADE_O_LUTION_WORKSPACE}"
    return
  fi
  local git_root=""
  git_root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
  if [ -n "$git_root" ]; then
    case "$(basename "$git_root")" in
      data-api|integrity-ts|data-api-terraform-provider|core-cluster-charts|device-configuration|data-api-sdk|meeting_notes_workflow|Integrity_Lab|repo-index)
        printf '%s' "$(dirname "$git_root")"
        return
        ;;
    esac
  fi
  printf '%s' "${HOME}/Projects/Wade-O-Lution-Inc"
}

WADE_ROOT="$(resolve_wade_root)"

read_prompt() {
  INPUT="$(cat || true)"
  if command -v jq >/dev/null 2>&1; then
    PROMPT="$(printf '%s' "$INPUT" | jq -r '.prompt // .message // .text // .input // empty' 2>/dev/null || true)"
  else
    PROMPT="$INPUT"
  fi
}

detect_repo_key() {
  local root=""
  root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
  if [ -z "$root" ]; then
    printf '%s' "${WADE_REPO_KEY:-}"
    return
  fi
  case "$(basename "$root")" in
    data-api) printf 'data-api' ;;
    integrity-ts) printf 'integrity-ts' ;;
    data-api-terraform-provider) printf 'data-api-terraform-provider' ;;
    core-cluster-charts) printf 'core-cluster-charts' ;;
    device-configuration) printf 'device-configuration' ;;
    data-api-sdk) printf 'data-api-sdk' ;;
    meeting_notes_workflow) printf 'meeting_notes_workflow' ;;
    Integrity_Lab) printf 'Integrity_Lab' ;;
    repo-index) printf 'repo-index' ;;
    *) printf '%s' "${WADE_REPO_KEY:-}" ;;
  esac
}

skill_path() {
  local repo="$1"
  local skill="$2"
  printf '%s/%s/.cursor/skills/%s/SKILL.md' "$WADE_ROOT" "$repo" "$skill"
}

global_skill() {
  local skill="$1"
  printf '%s/.cursor/skills/%s/SKILL.md' "${HOME}" "$skill"
}

add_suggestion() {
  case "$SUGGESTIONS" in
    *"$1"*) ;;
    *) SUGGESTIONS="${SUGGESTIONS}${SUGGESTIONS:+\\n}- $1" ;;
  esac
}

add_repo_skill() {
  local repo="$1"
  local skill="$2"
  local path
  path="$(skill_path "$repo" "$skill")"
  if [ -f "$path" ]; then
    add_suggestion "Read ${path}"
  fi
}

add_global_skill() {
  local skill="$1"
  local path repo
  path="$(global_skill "$skill")"
  if [ -f "$path" ]; then
    add_suggestion "Read ${path}"
    return
  fi
  for repo in "${ACTIVE_REPO:-data-api}" data-api integrity-ts meeting_notes_workflow Integrity_Lab repo-index; do
    [ -z "$repo" ] && continue
    path="$(skill_path "$repo" "$skill")"
    if [ -f "$path" ]; then
      add_suggestion "Read ${path}"
      return
    fi
  done
}

add_rule() {
  local repo="$1"
  local rule="$2"
  local path="${WADE_ROOT}/${repo}/.cursor/rules/${rule}"
  if [ -f "$path" ]; then
    add_suggestion "Read ${path}"
  fi
}

add_global_rule() {
  local rule="$1"
  local path repo
  path="${HOME}/.cursor/rules/${rule}"
  if [ -f "$path" ]; then
    add_suggestion "Read ${path}"
    return
  fi
  for repo in "${ACTIVE_REPO:-data-api}" data-api integrity-ts meeting_notes_workflow Integrity_Lab repo-index; do
    [ -z "$repo" ] && continue
    path="${WADE_ROOT}/${repo}/.cursor/rules/${rule}"
    if [ -f "$path" ]; then
      add_suggestion "Read ${path}"
      return
    fi
  done
}

route_repo_context_boost() {
  # Cheap boost: any recognized Wade-O-Lution repo gets the cross-repo
  # workspace rule once, so its harness-layout/Spec-Kit-ownership table is
  # in context without a separate keyword match.
  if [ -n "$ACTIVE_REPO" ]; then
    add_global_rule "multi-repo-workspace.mdc"
  fi
  case "$ACTIVE_REPO" in
    data-api)
      add_rule "data-api" "agent-orchestrator.mdc"
      ;;
    integrity-ts)
      add_rule "integrity-ts" "agent-orchestrator.mdc"
      ;;
    data-api-terraform-provider)
      add_repo_skill "data-api-terraform-provider" "terraform-provider-resource"
      add_rule "data-api-terraform-provider" "agent-orchestrator.mdc"
      ;;
    core-cluster-charts)
      add_repo_skill "core-cluster-charts" "helm-chart-release"
      add_rule "core-cluster-charts" "agent-orchestrator.mdc"
      ;;
    device-configuration)
      add_repo_skill "device-configuration" "device-configuration-api"
      add_rule "device-configuration" "agent-orchestrator.mdc"
      ;;
    meeting_notes_workflow)
      add_rule "meeting_notes_workflow" "00-orchestrator.mdc"
      add_rule "meeting_notes_workflow" "project.mdc"
      ;;
    Integrity_Lab)
      add_rule "Integrity_Lab" "agent-orchestrator.mdc"
      add_rule "Integrity_Lab" "project.mdc"
      ;;
    repo-index)
      add_rule "repo-index" "swarm-protocol.mdc"
      ;;
  esac
}

route_prompt_keywords() {
  local LOWER="$1"

  case "$LOWER" in
    *cross-repo*|*reconcile*|*contract\ drift*|*contract\ sync*|*mismatch*)
      add_repo_skill "integrity-ts" "cross-repo-contract-sync"
      ;;
  esac
  case "$LOWER" in
    *contract\ graduation*|*stub-to-live*|*live\ cutover*|*liveenabled*|*graduate*)
      add_repo_skill "integrity-ts" "contract-graduation"
      ;;
  esac
  case "$LOWER" in
    *compact*|*handoff*|*checkpoint*|*resume\ packet*|*continue\ later*|*session\ bridge*)
      add_global_rule "compact-handoff.mdc"
      add_global_skill "session-handoff"
      ;;
  esac

  case "$LOWER" in
    *terraform\ provider*|*terraform-provider*|*dataapi_region*|*dataapi_site*|*dataapi_tenant*|*terratest*|*plugin-framework*|*enrollment_token*|*edge_node\ data*)
      add_repo_skill "data-api-terraform-provider" "terraform-provider-resource"
      ;;
  esac

  case "$LOWER" in
    *helm\ chart*|*chartversion*|*argocd*|*sync-wave*|*core-cluster*|*ghcr\ chart*|*helm\ lint*|*helm\ template*)
      add_repo_skill "core-cluster-charts" "helm-chart-release"
      ;;
  esac

  case "$LOWER" in
    *device-configuration*|*device\ configuration*|*hub_serial*|*hub\ serial*)
      add_repo_skill "device-configuration" "device-configuration-api"
      ;;
  esac

  case "$LOWER" in
    *remote\ sites*|*cdot*|*composer*|*slug\ bridge*|*site_resolver*)
      add_repo_skill "data-api" "remote-sites-composer"
      if [ -f "${WADE_ROOT}/data-api/docs/platform/RemoteSitesSlugBridge.md" ]; then
        add_suggestion "Read ${WADE_ROOT}/data-api/docs/platform/RemoteSitesSlugBridge.md"
      fi
      ;;
  esac
  case "$LOWER" in
    *endpoint\ implementation*|*new\ endpoint*|*crud\ endpoint*|*fastapi\ router*|*registration\ service*)
      add_repo_skill "data-api" "endpoint-implementation"
      ;;
  esac
  case "$LOWER" in
    *sqlmodel*|*model\ schema*|*schema\ drift*)
      add_repo_skill "data-api" "model-schema-extension"
      ;;
  esac
  case "$LOWER" in
    *auth\ guard*|*oidc*|*bearer*|*site\ scope*|*require_site_access*)
      add_repo_skill "data-api" "auth-guard-pattern"
      ;;
  esac
  case "$LOWER" in
    */v1/me*|*session\ endpoint*)
      add_repo_skill "data-api" "session-endpoint"
      ;;
  esac
  case "$LOWER" in
    *redshift*|*telemetry\ endpoint*|*time\ series\ bucket*)
      add_repo_skill "data-api" "telemetry-endpoint"
      ;;
  esac
  case "$LOWER" in
    *health\ aggreg*|*alerts_history*)
      add_repo_skill "data-api" "health-aggregation"
      ;;
  esac
  case "$LOWER" in
    *8001*|*8002*|*8003*|*8004*|*microservice\ routing*)
      add_repo_skill "data-api" "microservice-routing"
      ;;
  esac
  case "$LOWER" in
    *pytest*|*basedpyright*|*ruff*)
      add_repo_skill "data-api" "test-coverage"
      ;;
  esac
  case "$LOWER" in
    *frontend\ contract*|*dto\ valid*|*staged\ openapi*)
      add_repo_skill "data-api" "frontend-contract-validation"
      add_repo_skill "data-api" "openapi-staging-reader"
      ;;
  esac
  case "$LOWER" in
    *api\ reference*|*doc-sync*)
      add_repo_skill "data-api" "doc-sync"
      ;;
  esac

  case "$LOWER" in
    *documentation\ revamp*|*docs\ revamp*|*docs/readme*|*docs:check-links*|*legacy\ archive*)
      add_repo_skill "integrity-ts" "doc-sync"
      if [ -f "${WADE_ROOT}/integrity-ts/docs/meta/DocumentationGuide.md" ]; then
        add_suggestion "Read ${WADE_ROOT}/integrity-ts/docs/meta/DocumentationGuide.md"
      fi
      ;;
  esac

  case "$LOWER" in
    *dashboard\ capabilities*|*surface\ composer*|*intelligence\ surface*)
      add_repo_skill "integrity-ts" "platform-session"
      add_repo_skill "integrity-ts" "facilities-ui-surface"
      ;;
  esac

  case "$LOWER" in
    *profile\ builder*)
      add_repo_skill "integrity-ts" "profile-builder"
      add_repo_skill "integrity-ts" "platform-session"
      ;;
  esac

  case "$LOWER" in
    *react\ doctor*|*doctor:react*|*react\ hygiene*|*react\ hook*)
      add_repo_skill "integrity-ts" "react-hygiene"
      ;;
  esac

  case "$LOWER" in
    *remote\ sites\ ui*|*cdot\ map*|*dewatering*|*dewatering\ ui*|*field\ ops*)
      add_repo_skill "integrity-ts" "remote-sites-ui-surface"
      if [ -f "${WADE_ROOT}/integrity-ts/.agents/skills/shadcn/SKILL.md" ]; then
        add_suggestion "Read ${WADE_ROOT}/integrity-ts/.agents/skills/shadcn/SKILL.md"
      fi
      ;;
  esac
  case "$LOWER" in
    *facilities\ ui*|*shadcn*|*aligned\ token*|*component*|*ux\ review*)
      add_repo_skill "integrity-ts" "facilities-ui-surface"
      if [ -f "${WADE_ROOT}/integrity-ts/.agents/skills/shadcn/SKILL.md" ]; then
        add_suggestion "Read ${WADE_ROOT}/integrity-ts/.agents/skills/shadcn/SKILL.md"
      fi
      ;;
  esac
  case "$LOWER" in
    *design\ critique*|*design\ review*|*design\ audit*|*ux\ copy*|*empty\ state*|*loading\ state*)
      add_repo_skill "integrity-ts" "design-critique"
      add_repo_skill "integrity-ts" "facilities-ui-surface"
      ;;
  esac
  case "$LOWER" in
    *facilities\ hierarchy*|*page\ registry*|*facilitiesshell*)
      add_repo_skill "integrity-ts" "facilities-industry"
      ;;
  esac
  case "$LOWER" in
    *msw*|*mock\ handler*)
      add_repo_skill "integrity-ts" "msw-contract-handler"
      ;;
  esac
  case "$LOWER" in
    *api\ stub*|*contract\ stub*|*aligned\ api*|*integritydataapi*)
      add_repo_skill "integrity-ts" "data-api-contract-stub"
      ;;
  esac
  case "$LOWER" in
    *openapi\ staging*|*staged\ contract*)
      add_repo_skill "integrity-ts" "openapi-staging"
      ;;
  esac
  case "$LOWER" in
    *playwright*|*e2e\ test*)
      add_repo_skill "integrity-ts" "playwright-qa"
      ;;
  esac
  case "$LOWER" in
    *react\ doctor*|*react\ hygiene*|*react\ hook*|*useeffect*)
      add_repo_skill "integrity-ts" "react-hygiene"
      ;;
  esac
  case "$LOWER" in
    *topology\ graph*|*react\ flow*|*elk\ layout*)
      add_repo_skill "integrity-ts" "facilities-topology-viz"
      ;;
  esac
  case "$LOWER" in
    *echarts*|*sla\ chart*)
      add_repo_skill "integrity-ts" "facilities-charting"
      ;;
  esac
  case "$LOWER" in
    *3d\ visual*|*r3f*|*webgl*|*digital\ twin*)
      add_repo_skill "integrity-ts" "3d-visualizer"
      ;;
  esac
  case "$LOWER" in
    *platform\ session*|*customer\ profile*|*rbac\ matrix*)
      add_repo_skill "integrity-ts" "platform-session"
      ;;
  esac
  case "$LOWER" in
    *lab\ deploy*|*mac\ mini*|*k3s\ lab*)
      add_repo_skill "integrity-ts" "lab-deploy"
      ;;
  esac
  case "$LOWER" in
    *supply\ chain*|*socket\ campaign*|*npm\ install*)
      add_repo_skill "integrity-ts" "supply-chain-audit"
      add_repo_skill "integrity-ts" "socket-threat-watch"
      ;;
  esac
  case "$LOWER" in
    *notion\ publish*|*doc-sync*)
      add_repo_skill "integrity-ts" "doc-sync"
      ;;
  esac

  case "$LOWER" in
    *data-api*|*sqlmodel*|*kong\ gateway*)
      add_rule "data-api" "agent-orchestrator.mdc"
      ;;
  esac
  case "$LOWER" in
    *integrity-ts*|*facilities\ vnext*|*remote\ sites\ vnext*)
      add_rule "integrity-ts" "agent-orchestrator.mdc"
      ;;
  esac

  case "$LOWER" in
    *sdd*|*speckit*|*spec\ kit*|*spec-driven*|*confidence\ loop*|*phase\ router*|*sdd-orchestrator*|*sdd-phase-router*)
      add_repo_skill "meeting_notes_workflow" "sdd-entry"
      add_global_skill "sdd-orchestrator"
      ;;
  esac
  case "$LOWER" in
    *doppler*|*secret\ rotat*|*env\ var*)
      add_repo_skill "meeting_notes_workflow" "doppler-secrets"
      ;;
  esac
  case "$LOWER" in
    *notion*)
      add_repo_skill "meeting_notes_workflow" "notion-integration"
      ;;
  esac
  case "$LOWER" in
    *linear*|*kb-intake*|*work\ review*|*work-review*|*backlog\ groom*|*cycle\ planning*|*sprint\ planning*|*canonical\ project*|*linear\ asks*|*coding\ session*|*delegate\ to\ cursor*|*pi\ agent*|*pi\ env*)
      add_repo_skill "meeting_notes_workflow" "linear-project-management"
      ;;
  esac
  case "$LOWER" in
    *company\ mcp*|*company-mcp*|*context\ pack*|*get_company_context_pack*|*ask_company_context*|*company\ dossier*|*customer\ context*|*who\ knows*|*who_knows*|*integritykb-company*|*integrity-kb-company*)
      add_repo_skill "meeting_notes_workflow" "company-mcp"
      ;;
  esac
  case "$LOWER" in
    *mac\ mini*|*mammoth*|*tailscale*|*alloy*|*caddy*|*phase-gate*|*phase1-gate*|*phase2-lab-gate*|*k3s\ lab*)
      # Integrity_Lab's own route-lab-skills-before-prompt.sh hook already
      # suggests repo-local Lab skills (relative paths) for these keywords;
      # only add the global (non-repo-owned) skill here to avoid a duplicate
      # mandatory list on every matching Lab prompt.
      add_global_skill "lab-host-ssh"
      ;;
  esac
  case "$LOWER" in
    *ponytail*|*over-engineer*|*over\ engineer*|*overengineering*|*what\ can\ we\ delete*|*audit\ this\ codebase*)
      add_repo_skill "meeting_notes_workflow" "overengineering-review"
      add_repo_skill "meeting_notes_workflow" "overengineering-audit"
      ;;
  esac
  case "$LOWER" in
    *oss\ skill*|*install\ a\ skill*|*github-hosted\ skill*|*skill\ supply\ chain*|*skill-supply-chain*)
      add_repo_skill "meeting_notes_workflow" "skill-supply-chain-review"
      add_global_skill "skill-supply-chain-review"
      ;;
  esac
  case "$LOWER" in
    *browser*|*playwright*|*navigate\ to*|*fill\ out\ the\ form*|*scrape*)
      add_global_skill "browser-automation"
      ;;
  esac
  case "$LOWER" in
    *swarm*|*claim\ scope*|*dispatch\ intent*|*orchestrator\ repo*)
      add_repo_skill "repo-index" "swarm-claim-scope"
      ;;
  esac
}

wade_repo_active() {
  # True when the current repo is a Wade-O-Lution repo: a known repo key
  # (basename match or WADE_REPO_KEY) or a git root under WADE_ROOT.
  [ -n "${ACTIVE_REPO:-}" ] && return 0
  local root=""
  root="$(git rev-parse --show-toplevel 2>/dev/null || true)"
  [ -n "$root" ] || return 1
  case "${root}/" in
    "${WADE_ROOT}/"*) return 0 ;;
  esac
  return 1
}

route_universal_keywords() {
  # Repo-agnostic routing only — safe to emit in any repo (Wade or not).
  local LOWER="$1"
  case "$LOWER" in
    *compact*|*handoff*|*checkpoint*|*resume\ packet*|*continue\ later*|*session\ bridge*)
      add_global_rule "compact-handoff.mdc"
      add_global_skill "session-handoff"
      ;;
  esac
}

emit_result() {
  if [ -n "$SUGGESTIONS" ]; then
    local header="MANDATORY SKILL ROUTING: Read every skill below before editing files."
    if command -v jq >/dev/null 2>&1; then
      jq -n --arg msg "${header}\n${SUGGESTIONS}" '{"permission":"allow","agent_message":$msg}'
    else
      printf '{"permission":"allow","agent_message":"%s\\n%s"}\n' "$header" "$SUGGESTIONS"
    fi
    exit 0
  fi
  echo '{"permission":"allow"}'
  exit 0
}

wade_run_skill_router() {
  SUGGESTIONS=""
  read_prompt
  if [ -z "${PROMPT:-}" ]; then
    echo '{"permission":"allow"}'
    return 0
  fi
  LOWER="$(printf '%s' "$PROMPT" | tr '[:upper:]' '[:lower:]')"
  ACTIVE_REPO="$(detect_repo_key)"
  if [ -n "${WADE_REPO_KEY:-}" ]; then
    ACTIVE_REPO="$WADE_REPO_KEY"
  fi
  route_repo_context_boost
  if wade_repo_active; then
    route_prompt_keywords "$LOWER"
  else
    # Non-Wade repo: skip data-api/integrity-ts repo-skill injection; keep only
    # universally-useful routing (compact-handoff). (spec 014, OA-012)
    route_universal_keywords "$LOWER"
  fi
  emit_result
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  wade_run_skill_router
fi
