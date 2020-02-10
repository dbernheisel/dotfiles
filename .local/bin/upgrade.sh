#!/bin/bash
set -e

echo "Available: --firmware, --kernel"

is_crostini() {
  if [ -d /etc/systemd/user/sommelier@0.service.d ]; then
    return 0
  else
    return 1
  fi
}

## ARCH LINUX

if [ -f "/etc/arch-release" ]; then
  IGNORE=(linux linux-lts linux-headers virtualbox-host-modules-arch)

  if [[ "$1" = *--kernel* ]]; then
    shift;
    if is_crostini; then
      echo "Cannot upgrade kernel within Crostini"
      exit 1
    fi

    sudo pacman -Syyu
  else
    echo "Ignoring packages: ${IGNORE[*]}"
    IGNORE_FLAGS=""
    for IGNORABLE in "${IGNORE[@]}"; do
      IGNORE_FLAGS="--ignore $IGNORABLE ${IGNORE_FLAGS}"
    done
    # shellcheck disable=SC2086
    sudo pacman -Syyu $IGNORE_FLAGS
  fi
  if type yay &> /dev/null; then yay -Su --aur; fi

  if ! is_crostini && type fwupdmgr &> /dev/null && [[ "$1" = *--firmware* ]]; then
    fwupdmgr refresh
    fwupdmgr get-updates --no-unreported-check
  fi
fi

## DEBIAN

if [ -f "/etc/debian_release" ]; then
  IGNORE=(linux linux-lts linux-headers virtualbox-host-modules-arch)

  if [ "$1" = "--kernel" ]; then
    shift;
    if is_crostini; then
      echo "Cannot upgrade kernel within Crostini"
      exit 1
    fi
    sudo apt upgrade
  else
    for IGNORABLE in "${IGNORE[@]}"; do
      sudo apt-mark hold "$IGNORABLE"
    done

    sudo apt upgrade

    for IGNORABLE in "${IGNORE[@]}"; do
      sudo apt-mark unhold "$IGNORABLE"
    done
  fi
fi

if ! is_crostini && type fwupdmgr &> /dev/null && [[ "$1" = *--firmware* ]]; then
  fwupdmgr refresh
  fwupdmgr get-updates --no-unreported-check
fi
