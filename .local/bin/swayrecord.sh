#!/bin/bash

set -e

SWAYRECORD_DIR="$HOME/videoshots"

if [[ -z "$WAYLAND_DISPLAY" ]]; then
  (>&2 echo Wayland is not running)
  exit 1
fi

mkdir -p "$SWAYRECORD_DIR" || true &> /dev/null

if [[ -z $SWAYRECORD_DIR ]]; then
  SWAYRECORD_DIR=$(xdg-user-dir VIDEOS)
fi

SWAYRECORD_TIMESTAMP=$(date "+${SWAYRECORD_DATEFMT:-%Y%m%d-%H%M%S}")
SWAYRECORD_FILE="$SWAYRECORD_DIR"/recording-${SWAYRECORD_TIMESTAMP}.mp4

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
  if pgrep wf-recorder; then kill wf-recorder; fi

  wf-recorder -f "$SWAYRECORD_FILE" -m mp4 --force-yuv -c h264_vaapi -d /dev/dri/renderD128 --geometry="$AREA" &
  notify-send -t 2000 "Wayland recording has been started at $SWAYRECORD_FILE"
}

{
case "$1" in
  stop)
    if pgrep wf-recorder > /dev/null; then
      pkill wf-recorder &> /dev/null
      notify-send -t 2000 "Screen recording has been stopped"
    fi
    ;;

  is-recording)
    if pgrep wf-recorder > /dev/null; then
      notify-send -t 2000 "Screen is recording"
    else
      notify-send -t 2000 "No screen recording"
    fi
    ;;

  region)
    AREA=$(slurp -b '#45858820' -c '#45858880' -s '#00000000' -w 3 -d)
    start_recording "$AREA"
    ;;

  window)
    AREA=$(swaymsg --type get_tree --raw | jq --raw-output "${filter}")
    start_recording "$AREA"
    ;;

  desktop)
    AREA=$(
      swaymsg -t get_workspaces -r | jq -r '.[] | select(.focused) | .rect | "\(.x),\(.y) \(.width)x\(.height)"'; \
    )
    start_recording "$AREA"
    ;;
esac
} > ~/.swayrecord.log 2>&1
