# sourced from setup-dotfiles.sh
fancy_echo "Installing essential source-building packages" "$yellow"
fancy_echo "This may ask for sudo access for installs..." "$yellow"
if ! grep "^[^#;]" ~/Aptfile | sort -u | xargs sudo apt-get install -y; then
  fancy_echo "Could not install system utilities. Please install those and then re-run this script" "$red"
  exit 1
fi
