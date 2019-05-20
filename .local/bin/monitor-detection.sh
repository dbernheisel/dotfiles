#!/bin/bash

function is_connected() {
  local MON
  MON=$1; shift

  echo "checking connected $MON"
  xrandr -q | grep -w "connected" | grep -w "$MON" &> /dev/null
}

function is_active() {
  local MON
  local REZ
  MON=$1; shift

  if is_connected "$MON"; then
    echo "checking active $MON"
    REZ=$(xrandr -q | grep -w "$MON" | awk '{print $3}')
    if [ "$REZ" = "primary" ]; then
      true
    else
      echo "$REZ" | grep -P '\d' &> /dev/null
    fi
  else
    false
  fi
}
