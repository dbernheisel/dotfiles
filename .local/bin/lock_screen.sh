#!/bin/bash
set -e

if pgrep i3 &> /dev/null && ! pgrep i3lock &> /dev/null; then
  lockmessage="Locked"
  deskshot="$HOME/.deskshot.png"
  lockshot="$HOME/.lockshot.png"
  font="Noto-Sans-Black"

  scrot "$deskshot"
  convert "$deskshot" \
    -filter Gaussian \
    -resize 10% \
    -define "filter:sigma=1.5" \
    -resize 1000.5% \
    -font "$font" \
    -pointsize 42 \
    -fill white \
    -stroke black \
    -gravity center \
    -annotate +0+160 "$lockmessage" \
    "$lockshot"

  rm "$deskshot" || true
  i3lock -i "$lockshot"

  sleep 600 # 10min
  pgrep i3lock && systemctl suspend-then-hibernate
fi

