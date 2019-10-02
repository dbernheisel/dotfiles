#!/bin/sh
set -e

delay_before_suspend="30m"
suspend_now="${1:-no}"

# lockmessage="Locked"
# deskshot="$HOME/.deskshot.png"
# lockshot="$HOME/.lockshot.png"
# font="Noto-Sans-Black"
#
# scrot "$deskshot"
# convert "$deskshot" \
#   -filter Gaussian \
#   -resize 20% \
#   -define "filter:sigma=1.5" \
#   -resize 500.5% \
#   -font "$font" \
#   -pointsize 42 \
#   -fill white \
#   -stroke black \
#   -gravity center \
#   -annotate +0+160 "$lockmessage" \
#   "$lockshot"
#
# rm "$deskshot" || true
# i3lock -i "$lockshot"
#

[ "$suspend_now" = "no" ] && sleep $delay_before_suspend
systemctl suspend
