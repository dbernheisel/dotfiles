#!/bin/bash

(
  killall nm-applet
  killall blueman-applet
  killall flameshot

  # This fixes an issue with the tray using lo-rez icons
  unset GDK_SCALE
  unset GDK_DPI_SCALE

  nm-applet --indicator & disown
  blueman-applet & disown
  if [ "$XDG_SESSION_TYPE" != "wayland" ]; then
    flameshot & disown
  fi
)

disown
