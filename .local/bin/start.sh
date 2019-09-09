#!/bin/bash

~/.local/bin/ldac_bt.sh > /dev/null &
~/.local/bin/reset_keyrate.sh > /dev/null &
(cd "$HOME/Dropbox/vimwiki" && nvim -c "VimwikiIndex")
