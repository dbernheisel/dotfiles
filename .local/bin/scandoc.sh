#!/bin/bash
# scan2PDF
# Requires: tesseract for OCR to PDF
#           scanimage for scanning
#           pdftk to merge multiple PDF into one
#
# Use scanimage -L to get a list of devices.
# e.g. device `genesys:libusb:006:003' is a Canon LiDE 210 flatbed scanner
# then copy/paste genesys:libusb:006:003 into SCANNER below.
set -euo pipefail

DPI=300
SCANNER="brother5:net1:dev0"
TESSERACT_LANG=eng # Language that Tesseract uses for OCR

FILENAME=$1

case $FILENAME in
  /*) SCANTO="$FILENAME";;
  ~*) SCANTO="$FILENAME";;
  *) SCANTO="$(pwd)/$FILENAME";;
esac

if ! type scanimage &> /dev/null; then
  echo "ScanImage is not installed. Please install scanimage so I can use the scanner."
  exit 1
fi
if ! type tesseract &> /dev/null; then
  echo "Tesseract is not installed. Please install Tesseract and the language you will need so I can OCR documents."
  exit 1
fi

TMP_DIR="/tmp/scanning/$(basename "$FILENAME")"
mkdir -p "$TMP_DIR"

# Scan sources for me:
#  Automatic Document Feeder(centrally aligned)
#  Automatic Document Feeder(centrally aligned,Duplex)
echo -ne "Does this have two-sided documents? (y/n) "
read -r IS_DUPLEX
case "$IS_DUPLEX" in
  Y*|y*) SCAN_SOURCE="Automatic Document Feeder(centrally aligned,Duplex)";;
  *) SCAN_SOURCE="Automatic Document Feeder(centrally aligned)";;
esac
echo "source=$SCAN_SOURCE"

echo -ne "How big is the paper? (Letter,Legal,Biggest) "
read -r SCAN_SIZE
case "$SCAN_SIZE" in
  Letter|letter) SCAN_SIZE="-x 215.88 -y 279.374 ";;
  Legal|legal) SCAN_SIZE="-x 215.88 -y 356 ";;
  *) SCAN_SIZE="";;
esac
echo "size=$SCAN_SIZE"

#echo -ne "Color or Grayscale? "
#read -r SCAN_MODE
#case "$SCAN_MODE" in
  #C*|c*) SCAN_MODE="24bit Color";;
  #G*|g*) SCAN_MODE="True Gray";;
  #*) echo "Invalid scan mode" && exit 1;;
#esac
#echo "mode=$SCAN_MODE"

(
  cd "$TMP_DIR"

  echo Scanning ...
  scanimage \
    --source="$SCAN_SOURCE" \
    --device="$SCANNER" \
    $SCAN_SIZE \
    --format=tiff \
    --batch --batch-print \
    --resolution="$DPI" | \
  tesseract \
    -l "$TESSERACT_LANG" \
    -c stream_filelist=true - - pdf > "$SCANTO"
)

rm -rf "$TMP_DIR"
echo "Done scanning - $FILENAME"
