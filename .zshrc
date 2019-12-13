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

export PATH="$HOME/.local/bin:$PATH"

# awscli from brew auto-completion
if type aws &> /dev/null && [ -f ~/usr/local/share/zsh/site-functions/_aws ]; then
  source /usr/local/share/zsh/site-functions/_aws
fi

# Android Development
if [ -d ~/Libray/Android/sdk ]; then
  export ANDROID_HOME=~/Library/Android/sdk
fi

if [ -d ~/flutter/bin ]; then
  export PATH=~/flutter/bin:$PATH
fi

if [ -d /home/linuxbrew/.linuxbrew/bin ]; then
  export PATH="$(brew --prefix)/bin:$PATH"
fi

# PostgreSQL
export POSTGRES_USER=$(whoami)

# Elixir
export ERL_AFLAGS="-kernel shell_history enabled"
if [ -f ~/.elixir_ls/release/language_server.sh ]; then
  export PATH="$HOME/.elixir_ls/release:$PATH"
fi

# Kotlin
if [ -f ~/.kotlin_ls/build/install/kotlin-language-server/bin/kotlin-language-server ]; then
  export PATH="$HOME/.kotlin_ls/build/install/kotlin-language-server/bin:$PATH"
fi

# fzf Autocompletions
if type fzf &> /dev/null; then
  if [ -f /usr/share/fzf/key-bindings.zsh ]; then
    source /usr/share/fzf/key-bindings.zsh
  elif [ -f ~/.fzf.zsh ]; then
    source ~/.fzf.zsh
  else
    if type brew &> /dev/null; then
      echo "Running fzf install"
      $(brew --prefix)/opt/fzf/install
    fi
  fi
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
if [ $TERMINFO =~ "kitty" ]; then
  kitty + complete setup zsh | source /dev/stdin
fi

# RipGrep
export FZF_DEFAULT_OPTS='--color fg:-1,bg:-1,hl:230,fg+:3,bg+:233,hl+:229 --color info:150,prompt:110,spinner:150,pointer:167,marker:174'
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --glob "!.git/**/*" --glob "!_build/**/*" --glob "!.elixir_ls/**/*" --glob "!node_modules/**/*" --glob "!bower_components/**/*" --glob "!tmp/**/*" --glob "!coverage/**/*" --glob "!deps/**/*" --glob "!.hg/**/*" --glob "!.svn/**/*" --glob "!.sass-cache/**/*" --glob "!.Trash/**/*"'

[ -e $HOME/.local/bin/aliases.sh ] && source $HOME/.local/bin/aliases.sh
[ -e $HOME/.local/bin/aliases.zsh ] && source $HOME/.local/bin/aliases.zsh
[ -e $HOME/.secrets ] && source $HOME/.secrets

[[ "$OSTYPE" == linux* ]] && reset_keyrate.sh

[ -e "$HOME/.zshlocal" ] && source "$HOME/.zshlocal"
