#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

if [[ "$TERM_PROGRAM" == "ghostty" && -z "$ZELLIJ_SESSION_NAME" ]]; then
  source "$HOME/.config/ghostty/zellij-new-session"
  exit 0 
fi

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

if [ "$XDG_CURRENT_DESKTOP" = "sway" ] || [ "$XDG_SESSION_TYPE" = "wayland" ]; then
  export KITTY_ENABLE_WAYLAND=1
fi

[[ -d $HOME/flutter/bin ]] && export PATH="$HOME/flutter/bin:$PATH"
[[ -d $HOME/.yarn/bin ]] && export PATH="$HOME/.yarn/bin:$PATH"
if [[ -d $HOME/.cargo/bin ]]; then
  export PATH="$HOME/.cargo/bin:$PATH"
  source "$HOME/.cargo/env"
fi
[[ -d $HOME/go/bin ]] && export PATH="$HOME/go/bin:$PATH"
[[ -f /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
[[ $TERMINFO =~ "kitty" ]] && export COLORTERM="truecolor"
[[ $TERMINFO =~ "iterm" ]] && export COLORTERM="truecolor"
[[ $TERMINFO =~ "Ghostty.app" ]] && export COLORTERM="truecolor"
[[ -d "/Applications/Visual Studio Code.app" ]] && export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# PostgreSQL
export POSTGRES_USER=$(whoami)

# Elixir
export ERL_AFLAGS="-kernel shell_history enabled"
export KERL_BUILD_DOCS="yes"
export KERL_INSTALL_HTMLDOCS="no"
export KERL_INSTALL_MANPAGES="no"
export PLUG_EDITOR="nvim"

export SUDO_EDITOR="nvim"

have rg && export RIPGREP_CONFIG_PATH="$HOME/.config/ripgrep/rc"
# have bat && export MANPAGER="sh -c 'col -bx | bat -l man -p'"
have nvim && export MANPAGER='nvim +Man!'

# fzf default command
if have fzf; then
  # RipGrep
  have rg && export FZF_DEFAULT_COMMAND='rg --files'
  have fd && export FZF_DEFAULT_COMMAND="fd --type f --hidden --ignore-file \"$HOME/.config/fd/ignore\""
  have fdfind && export FZF_DEFAULT_COMMAND='fdfind --type f --hidden --ignore-file \"$HOME/.config/fd/ignore\"'
  FZF_DEFAULT_OPTS="--ansi --preview-window 'right:60%' --layout reverse --margin=1,4 "
  if have bat; then
    FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS --preview 'bat --color=always --style=header,grid --line-range :300 {}'"
  fi
fi

[ -d "${ASDF_DATA_DIR:-$HOME/.asdf}/shims" ] && export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH"
[ -d "${MIX_HOME:-$HOME/.mix}/escripts" ] && export PATH="${MIX_HOME:-$HOME/.mix}/escripts:$PATH"
have mise && eval "$(mise activate zsh)"
[ -e "$HOME/.local/bin/autocomplete.zsh" ] && source "$HOME/.local/bin/autocomplete.zsh"
[ -e "$HOME/.local/bin/aliases.sh" ] && source "$HOME/.local/bin/aliases.sh"
[ -e "$HOME/.local/bin/aliases.zsh" ] && source "$HOME/.local/bin/aliases.zsh"
[ -e "$HOME/.secrets" ] && source "$HOME/.secrets"
[ -e "$HOME/.zshlocal" ] && source "$HOME/.zshlocal"
[ -d "$HOME/.local/bin/zsh/zsh-autoenv" ] && source "$HOME/.local/bin/zsh/zsh-autoenv/autoenv.zsh"
