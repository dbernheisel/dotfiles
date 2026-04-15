#!/usr/bin/env bash
# claude-ghostty-notify.sh
# Prepends a 🟡 yellow square to the Ghostty tab title when Claude Code
# is awaiting input, using OSC 2 (set window/tab title).
#
# Install: ~/.local/bin/claude-ghostty-notify.sh

set -euo pipefail

INDICATOR="🟡"
TITLE="${INDICATOR} Claude Code - Awaiting Input"

tty_target="${TTY:-/dev/tty}"
printf "\033]2;%s\033\\" "$TITLE" > "$tty_target" 2>/dev/null || true
