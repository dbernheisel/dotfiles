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

have rg && export RIPGREP_CONFIG_PATH="$HOME/.ripgreprc"

[[ -d $HOME/flutter/bin ]] && export PATH="$HOME/flutter/bin:$PATH"
[[ -d $HOME/.yarn/bin ]] && export PATH="$HOME/.yarn/bin:$PATH"
[[ -d $HOME/.cargo/bin ]] && export PATH="$HOME/.cargo/bin:$PATH"
[[ -d $HOME/.config/composer/vendor/bin ]] && export PATH="$HOME/.config/composer/vendor/bin:$PATH"
[[ $TERMINFO =~ "kitty" ]] && export COLORTERM="truecolor"

# PostgreSQL
export POSTGRES_USER=$(whoami)

# Elixir
export ERL_AFLAGS="-kernel shell_history enabled"
export KERL_BUILD_DOCS="yes"

# fzf default command
if have fzf; then

  # RipGrep
  have rg && export FZF_DEFAULT_COMMAND='rg --files'
  have fd && export FZF_DEFAULT_COMMAND='fd --type f'
  have fdfind && export FZF_DEFAULT_COMMAND='fdfind --type f'
  FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --layout reverse --margin=1,4 "
  if have bat; then
    FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --preview 'bat --color=always --style=header,grid --line-range :300 {}'"
  fi

  # Keybindings CTRL-R, CTRL-T, ALT-C
  if [ -f /etc/profile.d/fzf.zsh ]; then
    source /etc/profile.d/fzf.zsh
  fi
fi

# Newer git
if have brew && [ -f $(brew --prefix git)/bin/git ]; then
  export PATH=$(brew --prefix git)/bin:$PATH
fi

# asdf
[[ -d $HOME/.asdf ]] && source $HOME/.asdf/asdf.sh

[ -e "$HOME/.local/bin/.autocomplete.zsh" ] && source "$HOME/.local/bin/.autocomplete.zsh"
[ -e "$HOME/.local/bin/aliases.sh" ] && source "$HOME/.local/bin/aliases.sh"
[ -e "$HOME/.local/bin/aliases.zsh" ] && source "$HOME/.local/bin/aliases.zsh"
[ -e "$HOME/.secrets" ] && source "$HOME/.secrets"

[[ "$OSTYPE" == linux* ]] && reset_keyrate.sh

[ -e "$HOME/.zshlocal" ] && source "$HOME/.zshlocal"
