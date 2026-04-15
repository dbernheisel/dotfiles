#!/usr/bin/env bash
# Claude Code Stop hook: run Elixir code quality checks
# Monorepo-aware: detects changed subprojects via git and runs checks in parallel.
# Single-project-aware: runs directly if mix.exs is in root with lib/.
# Auto-fixes formatting. Reports compile errors and credo issues back to Claude.

set -euo pipefail

# Skip if not an Elixir project
[ -f mix.exs ] || exit 0

# Find changed elixir files (staged, unstaged, or untracked)
changed_files=$(git diff --name-only HEAD 2>/dev/null; git diff --name-only --cached 2>/dev/null; git ls-files --others --exclude-standard 2>/dev/null)
elixir_changed=$(echo "$changed_files" | grep -E '\.(ex|exs|heex)$' | sort -u || true)

[ -n "$elixir_changed" ] || exit 0

# Detect project layout: monorepo (subproject dirs with mix.exs) vs single project
subprojects=()
if [ -d lib ]; then
  subprojects=(".")
else
  affected=$(echo "$elixir_changed" | cut -d/ -f1 | sort -u)
  for dir in $affected; do
    [ -f "$dir/mix.exs" ] && subprojects+=("$dir")
  done
fi

[ ${#subprojects[@]} -gt 0 ] || exit 0

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

for proj in "${subprojects[@]}"; do
  (
    proj_errors=""
    label="$proj"
    [ "$proj" = "." ] && label="(root)"

    cd "$proj"

    # 1. Auto-fix formatting (don't bother the agent)
    mix format 2>/dev/null || true

    # 2. Full compile with warnings-as-errors
    if ! compile_output=$(mix compile --warnings-as-errors 2>&1); then
      proj_errors+="## [$label] mix compile --warnings-as-errors FAILED
$compile_output

"
    fi

    # 3. Credo
    has_credo=false
    if [ -f .credo.exs ] || mix help credo >/dev/null 2>&1; then
      has_credo=true
    fi
    if $has_credo; then
      if ! credo_output=$(mix credo --strict 2>&1); then
        proj_errors+="## [$label] mix credo --strict FAILED
$credo_output

"
      fi
    fi

    if [ -n "$proj_errors" ]; then
      printf '%s' "$proj_errors" > "$tmpdir/$(echo "$proj" | tr / _)"
    fi
  ) &
done

wait

errors=""
for f in "$tmpdir"/*; do
  [ -f "$f" ] && errors+=$(cat "$f")
done

if [ -n "$errors" ]; then
  context=$(printf '%s' "$errors" | jq -Rs .)
  cat <<ENDJSON
{
  "decision": "block",
  "reason": "Elixir code quality checks failed",
  "hookSpecificOutput": {
    "hookEventName": "Stop",
    "additionalContext": $context
  }
}
ENDJSON
  exit 2
fi
