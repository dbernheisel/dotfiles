if [ -z "$1" ] || [ -z "$2" ]; then
  echo "Usage: $0 [input.mkv] [output.mp3]"
  exit 1
fi

ffmpeg -i "$1" -map 0:a -vn -b:a 320k "$2"
