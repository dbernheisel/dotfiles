#!/usr/bin/env zsh

function have() {
  type "$1" &> /dev/null
}

if have fzf; then
  if [ -f /usr/share/fzf/key-bindings.zsh ]; then
    # If Arch
    source /usr/share/fzf/key-bindings.zsh
    source /usr/share/fzf/completion.zsh
    bindkey '^I' $fzf_default_completion
  elif [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]; then
    # If Debian
    source /usr/share/doc/fzf/examples/key-bindings.zsh
    if [ -f /etc/profile.d/fzf.zsh ]; then
      source /etc/profile.d/fzf.zsh
    fi
  elif [ -f /opt/homebrew/opt/fzf/shell/completion.zsh ]; then
    # If Homebrew
    source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
    source /opt/homebrew/opt/fzf/shell/completion.zsh
  fi
fi

# brew completions
# Already done with eval "$(brew shellenv)"
# if type brew &> /dev/null; then
#   if [ -f "$BREW_PREFIX/share/zsh/site-functions" ]; then
#     fpath=("$BREW_PREFIX/share/zsh/site-functions" $fpath)
#   fi
# fi

mkdir -p "$HOME/.cache/completions"
if have docker && [ ! -f "$HOME/.cache/completions/_docker" ]; then
  docker completion zsh > "$HOME/.cache/completions/_docker"
fi

if have just && [ ! -f "$HOME/.cache/completions/_just" ]; then
  just --completions zsh > "$HOME/.cache/completions/_just"
fi

if have k3d && [ ! -f "$HOME/.cache/completions/_k3d" ]; then
  k3d completion zsh > "$HOME/.cache/completions/_k3d"
fi

if have kubectl && [ ! -f "$HOME/.cache/completions/_kubectl" ]; then
  kubectl completion zsh > "$HOME/.cache/completions/_kubectl"
fi

if have mise && [ ! -f "$HOME/.cache/completions/_mise" ]; then
  mise completion zsh > "$HOME/.cache/completions/_mise"
fi

if [ "$TERM_PROGRAM" = "WezTerm" ] && \
   [ ! -f "$HOME/.cache/completions/_wezterm" ]; then
  (cd "$WEZTERM_EXECUTABLE_DIR" && ./wezterm shell-completion --shell zsh > "$HOME/.cache/completions/_wezterm")
fi

if [ -n "$TERMINFO" ] && \
   [ "$TERMINFO" =~ "kitty" ] && \
   [ ! -f "$HOME/.cache/completions/_kitty" ]; then
  kitty + complete setup zsh > "$HOME/.cache/completions/_kitty"
fi

if have npm && [ ! -f "$HOME/.cache/completions/_npm" ]; then
  npm completion > "$HOME/.cache/completions/_npm"
fi

fpath=("$HOME/.cache/completions" $fpath)
autoload -Uz compinit && compinit
