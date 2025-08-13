#!/bin/bash

# Initialize timestamp, unique file name, and temporary tagged file name
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
FILENAME="image_$TIMESTAMP.jpg"
RESIZED="image_resized.jpg"
TAGGED="image_tagged.jpg"

# Capture image
rpicam-jpeg -o "$FILENAME" --timeout 0 --width 4608 --height 2592

# Resizes image for SSTV mode
convert "$FILENAME" -resize 320x256 "$RESIZED"

# Overlay Callsign
composite -gravity East -geometry +0+0 vertical_callsign_overlay.png "$RESIZED" "$TAGGED"

# Generate SSTV audio
~/PiSSTVpp/pisstvpp -r 22050 -p m2 "$TAGGED"

# Transmit via speaker, check hardware designation with aplay -l
sox "$TAGGED.wav" -t alsa -D plughw:2,0
