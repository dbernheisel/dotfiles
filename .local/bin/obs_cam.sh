#!/bin/sh

echo "Creating video loopback device 'OBS Cam'"
sudo modprobe v4l2loopback devices=1 video_nr=10 card_label="OBS Cam" exclusive_caps=1

echo "Creating audio loopback device 'OBS Mic'"
sudo modprobe snd-aloop index=10 id="OBS Mic"
pacmd 'update-source-proplist alsa_input.platform-snd_aloop.0.analog-stereo device.description="OBS Mic"'

echo "Starting virtual camera streaming server"
ffmpeg -probesize 32 -analyzeduration 0 -listen 1 -i rtmp://127.0.0.1:1935/live -map 0:1 -f v4l2 -vcodec rawvideo /dev/video10 -map 0:0 -f alsa hw:10,1
