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

DPI=600
SCANNER="brother5:net1;dev0"
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

echo -ne "Scan both sides of documents? y/[n] "
read -r IS_DUPLEX
case "$IS_DUPLEX" in
  # Card Slot|Card Slot(Duplex)
  # Y*|y*) SCAN_SOURCE="Card Slot(Duplex)";;
  # *) SCAN_SOURCE="Card Slot";;
  Y*|y*) SCAN_SOURCE="Automatic Document Feeder(center aligned,Duplex)";;
  *) SCAN_SOURCE="Automatic Document Feeder(center aligned)";;
esac

echo -ne "How big is the paper? Letter/Legal/[Biggest] "
read -r SCAN_SIZE
case "$SCAN_SIZE" in
  Letter|letter) SCAN_SIZE="-x 215.88 -y 279.374 ";;
  Legal|legal) SCAN_SIZE="-x 215.88 -y 356 ";;
  *) SCAN_SIZE="";;
esac

echo -ne "Color or Grayscale? [Color]/Gray "
read -r SCAN_MODE
case "$SCAN_MODE" in
  G*|g*) SCAN_MODE="True Gray";;
  *) SCAN_MODE="24bit Color[Fast]";;
esac

if [ "${OCR:-true}" == "true" ]; then
  (
    cd "$TMP_DIR"

    echo Scanning ...
    scanimage \
      --source="$SCAN_SOURCE" \
      --device="$SCANNER" \
      --mode="$SCAN_MODE" \
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
else
  BASE_SCANTO=${SCANTO##*.}
  scanimage \
    --source="$SCAN_SOURCE" \
    --device="$SCANNER" \
    --mode="$SCAN_MODE" \
    $SCAN_SIZE \
    --format=tiff \
    --batch="${BASE_SCANTO}%d.tiff" \
    --resolution="$DPI" && \
  convert "${BASE_SCANTO}*.tiff" "$SCANTO" && \
  rm -f "${BASE_SCANTO}*.tiff"
fi
