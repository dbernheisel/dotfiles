#!/bin/bash
set -e
IGNORE=(linux linux-headers virtualbox-host-modules-arch)

if [ "$1" = "--no-kernel" ]; then
  shift;

  echo "Ignoring packages: ${IGNORE[*]}"
  ignore_flags=""
  for ignorable in "${IGNORE[@]}"; do
    ignore_flags="--ignore $ignorable ${ignore_flags}"
  done
  # shellcheck disable=SC2086
  sudo pacman -Syyu $ignore_flags
  yay -Su --aur
else
  sudo pacman -Syyu
  yay -Su --aur
fi
