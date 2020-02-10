#!/bin/bash

set -e

SWAYSHOT_SCREENSHOTS="$HOME/Downloads"

if [[ -z "$WAYLAND_DISPLAY" ]]; then
  (>&2 echo Wayland is not running)
  exit 1
fi

if [[ -z $SWAYSHOT_SCREENSHOTS ]]; then
  SWAYSHOT_SCREENSHOTS=$(xdg-user-dir PICTURES)
fi

SCREENSHOT_TIMESTAMP=$(date "+${SWAYSHOT_DATEFMT:-%Y%m%d-%H%M%S}")
SCREENSHOT_FULLNAME="$SWAYSHOT_SCREENSHOTS"/screenshot-${SCREENSHOT_TIMESTAMP}.png

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
  convert "$SCREENSHOT_FULLNAME" \( +clone -background black -shadow 50x8+0+5 \) +swap -background none -layers merge +repage "$SCREENSHOT_FULLNAME"
}

get_window() {
  local AREA
  AREA=$(swaymsg --type get_tree --raw | jq --raw-output "${filter}")
  grim -g "$AREA" "$SCREENSHOT_FULLNAME"
  add_shadow
}

get_region() {
  local AREA
  AREA=$(slurp -b '#45858820' -c '#45858880' -s '#00000000' -w 3 -d)
  [[ "$AREA" == "" ]] && exit 1
  grim -g "$AREA" "$SCREENSHOT_FULLNAME"
}

get_desktop() {
  local AREA
  AREA=$(swaymsg --type get_outputs --raw | jq --raw-output '.[] | select(.focused) | .name')
  grim -o "$AREA" "$SCREENSHOT_FULLNAME"
}

edit_image() {
  local EDITED
  EDITED=$(ksnip -s -e "$SCREENSHOT_FULLNAME" 2>&1 | grep "Image Saved" | tail -1 | sed 's/Image Saved: Saved to //')
  if [ "$EDITED" == "" ]; then exit 1; fi
  SCREENSHOT_FULLNAME="$EDITED"
}

case "$1" in
  region) get_region;;
  region-edit) get_region && edit_image;;
  window) get_window;;
  window-edit) get_window && edit_image;;
  desktop) get_desktop;;
  desktop-edit) get_desktop && edit_image;;
  *)
    echo 'Usage: swayshot [region-edit|region|window|window-edit|desktop]'
    exit 1
    ;;
esac

notify-send "Screenshot saved" "$(basename "$SCREENSHOT_FULLNAME")"

if type wl-copy &> /dev/null; then
  wl-copy < "$SCREENSHOT_FULLNAME"
fi
