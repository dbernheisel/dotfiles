#!/bin/bash

INTERNAL="eDP-1"
EXTERNAL1="DP-1"
EXTERNAL2="DP-2"
LOWER_DPI=$(grep Xft.dpi "$HOME/.Xresources-lower" | cut -d\  -f2)
HIGHER_DPI=$(grep Xft.dpi "$HOME/.Xresources" | cut -d\  -f2)

source "$HOME/.local/bin/monitor-detection.sh"

if [ "$(hostname)" == "zest" ]; then exit 0; fi

function notify() {
  local NOTIFYSTATUS=$?
  local ICON
  ICON="$([ $NOTIFYSTATUS = 0 ] && echo terminal || echo error)"
  local BODY="${1-Exited with code: $NOTIFYSTATUS}"
  local TITLE="${2-Alert}"
  notify-send --urgency=low -i "$ICON" "$TITLE" "$BODY"
}

function lower_dpi() {
  xrdb -merge ~/.Xresources-lower
  xrandr --dpi "$LOWER_DPI"
  sleep 2
  "$HOME/.local/bin/launch_polybar.sh"
  "$HOME/.local/bin/reset_keyrate.sh"
}

function higher_dpi() {
  xrdb -merge ~/.Xresources
  xrandr --dpi "$HIGHER_DPI"
  sleep 2
  "$HOME/.local/bin/launch_polybar.sh"
  "$HOME/.local/bin/reset_keyrate.sh"
}

if is_connected $EXTERNAL2 && ! is_active $EXTERNAL2 && is_active $INTERNAL; then
  notify "Lowering DPI" "Turning on Ultrawide only - Port 2"
  lower_dpi
  xrandr --output VIRTUAL1 --off \
    --output "$EXTERNAL1" --off \
    --output "$INTERNAL" --off \
    --output "$EXTERNAL2" --primary --mode 3840x1600 --pos 0x0 --rotate normal

elif is_connected $EXTERNAL1 && ! is_active $EXTERNAL1 && is_active $INTERNAL; then
  notify "Lowering DPI" "Turning on Ultrawide only - Port 1"
  lower_dpi
  xrandr --output VIRTUAL1 --off \
    --output "$EXTERNAL1" --primary --mode 3840x1600 --pos 0x0 --rotate normal \
    --output "$INTERNAL" --off \
    --output "$EXTERNAL2" --off
# elif is_connected $EXTERNAL1 && is_active $INTERNAL; then
#   higher_dpi "Turning on Dual screen - Ultrawide - Port 1"
    # xrandr --output VIRTUAL1 --off \
    #   --output "$EXTERNAL1" --mode 3840x1600 --pos 0x0 --rotate normal \
    #   --output "$INTERNAL" --primary --mode 3840x2160 --pos 0x1600 --rotate normal \
    #   --output "$EXTERNAL2" --off

# elif is_connected $EXTERNAL2 && is_active $INTERNAL; then
#   higher_dpi "Turning on Dual screen - Ultrawide - Port 2"
    # xrandr --output VIRTUAL1 --off \
    #   --output "$EXTERNAL1" --off \
    #   --output "$INTERNAL" --primary --mode 3840x2160 --pos 0x1600 --rotate normal \
    #   --output "$EXTERNAL2" --mode 3840x1600 --pos 0x0 --rotate normal
else
  notify "Raising DPI" "Switching to build-in screen"
  higher_dpi
  xrandr --output VIRTUAL1 --off \
    --output "$EXTERNAL1" --off \
    --output "$EXTERNAL2" --off \
    --output "$INTERNAL" --primary --mode 3840x2160 --pos 0x0 --rotate normal
fi
