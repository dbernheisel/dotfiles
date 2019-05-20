# sourced from install.sh
sudo pacman -Sy openssl openssh base-devel

(
  git clone https://aur.archlinux.org/yay.git ~/yay
  cd ~/yay || exit 1
  makepkg -si
)

yay -S --needed "$(comm -12 <(pacman -Slq | sort) <(! grep "^[^#;]" ~/Archfile | sort | uniq))"

#fancy_echo "Installing script to reset keyrate when waking up"
#sudo mkdir -p /usr/lib/systemd/system-sleep
#for hook in "$HOME/dotfiles/usr/lib/systemd/system-sleep/"*; do
  #sudo ln -vsf "$hook" "/usr/lib/systemd/system-sleep"
#done
