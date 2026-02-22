#!/bin/bash

DEVICE="brother5:net1;dev0"
MODE="24bit Color[fast]"
SOURCE="Automatic Document Feeder(center aligned)"
DPI=1200

if ! type scanimage &> /dev/null; then
  echo "ScanImage is not installed. Please install scanimage so I can use the scanner."
  exit 1
fi

if [ -z $1 ]; then
  echo -ne "Filename prefix: "
  read -r PREFIX
else
  PREFIX="$1"
fi

LATEST_FILE=$(find . -maxdepth 1 -name "$PREFIX-*.jpg" | sort -Vk1,1 | tail -1)
LATEST_FILE=$(basename "$LATEST_FILE")
LATEST_NUM=${LATEST_FILE#"$PREFIX"-}
LATEST_NUM=${LATEST_NUM%%.jpg}
STARTING_NUM=$((LATEST_NUM+1))

echo "Starting at $STARTING_NUM"
echo ""

echo -e "How big is the photo?"
echo "1) 4x6"
echo "1v) 4x6 Vertical"
echo "2) 3x5"
echo "2v) 3x5 Vertical"
echo "3) 5x7"
echo "3v) 5x7 Vertical"
echo -en "size: "
read -r SCAN_SIZE
case "$SCAN_SIZE" in
  1) SCAN_SIZE="-l 34 -x 148 -y 100";;
  1v) SCAN_SIZE="-l 58 -x 100 -y 146";;
  2) SCAN_SIZE="-l 47 -x 123 -y 88";;
  2v) SCAN_SIZE="-l 65 -x 88 -y 123";;
  3) SCAN_SIZE="-l 21 -x 174 -y 126";;
  3v) SCAN_SIZE="-l 46 -x 126 -y 174";;
  *) SCAN_SIZE="";;
esac
  # --source="$SOURCE" \

echo Scanning ...
scanimage \
  --device="$DEVICE" \
  --mode="$MODE" \
  $SCAN_SIZE \
  --batch="$PREFIX-%d.jpg" \
  --batch-start="$STARTING_NUM" \
  --format=jpeg \
  --resolution="$DPI" \
  --progress
