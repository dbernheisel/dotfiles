#!/bin/sh

xrandr --output VIRTUAL1 --off \
  --output DP1 --off \
  --output DP2 --off \
  --output eDP1 --primary --mode 3840x2160 --pos 0x0 --rotate normal
