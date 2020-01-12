#!/bin/bash
#
# if ! v4l2-ctl --list-devices | grep "OBS Cam" >/dev/null; then
#   echo "Creating video loopback device 'OBS Cam'"
#   sudo modprobe v4l2loopback devices=1 video_nr=10 card_label="OBS Cam" exclusive_caps=1
# fi
#
# if ! pacmd list-sources | grep "OBS Mic" >/dev/null; then
#   echo "Creating audio loopback device 'OBS Mic'"
#   sudo modprobe snd-aloop index=10 id="OBS Mic"
#   pacmd 'update-source-proplist alsa_input.platform-snd_aloop.0.analog-stereo device.description="OBS Mic"'
# fi
#
# if ! pacmd list-sinks | grep "<OBSSink>" >/dev/null; then
#   echo "Creating audio loopback device 'OBS Desktop'"
#   pacmd load-module module-null-sink sink_name=OBSSink
#   pacmd update-sink-proplist OBSSink device.description=OBSSink
# fi
#
# if ! pacmd list-sinks | grep "<OBSSink_default>" >/dev/null; then
#   echo "Creating combined sink 'OBS+Bluetooth'"
#   pacmd load-module module-combine-sink \
#     sink_name='OBSSink+default' \
#     sink_properties=device.description='OBSSink+Bluetooth' \
#     slaves=OBSSink,bluez_sink.70_26_05_8C_A4_54.a2dp_sink
#   pacmd set-default-sink OBSSink_default
# fi
#
echo "Starting virtual camera streaming server"
ffmpeg -probesize 32 -analyzeduration 0 -re \
  -listen 1 -i rtmp://127.0.0.1:1935/live \
  -map 0:1 -f v4l2 -vcodec rawvideo /dev/video10 -preset ultrafast \
  -map 0:0 -f alsa hw:10,1

