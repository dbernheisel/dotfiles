#!/bin/bash
if xrandr -q | grep -w "connected" | grep -w DP1 &> /dev/null; then
  xrandr --output VIRTUAL1 --off \
    --output DP1 --mode 3840x1600 --pos 0x0 --rotate normal \
    --output eDP1 --primary --mode 3840x2160 --pos 0x1600 --rotate normal \
    --output DP2 --off
else
  echo "External display not detected"
fi
