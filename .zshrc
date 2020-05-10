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

function have() {
  type "$1" &> /dev/null
}

# Customize to your needs...
setopt extended_glob
unsetopt nomatch

typeset -U path
path[1,0]=$HOME/.local/bin

if [ -f /usr/share/applications/google-chrome.desktop ]; then
  export BROWSER=/usr/bin/google-chrome-stable
fi

# awscli from brew auto-completion
if have aws && [ -f /usr/local/share/zsh/site-functions/_aws ]; then
  source /usr/local/share/zsh/site-functions/_aws
fi

if have rg; then
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

# fzf default command
if have fzf; then
  # RipGrep
  type rg &> /dev/null && export FZF_DEFAULT_COMMAND='rg --files'
  type fd &> /dev/null && export FZF_DEFAULT_COMMAND='fd --type f'
  type fdfind &> /dev/null && export FZF_DEFAULT_COMMAND='fdfind --type f'
fi

# Newer git
if have brew && [ -f $(brew --prefix git)/bin/git ]; then
  export PATH=$(brew --prefix git)/bin:$PATH
fi

# Rust
[ -d "$HOME/.cargo/bin" ] && export PATH="$HOME/.cargo/bin:$PATH"

[ -e "$HOME/.local/bin/.autocomplete.zsh" ] && source "$HOME/.local/bin/.autocomplete.zsh"
[ -e "$HOME/.local/bin/aliases.sh" ] && source "$HOME/.local/bin/aliases.sh"
[ -e "$HOME/.local/bin/aliases.zsh" ] && source "$HOME/.local/bin/aliases.zsh"
[ -e "$HOME/.secrets" ] && source "$HOME/.secrets"

[[ "$OSTYPE" == linux* ]] && reset_keyrate.sh

[ -e "$HOME/.zshlocal" ] && source "$HOME/.zshlocal"
