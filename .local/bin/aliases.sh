#!/bin/bash

function have() {
  type "$1" &> /dev/null
}

# Neovim
if have "nvim"; then
  if have "nvr"; then
    function vim() {
      if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
        nvr -cc tabedit --remote-wait +'set bufhidden=wipe' "${@}"
      else
        nvim "${@}"
      fi
    }
  else
    function vim() {
      nvim "${@}"
    }
  fi
fi

if [[ $TERMINFO == *"kitty"* ]];  then
  function icat() {
    kitty +kitten icat "${@}"
  }

  function ranger() {
    TERM=xterm-kitty command ranger "${@}"
  }
fi

# Set title easily
function title() {
  echo -ne "\033]0;$1\007"
}

# wrapper for plucking columns from output
function col {
  awk -v col="$1" '{print $col}'
}

# Color cat
if have "ccat" &> /dev/null; then
 alias cat='ccat'
fi

if have "bat"; then
 alias cat='bat -p'
fi

# Git
alias gaa='git add -A'
alias gs='git status'
alias gd='git diff'
alias gds='git diff --staged --color-moved'
alias undeployed='git fetch --multiple production origin && git log production/master..origin/master'

# Homegit
alias config='git --git-dir="$HOME/.cfg/" --work-tree="$HOME"'

# Alias some ansible commands
if have "ansible-playbook"; then
  alias aplaybook='ansible-playbook'
fi

if have "ansible-vault"; then
  alias avault='ansible-vault'
fi

if have "ansible-galaxy"; then
  alias agalaxy='ansible-galaxy'
fi

if have "terraform"; then
  alias tf='terraform'
fi

if have "hub"; then
  function git() {
    hub "${@}"
  }
fi

# Android development
if [ -d "$HOME/Library/Android/sdk/platform-tools/adb" ]; then
  alias adb="~/Library/Android/sdk/platform-tools/adb"
fi

# Alias docker shortcuts
if have "docker"; then
  alias docker_rm_images='docker images --no-trunc | grep "<none>" | col 3 | xargs -r docker rmi'
  alias docker_rm_containers='docker ps --filter status=dead --filter status=exited -aq | xargs -r docker rm -v'
  alias docker_rm_volumes='docker volume ls -qf dangling=true | xargs -r docker volume rm'
  alias docker_reset='docker_rm_images && docker_rm_containers && docker_rm_volumes'
fi

# Alias some NPM tools
if have "googler"; then
  alias google='googler -n 10'
fi

# Alias some Ruby/Bundler/Rails commands
alias be='bundle exec'
alias sandbox='rails c --sandbox'

# Alias some Elixir/Phoenix commands
alias imp='iex -S mix phx.server'
alias im='iex -S mix'

if type "xclip" &> /dev/null; then
  alias pbcopy='xclip -selection clipboard'
  alias pbpaste='xclip -o -selection clipboard'
fi

# Alias SourceTree to open in current dir
alias sourcetree='open -a SourceTree ./'

alias :q='exit'
alias weather='curl wttr.in'

alias ll='ls -lah'

alias tmuxbase='tmux attach -t base || tmux new -s base'

if have "pacman"; then
  alias pacman='sudo pacman'
fi

if have "notify-send"; then
  alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
fi

alias csv-diff='git diff --color-words="[^[:space:],]+" --no-index'

if have "scanimage"; then
  # usage: scanimg test.jpg
  alias scanimg='scanimage --device="brother4:net1;dev0" --mode Color --format=jpeg --resolution=600 --batch > '
fi

# usage: copy_heroku_db production my_app_dev
if have "heroku"; then
  function copy_heroku_db() {
    local heroku_app=$1; shift
    local local_db=$1; shift

    [[ -z $local_db ]] && echo "Please specify the local database to load into" && return 1

    heroku pg:backups:capture --app "$heroku_app" && \
    heroku pg:backups:download --app "$heroku_app" && \
    pg_restore --verbose --clean --no-acl --no-owner -h localhost -d "$1" latest.dump
  }
fi
