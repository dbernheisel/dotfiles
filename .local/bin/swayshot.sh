#!/bin/bash

set -e

SWAYSHOT_DIR="$HOME/screenshots"

if [[ -z "$WAYLAND_DISPLAY" ]]; then
  (>&2 echo Wayland is not running)
  exit 1
fi

mkdir -p "$SWAYSHOT_DIR" || true &> /dev/null

if [[ -z $SWAYSHOT_DIR ]]; then
  SWAYSHOT_DIR=$(xdg-user-dir PICTURES)
fi

SCREENSHOT_TIMESTAMP=$(date "+${SWAYSHOT_DATEFMT:-%Y%m%d-%H%M%S}")
SCREENSHOT_FILE="$SWAYSHOT_DIR"/screenshot-${SCREENSHOT_TIMESTAMP}.png

declare -r filter='
# returns the focused node by recursively traversing the node tree
def find_focused_node:
    if .focused then . else (if .nodes then (.nodes | .[] | find_focused_node) else empty end) end;
# returns a string in the format that grim expects
def format_rect:
    "\(.rect.x),\(.rect.y) \(.rect.width)x\(.rect.height)";
find_focused_node | format_rect
'

add_shadow() {
  convert "$SCREENSHOT_FILE" \( +clone -background black -shadow 50x8+0+5 \) +swap -background none -layers merge +repage "$SCREENSHOT_FILE"
}

get_window() {
  local AREA
  AREA=$(swaymsg --type get_tree --raw | jq --raw-output "${filter}")
  grim -g "$AREA" "$SCREENSHOT_FILE"
  swappy -f "$SCREENSHOT_FILE" -o "$SCREENSHOT_FILE"
  add_shadow
}

get_region() {
  local AREA
  AREA=$(slurp -b '#45858820' -c '#45858880' -s '#00000000' -w 3 -d)
  [[ "$AREA" == "" ]] && exit 1
  grim -g "$AREA" "$SCREENSHOT_FILE"
  swappy -f "$SCREENSHOT_FILE" -o "$SCREENSHOT_FILE"
}

get_desktop() {
  local AREA
  OUTPUT=$(swaymsg --type get_outputs --raw | jq --raw-output '.[] | select(.focused) | .name')
  grim -o "$OUTPUT" "$SCREENSHOT_FILE"
  swappy -f "$SCREENSHOT_FILE" -o "$SCREENSHOT_FILE"
}

{
case "$1" in
  region) get_region;;
  window) get_window;;
  desktop) get_desktop;;
  *)
    echo 'Usage: swayshot [region|window|desktop]'
    exit 1
    ;;
esac
} > ~/.swayshot.log 2>&1
