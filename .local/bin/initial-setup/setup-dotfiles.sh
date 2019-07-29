#!/bin/bash

INITIALSCRIPTS="$HOME/.local/bin/initial-setup"

#### Helper funcions
column() {
  printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
}

mkcolor() {
  # shellcheck disable=SC1117
  [ "${BASH_VERSINFO[0]}" -le "3" ] && echo -e "\033[00;$1m" || echo "\e[0;$1m"
}

mkbold() {
  # shellcheck disable=SC1117
  [ "${BASH_VERSINFO[0]}" -le "3" ] && echo -e "\033[1;$1m" || echo "\e[1;$1m"
}

prompt_install() {
  local RETVALUE=0
  read -rp "Install $1? [y/n] " yn
  case $yn in
    [Yy]*) RETVALUE=0;;
    * ) RETVALUE=1
  esac
  return $RETVALUE
}

clearcolor=$(mkcolor 0)
yellow=$(mkbold 33)
red=$(mkbold 31)

fancy_echo() {
  local fmt="$1"; shift
  local color="$1"; shift

  # shellcheck disable=SC2059
  # shellcheck disable=SC1117
  printf "$color$fmt$clearcolor\n" "$@"
}

gem_install_or_update() {
  if type gem &> /dev/null; then
    if gem list "$1" --installed > /dev/null; then
      gem update "$@"
    else
      gem install "$@"
    fi
  fi
}

pip_install_or_update() {
  if type pip &> /dev/null; then pip install --user "$1" -U; fi
  if type pip2 &> /dev/null; then pip2 install --user "$1" -U; fi
  if type pip3 &> /dev/null; then pip3 install --user "$1" -U; fi
}

yarn_install_or_update() {
  if type yarn &> /dev/null; then
    yarn global add "$1" --latest
  fi
}

is_mac() {
  if [[ "$OSTYPE" == darwin* ]]; then
    return 0
  else
    return 1
  fi
}

is_linux() {
  if [[ "$OSTYPE" == linux* ]]; then
    return 0
  else
    return 1
  fi
}

is_debian() {
  if [ -f /etc/debian_version ]; then
    return 0
  else
    return 1
  fi
}

is_fedora() {
  if is_linux && uname -a | grep -q Fedora; then
    return 0
  else
    return 1
  fi
}

is_arch() {
  if is_linux && uname -a | grep -Eq 'manjaro|antergos|arch'; then
    return 0
  else
    return 1
  fi
}

if [ ! -f "$HOME/.ssh/id_rsa.pub" ]; then
  column
  fancy_echo "You need to generate an SSH key" "$red"
  ssh-keygen
fi

#### Prerequisites, like xcode and homebrew
if is_debian; then source "$INITIALSCRIPTS/install-debian.sh"; fi
if is_fedora; then source "$INITIALSCRIPTS/install-fedora.sh"; fi
if is_arch; then source "$INITIALSCRIPTS/install-arch.sh"; fi
if is_mac; then source "$INITIALSCRIPTS/install-mac.sh"; fi

#### Install zsh
column
fancy_echo "Changing your shell to zsh ..." "$yellow"
chsh -l
chsh

#### Setup dotfiles
column

if [ ! -e "$HOME/.secrets" ]; then
  fancy_echo "Creating secrets file" "$yellow"
  touch "$HOME/.secrets"
fi

if [ ! -e "$HOME/.zshlocal" ]; then
  fancy_echo "Creating local zsh config" "$yellow"
  touch "$HOME/.zshlocal"
fi

#### asdf Install, plugins, and languages
column
install_asdf() {
  if [ ! -d "$HOME/.asdf" ]; then
    fancy_echo "Installing asdf ..." "$yellow"
    git clone git://github.com/asdf-vm/asdf.git "$HOME/.asdf"
  fi

  # shellcheck disable=SC1090
  source "$HOME/.asdf/asdf.sh"
}

install_asdf_plugin() {
  local language="$1"; shift
  if ! asdf plugin-list | grep -v "$language" >/dev/null; then
    asdf plugin-add "$language"
  fi
}

install_asdf
if type asdf &> /dev/null; then
  fancy_echo "Installing languages through asdf ..." "$yellow"
  if prompt_install "Ruby"; then install_asdf_plugin ruby; fi
  if prompt_install "Elixir"; then install_asdf_plugin elixir; fi
  if prompt_install "NodeJS"; then install_asdf_plugin nodejs; fi
  asdf install
fi

#### Tools
column
fancy_echo "Installing neovim plugins for languages" "$yellow"
pip_install_or_update neovim
pip_install_or_update neovim-remote

fancy_echo "Installing language servers" "$yellow"
yarn_install_or_update vscode-json-languageserver-bin
yarn_install_or_update vscode-html-languageserver-bin
yarn_install_or_update vscode-css-languageserver-bin
yarn_install_or_update ocaml-language-server
yarn_install_or_update typescript-language-server
yarn_install_or_update bash-language-server
yarn_install_or_update markdownlint-cli
yarn_install_or_update write-good

(
  cd ~/.elixir_ls || exit 1
  if type mix &> /dev/null; then
    mix deps.get && mix.compile
    mix elixir_ls.release - .
  fi
)
(
  cd ~/.kotlin_ls || exit 1
  if type java &> /dev/null; then
    ./gradlew installDist
  fi
)

fancy_echo "Registering tmux terminfo for italics" "$yellow"
tic "$HOME/.tmux-italics.terminfo"

if is_linux && ! type kitty &> /dev/null && prompt_install "Kitty terminal"; then
  curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n
fi

column
fancy_echo "Installing neovim plugins for languages" "$yellow"

column
fancy_echo "Installing user fonts" "$yellow"

if is_mac; then
  ln -sf "$HOME/.local/share/fonts" "$HOME/Library/Fonts"
fi
if is_linux && type fc-cache &>/dev/null; then
  fc-cache -vf "$HOME/.local/share/fonts"
fi
