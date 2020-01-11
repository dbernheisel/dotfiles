#!/bin/bash
# sourced from install.sh

is_crostini() {
  if [ -d /etc/systemd/user/sommelier@0.service.d ]; then
    return 0
  else
    return 1
  fi
}

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

if is_crostini; then
  yay cros-container-guest-tools-git wayland xorg-server-xwayland gnome-packagekit downgrader xorg-xauth

  echo "Downgrade systemd to 241"
  downgrader systemd

  systemctl --user enable sommelier-x@0
  systemctl --user enable sommelier@0
  systemctl --user start sommelier-x@0
  systemctl --user start sommelier@0

  sudo sed -i '/^#en_US\.UTF-8.*/s/^#//' /etc/locale.gen
  sudo locale-gen

  echo "Edit the file /usr/share/X11/xkb/keycodes/evdev"
  echo "And comment out i372 and i374 codes"
  echo ""
  echo "Restart the container from termina: "
  echo "lxc stop my_image && lxc start my_image"
fi
