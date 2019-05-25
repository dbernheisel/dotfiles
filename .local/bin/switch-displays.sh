#!/bin/bash
# DISPLAY_SCRIPTS=(~/.screenlayout/*.sh)

INTERNAL=eDP1
EXTERNAL1=DP1
EXTERNAL2=DP2
LOWER_DPI=$(grep Xft.dpi "$HOME/.Xresources-lower" | cut -d\  -f2)
HIGHER_DPI=$(grep Xft.dpi "$HOME/.Xresources" | cut -d\  -f2)

source "$HOME/.local/bin/monitor-detection.sh"

function lower_dpi() {
  notify "Lowering DPI" "$1"
  xrdb -merge ~/.Xresources-lower
  xrandr --dpi $LOWER_DPI
  sleep 2
  "$HOME/.local/bin/launch_polybar.sh"
}

function higher_dpi() {
  notify "Raising DPI" "$1"
  xrdb -merge ~/.Xresources
  xrandr --dpi $HIGHER_DPI
  sleep 2
  "$HOME/.local/bin/launch_polybar.sh"
}

if is_active $EXTERNAL2 && is_active $INTERNAL; then
  ~/.screenlayout/ultrawide2.sh
  lower_dpi "Turning on Ultrawide only - Port 2"
elif is_active $EXTERNAL1 && is_active $INTERNAL; then
  ~/.screenlayout/ultrawide1.sh
  lower_dpi "Turning on Ultrawide only - Port 1"
elif is_connected $EXTERNAL1 && is_active $INTERNAL; then
  ~/.screenlayout/dual1.sh
  higher_dpi "Turning on Dual screen - Ultrawide - Port 1"
elif is_connected $EXTERNAL2 && is_active $INTERNAL; then
  ~/.screenlayout/dual2.sh
  higher_dpi "Turning on Dual screen - Ultrawide - Port 2"
elif is_active $EXTERNAL1 && ! is_active $INTERNAL; then
  ~/.screenlayout/dual1.sh
  higher_dpi "Turning on Dual screen - Internal - Port 1"
elif is_active $EXTERNAL2 && ! is_active $INTERNAL; then
  ~/.screenlayout/dual2.sh
  higher_dpi "Turning on Dual screen - Internal - Port 2"
else
  ~/.screenlayout/internal.sh
  higher_dpi "Turning on internal screen"
fi

