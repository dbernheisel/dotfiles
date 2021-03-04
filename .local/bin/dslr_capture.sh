#!/bin/sh

set -e

CAPTURE_CARD=$(v4l2-ctl --list-devices | grep -A2 Live)

if [ -z "$CAPTURE_CARD" ]; then
  echo "Capture card not detected"
  exit 1
fi

CAPTURE_PATH=$(echo "$CAPTURE_CARD" | grep dev | head -n 1 | awk '{ print $1 }')
# CAPTURE_USB_ADDR=$(echo $CAPTURE_CARD | grep -Po '(?<=\().*(?=\))')

case $1 in
  720*)
    echo "Setting Olympus Capture Card to 720p"
    echo v4l2-ctl --device="$CAPTURE_PATH" --set-fmt-video=width=1280,height=720,pixelformat=YUYV
    v4l2-ctl --device="$CAPTURE_PATH" --set-fmt-video=width=1280,height=720,pixelformat=YUYV
    echo "You may need to unplug/replug the capture card to take effect"
    ;;
  1080*)
    echo "Setting Olympus Capture Card to 1080p"
    echo v4l2-ctl --device="$CAPTURE_PATH" --set-fmt-video=width=1920,height=1080,pixelformat=YUYV
    v4l2-ctl --device="$CAPTURE_PATH" --set-fmt-video=width=1920,height=1080,pixelformat=YUYV
    echo "You may need to unplug/replug the capture card to take effect"
    ;;
  *)
    echo "Invalid option. 720 or 1080 only"
    exit 1
    ;;
esac
