#!/bin/bash

DESTINATION="$1"; shift

for IN in "$@"; do
  OUT="${DESTINATION}/${IN}"
  echo
  echo
  echo
  echo
  kitty +kitten icat --clear --align=left --place=20x20@0x0 "$IN" && \
  echo "$IN -> $OUT" && \
  PATH="/opt/homebrew/opt/imagemagick@6/bin:$PATH" \
    "$HOME/.local/bin/autotrim" -c SouthEast -f 30 \
    "$IN" 1.processed.jpeg && \
  kitty +kitten icat --align=left --place=20x20@20x0 "1.processed.jpeg" && \
  PATH="/opt/homebrew/opt/imagemagick@6/bin:$PATH" \
    "$HOME/.local/bin/autotrim" -c SouthEast -f 10 -m inner \
    1.processed.jpeg "$OUT" && \
  kitty +kitten icat --align=left --place=20x20@40x0 "$OUT"

  rm ./*.processed.jpeg
  sleep 0.5
done

kitty +kitten icat --clear
