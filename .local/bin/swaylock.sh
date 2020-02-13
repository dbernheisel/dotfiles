#!/bin/bash
DESKSHOT="$HOME/.deskshot.png"
LOCKSHOT="$HOME/.lockshot.png"

if ! pgrep -u $UID '^swaylock$'; then
  grim "$DESKSHOT"
  convert "$DESKSHOT" \
    -filter Gaussian \
    -resize 20% \
    -define "filter:sigma=1.9" \
    -resize 500.5% \
    "$LOCKSHOT" && \
  convert -composite "$LOCKSHOT" "$HOME/.local/lock-center.png" \
    -gravity center \
    -geometry +0+0 \
    "$LOCKSHOT"

  rm "$DESKSHOT" || true

  swaylock -e -s center -c 00000000 -i "$LOCKSHOT" && \
    swaymsg mode default && \
    (rm "$LOCKSHOT" || true)
fi
