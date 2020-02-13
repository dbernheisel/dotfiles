#!/bin/bash

if ! lsmod | grep v4l2loopback &> /dev/null; then
  sudo modprobe v4l2loopback devices=1 video_nr=10 card_label="Desktop" exclusive_caps=1
fi

declare -r filter='
# returns the focused node by recursively traversing the node tree
def find_focused_node:
    if .focused then . else (if .nodes then (.nodes | .[] | find_focused_node) else empty end) end;
# returns a string in the format that grim expects
def format_rect:
    "\(.rect.x),\(.rect.y) \(.rect.width)x\(.rect.height)";
find_focused_node | format_rect
'

start_recording() {
  local AREA="$1"
  EXISTING=$(pgrep wf-recorder)
  wf-recorder --muxer=v4l2 --codec=rawvideo --pixel-format=yuv420p --file=/dev/video10 --geometry="$AREA" &
  kill "$EXISTING"
  notify-send -t 2000 "Wayland recording has been started"
}

start_player() {
  pkill ffplay &> /dev/null
  sleep 2
  SDL_VIDEODRIVER="" ffplay /dev/video10 -window_title "screenshare-preview"
}

{
case "$1" in
  stop)
    if pgrep wf-recorder > /dev/null; then
      pkill ffplay &> /dev/null
      pkill wf-recorder &> /dev/null
      notify-send -t 2000 "Wayland recording has been stopped"
    fi
    ;;

  is-recording)
    if pgrep wf-recorder > /dev/null; then
      notify-send -t 2000 "Wayland recording is up"
    else
      notify-send -t 2000 "No Wayland recording"
    fi
    ;;

  region)
    AREA=$(slurp -b '#45858820' -c '#45858880' -s '#00000000' -w 3 -d)
    start_recording "$AREA"
    start_player
    ;;

  window)
    AREA=$(swaymsg --type get_tree --raw | jq --raw-output "${filter}")
    start_recording "$AREA"
    start_player
    ;;

  desktop)
    EXISTING=$(pgrep wf-recorder)
    AREA=$(
      swaymsg -t get_workspaces -r | jq -r '.[] | select(.focused) | .rect | "\(.x),\(.y) \(.width)x\(.height)"'; \
    )
    start_recording "$AREA"
    start_player
    ;;
esac
} > ~/.wayland-screen-share.log 2>&1
