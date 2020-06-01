#!/bin/bash

display_usage() {
  echo "This will scan all MP3s and FLACs and remove comments and URLs"
  echo ""
  echo "Usage: $(basename "$0") [folder]"
  echo "Example: $(basename "$0") \"~/Downloads/DOWNLOADED-ALBUM[F]\""
}

[[ $1 == "" ]] && display_usage && exit 1
[[ $1 == "--help" ]] && display_usage && exit 0

for f in "$1"/*/*.mp3; do
  if type kid3-cli &>/dev/null; then
    echo "Fixing $f"
    kid3-cli \
      -c 'set "User-defined URL" ""' \
      -c 'set "Comment" ""' \
      "$f"
  else
    echo "This requires kid3-cli to be installed to clean MP3s"
    exit 1
  fi
done

for f in "$1"/*/*.flac; do
  if type metaflac &>/dev/null; then
    echo "Fixing $f"
    metaflac --remove-tag=WWW --remove-tag=COMMENT "$f"
  else
    echo "This requires metaflac (installed w/ flac) to be installed to clean FLACs"
    exit 1
  fi
done
