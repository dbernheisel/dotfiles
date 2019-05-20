#!/bin/bash
if xrandr -q | grep -w "connected" | grep -w DP2 &> /dev/null; then
  xrandr --output VIRTUAL1 --off \
    --output DP1 --off \
    --output eDP1 --off \
    --output DP2 --primary --mode 3840x1600 --pos 0x0 --rotate normal
fi
