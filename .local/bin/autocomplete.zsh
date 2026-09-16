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

COMPDIR="$HOME/.cache/completions"
mkdir -p "$COMPDIR"
zmodload -F zsh/stat b:zstat

# Regenerate a completion whenever the tool it describes changes.
#
# The cache key is the resolved binary's path, mtime and size, read with zstat
# instead of shelling out to each tool's --version (~12ms each, on every new
# shell; the whole stat-based pass is ~4ms). ${commands[...]} resolves past
# shims to the real binary, so a mise-managed tool moves path on upgrade and a
# brew- or system-managed one changes mtime.
completion_for() {
  local name=$1 bin=$2
  shift 2
  [[ -n $bin && -x $bin ]] || return 0

  local out="$COMPDIR/_$name" stamp="$COMPDIR/.$name.stamp" tmp="$COMPDIR/.$name.new"
  local -A st
  zstat -H st "$bin" 2>/dev/null || return 0
  local key="$bin:$st[mtime]:$st[size]"

  [[ -f $out && -r $stamp && "$(<$stamp)" == "$key" ]] && return 0

  # Keep the previous completion if the generator fails or emits nothing —
  # a stale completion still beats an empty one.
  "$@" >| "$tmp" 2>/dev/null && [[ -s $tmp ]] || { rm -f "$tmp"; return 0; }
  mv -f "$tmp" "$out"
  print -r -- "$key" >| "$stamp"
}

completion_for docker    "${commands[docker]}"    docker completion zsh
completion_for just      "${commands[just]}"      just --completions zsh
completion_for k3d       "${commands[k3d]}"       k3d completion zsh
completion_for kubectl   "${commands[kubectl]}"   kubectl completion zsh
completion_for mise      "${commands[mise]}"      mise completion zsh
completion_for tailscale "${commands[tailscale]}" tailscale completion zsh
completion_for npm       "${commands[npm]}"       npm completion

if [ "$TERM_PROGRAM" = "WezTerm" ]; then
  completion_for wezterm "$WEZTERM_EXECUTABLE_DIR/wezterm" \
    "$WEZTERM_EXECUTABLE_DIR/wezterm" shell-completion --shell zsh
fi

if [[ -n "$TERMINFO" && "$TERMINFO" == *kitty* ]]; then
  completion_for kitty "${commands[kitty]}" kitty + complete setup zsh
fi

if have mix && [ ! -L "$COMPDIR/_mix" ]; then
  ln -sf "$HOME/.local/bin/_mix" "$COMPDIR/_mix"
fi

fpath=("$COMPDIR" $fpath)
autoload -Uz compinit && compinit
