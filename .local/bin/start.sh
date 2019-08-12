#!/bin/bash

~/.local/bin/ldac_bt.sh &
~/.local/bin/reset_keyrate.sh &
(cd "$HOME/Dropbox/vimwiki" && nvim -c "VimwikiIndex")
