#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

# Customize to your needs...
setopt extended_glob
unsetopt nomatch

typeset -U path
path[1,0]=$HOME/.local/bin

if [ -f /usr/share/applications/google-chrome.desktop ]; then
  export BROWSER=/usr/bin/google-chrome-stable
fi

# awscli from brew auto-completion
if type aws &> /dev/null && [ -f /usr/local/share/zsh/site-functions/_aws ]; then
  source /usr/local/share/zsh/site-functions/_aws
fi

if type rg &>/dev/null; then
  export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"
fi

# Android Development
if [ -d ~/Libray/Android/sdk ]; then
  export ANDROID_HOME=~/Library/Android/sdk
fi

if [ -d ~/flutter/bin ]; then
  export PATH=~/flutter/bin:$PATH
fi

if [ -d ~/.yarn/bin ]; then
  export PATH=~/.yarn/bin:$PATH
fi

if [ -d ~/.cargo/bin ]; then
  export PATH=~/.cargo/bin:$PATH
fi

if [ -d /home/linuxbrew/.linuxbrew/bin ]; then
  export PATH="$(brew --prefix)/bin:$PATH"
fi

# PostgreSQL
export POSTGRES_USER=$(whoami)

# Elixir
export ERL_AFLAGS="-kernel shell_history enabled"

# Kotlin
if [ -f ~/.kotlin_ls/build/install/kotlin-language-server/bin/kotlin-language-server ]; then
  export PATH="$HOME/.kotlin_ls/build/install/kotlin-language-server/bin:$PATH"
fi

# fzf Autocompletions
if type fzf &> /dev/null; then
  if [ -f /usr/share/fzf/key-bindings.zsh ]; then
    source /usr/share/fzf/key-bindings.zsh
    source /usr/share/fzf/completion.zsh
    bindkey '^I' $fzf_default_completion
  elif [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]; then
    source /usr/share/doc/fzf/examples/key-bindings.zsh
  elif [ -f ~/.fzf.zsh ]; then
    source ~/.fzf.zsh
  else
    if type brew &> /dev/null; then
      echo "Running fzf install"
      $(brew --prefix)/opt/fzf/install
    fi
  fi
  # export FZF_COMPLETION_TRIGGER=''
  # bindkey '^T' fzf-completion

fi

if type awsume &> /dev/null; then
  compdef _awsume awsume-autocomplete
fi

# asdf version manager
[ -e $HOME/.asdf/asdf.sh ] && source $HOME/.asdf/asdf.sh
[ -e $HOME/.asdf/asdf.sh ] && source $HOME/.asdf/completions/asdf.bash

# Newer git
if type brew &> /dev/null && [ -f $(brew --prefix git)/bin/git ]; then
  export PATH=$(brew --prefix git)/bin:$PATH
fi

# Rust
if [ -d "$HOME/.cargo/bin" ]; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

# Kitty
if ! [ -z "$TERMINFO" ] && [ $TERMINFO =~ "kitty" ]; then
  kitty + complete setup zsh | source /dev/stdin
fi

# RipGrep
export FZF_DEFAULT_COMMAND='rg --files'

[ -e $HOME/.local/bin/aliases.sh ] && source $HOME/.local/bin/aliases.sh
[ -e $HOME/.local/bin/aliases.zsh ] && source $HOME/.local/bin/aliases.zsh
[ -e $HOME/.secrets ] && source $HOME/.secrets

gcof() {
  if [ -z $1 ]; then
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
   git checkout $1
  fi
}

bindkey '^GB' gcof

[[ "$OSTYPE" == linux* ]] && reset_keyrate.sh

[ -e "$HOME/.zshlocal" ] && source "$HOME/.zshlocal"
