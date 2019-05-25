#!/bin/bash

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
