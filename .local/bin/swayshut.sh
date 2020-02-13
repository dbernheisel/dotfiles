#!/bin/bash

if [ "$(swaymsg -t get_outputs | grep -c name)" == 1 ]; then
  exec "$HOME/.local/bin/swayidle.sh" now
else
  notify-send "Clamshell mode" "Laptop screen off"
  swaymsg output "eDP-1" disable
fi
