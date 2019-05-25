#!/bin/bash
source "$HOME/.local/bin/monitor-detection.sh"

killall polybar

while pgrep -u $UID -x polybar > /dev/null; do sleep 0.5; done

if type "xrandr" &>/dev/null; then
  for m in $(xrandr -q | grep -w "connected" | cut -d" " -f1); do
    if is_active "$m"; then
      MONITOR="$m" polybar --reload top &
    fi
  done
else
  polybar --reload top &
fi

source "$HOME/.local/bin/launch_tray.sh"

disown
