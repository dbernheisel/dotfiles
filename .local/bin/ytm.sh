#!/bin/bash

### Script for downloading albums from Youtube Music ##########
### Usage: ./ytm.sh <youtube music url> ###

# - Converts to MP3 from the best quality audio feed
# - Adds track number, album, artist, title, and release year into id3 tags
# - Adds album art embedded thumbnails

echo "Retrieving album information..."
# Downloading the json data of the first track only
json=$(yt-dlp -j -I 1 "$1")

# Grabbing the artist then removing any superfluous information after the first comma. Some artists put every band memember into the artist field.
jq_artist=$(jq -r '.artist' <<< "$json")
artist=${jq_artist%%,*}
album=$(jq -r '.album' <<< "$json")
title=$(jq -r '.title' <<< "$json")
track=$(jq -r '.playlist_autonumber' <<< "$json")
year=$(jq -r '.release_date[0:4] // .release_date' <<< "$json")

echo "Formats:"
echo "1) ${album}/${track} - ${title}.m4a"
echo "2) ${artist}/${year} - ${album}/${track} - ${title}.m4a"
echo
read -rp 'Which format? (1/2) ' CHOICE

case $CHOICE in
  "1")
    OUT_FORMAT="%(album)s/%(playlist_autonumber)s - %(title)s.%(ext)s";;
  "2")
    OUT_FORMAT="%(artist)s/$year - %(album)/%(playlist_autonumber)s - %(title)s.%(ext)s";;
  *)
    echo "Invalid option: '$CHOICE'"
    exit 1;;
esac

echo "This will prompt for your keyring password so it can read Chrome's cookies for YouTube"

# Pass to yt-dlp and begin download all the music!
yt-dlp  --format-sort "abr,acodec" \
        --extract-audio \
        --cookies-from-browser chrome \
        --audio-format m4a \
        --audio-quality 0 \
        --ignore-errors \
        --parse-metadata "playlist_index:%(track_number)s" \
        --parse-metadata ":(?P<webpage_url>)" \
        --parse-metadata ":(?P<synopsis>)" \
        --parse-metadata ":(?P<description>)" \
        --add-metadata \
        --postprocessor-args "-metadata date='${year}' -metadata artist=\"${artist}\" -metadata album_artist=\"${artist}\"" \
        --embed-thumbnail \
        --convert-thumbnail jpg \
        --ppa "ThumbnailsConvertor+FFmpeg_o:-c:v mjpeg -qmin 1 -qscale:v 1 -vf crop=\"min(iw\,ih)\":\"min(iw\,ih)\"" \
        -o "$OUT_FORMAT" "$1"
