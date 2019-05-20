#!/bin/bash
set -ex

# I use SSH all the time, and that causes problems if you don't have an SSH
# key setup yet. The setup script will prompt that process.
mv ~/.gitconfig ~/.gitconfig-bak || true
git clone --bare --recursive https://github.com/dbernheisel/dotfiles.git "$HOME/.cfg"

function config {
  git --git-dir="$HOME/.cfg/" --work-tree="$HOME" "${@}"
}

if ! config checkout; then
  echo "Backing up pre-existing dot files.";
  mkdir -p "$HOME/.config-backup"
  config checkout 2>&1 | \
    grep -E "\s+\." | \
    sed 's/^\s*\(.*[^ \t]\)\(\s\+\)*$/\1/' | \
    tar cvpfz "backup-$(date +%F).tar.gz" -T -
  config reset --hard
fi

config checkout
mv ~/.gitconfig ~/.gitconfig-bak-checked
config submodule update --init --recursive
config config --local status.showUntrackedFiles no
config pull --recurse-submodules

read -p "Run setup? (y/n) " yn
case $yn in
  [Yy]*) "$HOME/.local/bin/initial-setup/setup-dotfiles.sh";;
  *) break:;
esac

mv ~/.gitconfig-bak-checked ~/.gitconfig
