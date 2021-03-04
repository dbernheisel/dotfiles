#!/bin/bash

CAPTURE_CARD=$(v4l2-ctl --list-devices | grep -A2 Live | grep dev | head -n 1 | awk '{ print $1 }')
if [[ -n $CAPTURE_CARD ]]; then
  echo "Setting Capture Card to 1920x1080"
  v4l2-ctl --device="$CAPTURE_CARD" --set-fmt-video=width=1920,height=1080,pixelformat=YUYV
fi

if ! v4l2-ctl --list-devices | grep "OBS Cam" >/dev/null; then
  sudo modprobe -r v4l2loopback
  echo "Creating video loopback device 'OBS Cam'"
  sudo modprobe v4l2loopback devices=1 video_nr=10 card_label="OBS Cam" exclusive_caps=1
fi

if ! pacmd list-sources | grep "<OBS_Mic_Sink>" >/dev/null; then
  echo "Creating audio loopback device 'OBS Mic Sink'"
  sudo modprobe snd-aloop index=10 id="OBS_Mic_Sink"
  pacmd 'update-source-proplist alsa_input.platform-snd_aloop.0.analog-stereo device.description="OBS Mic Sink"'
fi

if ! pacmd list-sinks | grep "<OBS_Sink>" >/dev/null; then
  echo "Creating virtual mic 'OBS Desktop'"
  pacmd load-module module-null-sink \
    sink_name='OBS_Sink' \
    sink_properties=device.description='OBS Sink'
fi

if ! pacmd list-sinks | grep "<OBS_Sink_Bluetooth>" >/dev/null; then
  echo "Creating combined sink 'OBS Sink+Bluetooth'"
  pacmd load-module module-combine-sink \
    sink_name='OBS_Sink+Bluetooth' \
    sink_properties=device.description='OBS Sink+Bluetooth' \
    slaves=OBS_Sink,bluez_sink.70_26_05_8C_A4_54.a2dp_sink
  pacmd set-default-sink OBSSink_Bluetooth
fi

if ! pacmd list-sources | grep "<OBS_Mic>" >/dev/null; then
  pactl load-module module-remap-source \
    master='OBS_Sink.monitor' \
    source_name='OBS Mic' \
    source_properties=device.description='OBS Mic'
fi

# Configure OBS to have a monitor
#   File -> Settings -> Audio -> Advanced -> Monitoring Device -> "Monitor of OBS Sink"
# Configure Zoom to use the mic "OBS Mic"
# Configure Zoom to output to your specific device, not the OBS Sink
# Configure pavucontrol to output everythin you want captured to an OBS Sink

