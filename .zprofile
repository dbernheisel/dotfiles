# Executes commands at login pre-zshrc.
#

# Browser
if [[ "$OSTYPE" == darwin* ]]; then
  export BROWSER='open'
fi

# Editors
export EDITOR='nvim'
export PAGER='less'

if [ -n "$NVIM_LISTEN_ADDRESS" ] && type nvr &> /dev/null; then
  export VISUAL="nvr -cc tabedit --remote-wait +'set bufhidden=wipe'"
else
  export VISUAL="nvim"
fi

# Language
if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi

#
# Paths
#

# Ensure path arrays do not contain duplicates.
declare -gU cdpath fpath mailpath path

# Set the the list of directories that cd searches.
# cdpath=(
#   $cdpath
# )

# Set the list of directories that Zsh searches for programs.
path=(
  /usr/local/{bin,sbin}
  $path
)

# Less
# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-F -g -i -M -R -S -w -X -z-4'

# Set the Less input preprocessor.
# Try both `lesspipe` and `lesspipe.sh` as either might exist on a system.
if (( $#commands[(i)lesspipe(|.sh)] )); then
  export LESSOPEN="| /usr/bin/env $commands[(i)lesspipe(|.sh)] %s 2>&-"
fi

# Temporary Files
if [[ ! -d "$TMPDIR" ]]; then
  export TMPDIR="/tmp/$LOGNAME"
  mkdir -p -m 700 "$TMPDIR"
fi

TMPPREFIX="${TMPDIR%/}/zsh"

# Notify function
if [[ "$OSTYPE" == darwin* ]]; then
  notify () {
    osascript -e 'on run {theText}' -e 'display notification theText with title "Terminal Notification" sound name "Glass"' -e 'end run' $1
  }
fi

# This is how to configure iTerm2 to send the correct CSI for ctrl+h:
#
# Edit -> Preferences -> Keys
# Press +
# Press Ctrl+h as Keyboard Shortcut
# Choose Send Escape Sequence as Action
# Type [104;5u
