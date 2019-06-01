HEADSET_MAC_ADDRESS="70:26:05:8C:A4:54"
HEADSET_NAME="bluez_card.${HEADSET_MAC_ADDRESS//[:]/_}"
PROFILE="a2dp_sink_ldac"

echo "disconnect $HEADSET_MAC_ADDRESS" | bluetoothctl
sleep 5
echo "connect $HEADSET_MAC_ADDRESS" | bluetoothctl
sleep 6
pacmd set-card-profile $HEADSET_NAME $PROFILE
