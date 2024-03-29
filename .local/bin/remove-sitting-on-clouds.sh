#!/bin/zsh

display_usage() {
  echo "This will scan all MP3s and FLACs and remove comments and URLs"
  echo ""
  echo "Usage: $(basename "$0") [folder]"
  echo "Example: $(basename "$0") \"~/Downloads/DOWNLOADED-ALBUM[F]\""
}

[[ $1 == "" ]] && display_usage && exit 1
[[ $1 == "--help" ]] && display_usage && exit 0

if [ -d /Applications/kid3.app/Contents/MacOS ]; then
  export PATH="/Applications/kid3.app/Contents/MacOS:${PATH}"
fi

if ! type kid3-cli &>/dev/null; then
  echo "This requires kid3-cli to be installed to clean MP3s"
  case "$OSTYPE" in
    darwin*)
      echo "Install it with 'brew install kid3'";;
    *)
      ;;
  esac
  exit 1
fi

for f in "$1"/**/{.,}*.mp3(N); do

  echo "Fixing $f"
  kid3-cli \
    -c 'set "User-defined URL" ""' \
    -c 'set "Comment" "" 1' \
    -c 'set "Comment" "" 2' \
    "$f"
done

for f in "$1"/**/{.,}*.flac(N); do
  if ! type metaflac &>/dev/null; then
    echo "This requires metaflac (installed w/ flac) to be installed to clean FLACs"
    exit 1
  fi

  echo "Fixing $f"
  metaflac --remove-tag=WWW --remove-tag=COMMENT "$f"
done
