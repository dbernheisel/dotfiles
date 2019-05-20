#!/bin/bash
if xrandr -q | grep -w "connected" | grep -w DP2 &> /dev/null; then
  xrandr --output VIRTUAL1 --off \
    --output DP1 --off \
    --output eDP1 --primary --mode 3840x2160 --pos 0x1600 --rotate normal \
    --output DP2 --mode 3840x1600 --pos 0x0 --rotate normal
else
  echo "External display not detected"
fi
