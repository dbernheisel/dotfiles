#!/bin/bash

if [ "$(swaymsg -t get_outputs | grep -c name)" == 1 ]; then
  bash "$HOME/.local/bin/swayidle.sh" timeout-now
else
  notify-send "Clamshell mode" "Laptop screen off"
  swaymsg output "eDP-1" disable
fi
