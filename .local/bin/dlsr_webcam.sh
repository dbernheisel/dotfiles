#!/bin/sh

get_device() {
  v4l2-ctl --list-devices | grep -A2 Olympus | grep dev | head -n 1 | awk '{ print $1 }'
}

make_device() {
  echo "Making device"
  modprobe v4l2loopback exclusive_caps=1 video_nr=9 card_label="Olympus" max_buffers=2
}

if [ "$(get_device)" = "" ]; then make_device; fi
if [ "$(get_device)" = "" ]; then
  echo "Could not create /dev/video9 device"
  exit 1;
fi

gphoto2 --stdout --capture-movie | ffmpeg -i - \
  -vcodec mjpeg_vaapi \
  -pix_fmt yuv420p \
  -threads 0 \
  -f v4l2 "$DEVICE"
