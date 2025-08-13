#!/bin/bash

# Creates callsign overlay for Image2Wav.sh

convert -size 40x256 xc:none \
    -gravity North \
    -fill red -pointsize 24 -font DejaVu-Sans-Bold \
    -annotate +45+0 'N\n0\nC\nA\nL\nL' \
    vertical_callsign_overlay.png
