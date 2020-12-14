#!/bin/bash

if ! gphoto2 --abilities &> /dev/null; then
  echo "Camera not connected"
  exit 1
fi

get_device() {
  v4l2-ctl --list-devices | grep -A2 Olympus | grep dev | head -n 1 | awk '{ print $1 }'
}

make_device() {
  echo "Making device"
  sudo modprobe v4l2loopback exclusive_caps=1 video_nr=9 card_label="Olympus" max_buffers=2
}

if [ "$(get_device)" = "" ]; then make_device; fi
if [ "$(get_device)" = "" ]; then
  echo "Could not create /dev/video9 device"
  exit 1;
fi

gphoto2 --stdout --capture-movie | ffmpeg -i - \
  -vcodec rawvideo \
  -pix_fmt yuv420p \
  -threads 0 \
  -f v4l2 "$(get_device)"
