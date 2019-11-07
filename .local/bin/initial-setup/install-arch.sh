#!/bin/bash
# sourced from install.sh

sudo pacman -Sy --needed openssl openssh base-devel

(
  git clone https://aur.archlinux.org/yay.git ~/yay
  cd ~/yay || exit 1
  makepkg -si
  rm -rfv ~/yay
)

for pkg in $(grep -E "^[^#;]" ~/Archfile | sort | uniq); do
  if pacman -Qi "$pkg" &> /dev/null; then continue; fi
  read -rp "Install ${pkg}? (y/n) " yn
  case $yn in
    [Yy]*) yay -S "$pkg";;
    *) continue;;
  esac
done
