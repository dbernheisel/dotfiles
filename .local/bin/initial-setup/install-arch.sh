#!/bin/bash
# sourced from install.sh

sudo pacman -Sy --needed openssl openssh base-devel

(
  git clone https://aur.archlinux.org/yay.git ~/yay
  cd ~/yay || exit 1
  makepkg -si
)

for pkg in $(grep -E "^[^#;]" ~/Archfile | sort | uniq); do
  if pacman -Qi "$pkg" &> /dev/null; then continue; fi
  read -p "Install ${pkg}? (y/n) " yn
  case $yn in
    [Yy]*) yay -S "$pkg";;
    *) continue;;
  esac
done

#fancy_echo "Installing script to reset keyrate when waking up"
#sudo mkdir -p /usr/lib/systemd/system-sleep
#for hook in "$HOME/dotfiles/usr/lib/systemd/system-sleep/"*; do
  #sudo ln -vsf "$hook" "/usr/lib/systemd/system-sleep"
#done
