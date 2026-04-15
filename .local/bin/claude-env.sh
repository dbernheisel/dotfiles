#!/usr/bin/env bash

# Activate the tool version manager (mise or asdf) so that Claude Code
# uses the correct versions of Elixir, Erlang, Node.js, etc.

if command -v mise &> /dev/null; then
  eval "$(mise activate bash)"
fi

# Persist the updated PATH (and any other env vars) for Claude Code's
# subsequent Bash tool calls.
if [ -n "$CLAUDE_ENV_FILE" ]; then
  echo "PATH=\"$PATH\"" >> "$CLAUDE_ENV_FILE"
fi
