#!/usr/bin/env bash
# Claude Code PostToolUse hook: fast compile warning check after each .ex edit.
# Uses --no-deps-check --no-compile for speed (loads code, checks warnings, no BEAM output).
set -euo pipefail

input=$(cat)

# Extract file path from hook JSON
file_path=$(echo "$input" | jq -r '.tool_input.file_path // .tool_response.filePath // empty')
[ -n "$file_path" ] || exit 0

# Only check .ex files (not .exs — those compile on demand)
[[ "$file_path" == *.ex ]] || exit 0
[ -f "$file_path" ] || exit 0

# Walk up to find mix.exs
dir=$(dirname "$file_path")
while [[ "$dir" != "/" ]]; do
  if [[ -f "$dir/mix.exs" ]]; then
    cd "$dir"

    # Skip if a BEAM process is running in this project (Phoenix/IEx hot-reload)
    project_dir=$(pwd -P)
    if lsof -c beam.smp -a -d cwd 2>/dev/null | grep -q "$project_dir"; then
      exit 0
    fi

    if ! output=$(mix compile --warnings-as-errors --no-deps-check --no-compile 2>&1); then
      echo "$output"
      exit 1
    fi
    break
  fi
  dir=$(dirname "$dir")
done
