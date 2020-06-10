#!/bin/bash

function have() {
  type "$1" &> /dev/null
}

if have "fdfind"; then
  alias fd=fdfind
fi

# Neovim
if have "nvim"; then
  function vim() {
    nvim "${@}"
  }
fi


if [[ $TERMINFO =~ "kitty" ]];  then
  function icat() {
    kitty +kitten icat "${@}"
  }

  if have "ranger"; then
    function ranger() {
      TERM=xterm-kitty command ranger "${@}"
    }
  fi
fi

# Set title easily
# usage: title "wat"
function title() {
  echo -ne "\033]0;$1\007"
}

# wrapper for plucking columns from output
# usage: echo "Hello \t hi" | col 2    #> "hi"
function col {
  awk -v col="$1" '{print $col}'
}

# Color cat
if have "bat"; then
 alias cat='bat -p'
elif have "ccat"; then
 alias cat='ccat'
fi

if have "awsume"; then
 alias awsume='source awsume'
fi

alias whatprocess='ps -p $$ -oargs='

# Git
alias gaa='git add -A'
alias gs='git status'
alias gd='git diff -W --color-moved'
alias gds='git diff -W --staged --color-moved'
alias undeployed='git fetch --multiple production origin && git log production/master..origin/master'

gcof() {
  if [ -z "$1" ]; then
    local tags branches target
    branches=$(
      git --no-pager branch --all \
          --format="%(if)%(HEAD)%(then)%(else)%(if:equals=HEAD)%(refname:strip=3)%(then)%(else)%1B[0;34;1mbranch%09%1B[m%(refname:short)%(end)%(end)" \
          | sed '/^$/d'
    ) || return
    tags=$(git --no-pager tag | awk '{print "\x1b[35;1mtag\x1b[m\t" $1}') || return
    target=$(
      (echo "$branches"; echo "$tags") | \
      fzf --no-hscroll --no-multi -n 2 --ansi --preview="git --no-pager log -150 --pretty=format:%s '..{2}'"
    ) || return
    if [[ "$target" =~ origin/ ]]; then
      git checkout --track "$(awk '{print $2}' <<< "$target")"
    else
      git checkout "$(awk '{print $2}' <<< "$target")"
    fi
  else
   git checkout "$1"
  fi
}

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
alias imp='iex --erl "+sbwt none +sbwtdcpu none +sbwtdio none" -S mix phx.server'
alias im='iex --erl "+sbwt none +sbwtdcpu none +sbwtdio none" -S mix'

if have "xclip"; then
  alias pbcopy='xclip -selection clipboard'
  alias pbpaste='xclip -o -selection clipboard'
fi

alias :q='exit'
alias weather='curl wttr.in'

alias ll='LC_COLLATE=C ls -lah'
alias df='df -h'

if have "exa"; then
  alias l='exa -1a'
  alias ls='exa'
  alias ll='exa -lh --git'
  alias lt='exa -lT --git'
fi

alias listen='lsof -P -i -n'
alias listen-ports='netstat -tulanp'

function extract() {
  if [ -f "$1" ] ; then
    case "$1" in
      *.tar.bz2) tar xjf "$1";;
      *.tar.gz)  tar xzf "$1";;
      *.bz2)     bunzip2 "$1";;
      *.rar)     unrar e "$1";;
      *.gz)      gunzip "$1";;
      *.tar)     tar xf "$1";;
      *.tbz2)    tar xjf "$1";;
      *.tgz)     tar xzf "$1";;
      *.zip)     unzip "$1";;
      *.Z)       uncompress "$1";;
      *.7z)      7z x "$1";;
      *)         echo "'$1' cannot be extracted via extract()";;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Protect thyself from self
if ! [[ "$OSTYPE" == darwin* ]]; then
  alias rm='nocorrect rm -i --preserve-root'
fi

alias memhog='ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head'

alias tmuxbase='tmux attach -t base || tmux new -s base'

if have "pacman"; then
  alias pacman='sudo pacman'
fi

# Notify function
if have "notify-send"; then
  # usage: do-something; alert [optional body] [optional title]
  function notify() {
    local NOTIFYSTATUS=$?
    local ICON
    ICON="$([ $NOTIFYSTATUS = 0 ] && echo terminal || echo error)"
    local BODY="${1-Exited with code: $NOTIFYSTATUS}"
    local TITLE="${2-Alert}"
    notify-send --urgency=low -i "$ICON" "$TITLE" "$BODY"
  }
fi

if [[ "$OSTYPE" == darwin* ]]; then
  function notify() {
    osascript -e 'on run {theText}' -e 'display notification theText with title "Terminal Notification" sound name "Glass"' -e 'end run' "$1"
  }
fi

alias csv-diff='git diff --color-words="[^[:space:],]+" --no-index'

if have "scanimage"; then
  # usage: scanimg test.jpg
  alias scanimg='scanimage --device="brother5:net1;dev0" --mode Color --format=jpeg --resolution=600 --batch > '
fi

if have "heroku"; then
  # usage: copy_heroku_db production my_app_dev
  function copy_heroku_db() {
    local heroku_app=$1; shift
    local local_db=$1; shift

    [[ -z $local_db ]] && echo "Please specify the local database to load into" && return 1

    heroku pg:backups:capture --app "$heroku_app" && \
    heroku pg:backups:download --app "$heroku_app" && \
    pg_restore --verbose --clean --no-acl --no-owner -h localhost -d "$1" latest.dump
  }
fi
