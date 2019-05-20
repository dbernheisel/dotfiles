# sourced from install.sh
fancy_echo "Installing essential source-building packages" "$yellow"
fancy_echo "This may ask for sudo access for installs..." "$yellow"
if ! grep "^[^#;]" ~/Aptfile | sort -u | xargs sudo apt-get install -y; then
  fancy_echo "Could not install system utilities. Please install those and then re-run this script" "$red"
  exit 1
fi

if ! type keybase 2>/dev/null; then
  fancy_echo "Installing Keybase ..." "$yellow"
  curl --remote-name https://prerelease.keybase.io/keybase_amd64.deb
  sudo dpkg -i keybase_amd64.deb
  sudo apt-get install -f
  run_keybase
fi

if [ ! -e /etc/apt/sources.list.d/yarn.list ]; then
  fancy_echo "Installing Yarn ..." "$yellow"
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list
  sudo apt update
  sudo apt install --no-install-recommends yarn
fi

if [ ! -e /etc/apt/sources.list.d/google-chrome.list ]; then
  fancy_echo "Installing Google Chrome ..." "$yellow"
  curl -sS https://dl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
  echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
fi

fancy_echo "Installing Google Drive" "$yellow"
sudo add-apt-repository ppa:alessandro-strada/ppa

fancy_echo "Installing Adapta GTK Theme..." "$yellow"
sudo add-apt-repository ppa:tista/adapta

fancy_echo "Installing Papirus GTK Icons ..." "$yellow"
sudo add-apt-repository ppa:papirus/papirus

if [ ! -e /etc/apt/sources.list.d/pgdg.list ]; then
  fancy_echo "Installing PostgreSQL 9.6..." "$yellow"
  echo "deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main" | sudo tee /etc/apt/sources.list.d/pgdg.list
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
fi

sudo apt update

sudo apt install postgresql-9.6 google-chrome-stable papirus-icon-theme adapta-gtk-theme google-drive-ocamlfuse

pip3 install pywal
