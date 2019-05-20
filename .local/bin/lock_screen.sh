#!/bin/sh
set -e

lockmessage="Locked"
delay_before_suspend="30m"

deskshot=$(mktemp --suffix=.png)
lockshot=$(mktemp --suffix=.png)
font="Noto-Sans-Black"
suspend_now="${1:-no}"

scrot "$deskshot"
convert "$deskshot" \
  -filter Gaussian \
  -resize 20% \
  -define "filter:sigma=1.5" \
  -resize 500.5% \
  -font "$font" \
  -pointsize 42 \
  -fill white \
  -stroke black \
  -gravity center \
  -annotate +0+160 "$lockmessage" \
  "$lockshot"

rm "$deskshot" || true
i3lock -i "$lockshot"

if [ "$suspend_now" = "suspend" ]; then
  systemctl suspend
else
  sleep $delay_before_suspend
  pgrep i3lock && systemctl suspend
fi
