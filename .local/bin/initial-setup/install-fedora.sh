# sourced from install.sh

if ! grep "^[^#;]" ~/Dnffile | sort -u | xargs sudo dnf install -y; then
  fancy_echo "Could not install system utilities. Please install those and then re-run this script" "$red"
  exit 1
fi
