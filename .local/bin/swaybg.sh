#!/bin/bash

FILE=$(find $HOME/backgrounds -type f -not -path '*/\.*' | shuf -n 1)
swaymsg "output '*' bg $FILE fill"
