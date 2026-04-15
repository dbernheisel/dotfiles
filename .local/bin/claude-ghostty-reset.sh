#!/usr/bin/env bash
# claude-ghostty-reset.sh
# Resets the Ghostty tab title after user submits input to Claude Code.
# Clears the 🟡 indicator by resetting the title so the shell can take over.
#
# Install: ~/.local/bin/claude-ghostty-reset.sh

set -euo pipefail

# --- Write empty OSC 2 to let shell reclaim the title ---
tty_target="${TTY:-/dev/tty}"
printf "\033]2;\033\\" > "$tty_target" 2>/dev/null || true
