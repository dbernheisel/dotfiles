#!/usr/bin/env zsh

BREW_PREFIX=$(brew --prefix)

if type fzf &> /dev/null; then
  if [ -f /usr/share/fzf/key-bindings.zsh ]; then
    # If Arch
    source /usr/share/fzf/key-bindings.zsh
    source /usr/share/fzf/completion.zsh
    bindkey '^I' $fzf_default_completion
  elif [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]; then
    # If Debian
    source /usr/share/doc/fzf/examples/key-bindings.zsh
  elif [ -f ~/.fzf.zsh ]; then
    # If Homebrew
    source ~/.fzf.zsh
  else
    if type brew &> /dev/null; then
      echo "Running fzf install"
      "$BREW_PREFIX/opt/fzf/install"
    fi
  fi
fi

# brew completions
if type brew &> /dev/null; then
  if [ -f "$BREW_PREFIX/share/zsh/site-functions" ]; then
    fpath=("$BREW_PREFIX/share/zsh/site-functions" $fpath)
  fi
fi

# Kitty
if ! [ -z "$TERMINFO" ] && [ $TERMINFO =~ "kitty" ]; then
  kitty + complete setup zsh | source /dev/stdin
fi

autoload -Uz compinit && compinit
