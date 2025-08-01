#!/bin/bash

# Initialize timestamp, unique file name, and temporary tagged file name
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
FILENAME="image_$TIMESTAMP.jpg"
TAGGED="image_tagged.jpg"

# Capture image
libcamera-jpeg -o "$FILENAME" --width 320 --height 256

# Overlay Callsign
composite -gravity East -geometry +10+0 vertical_callsign_overlay.png "$FILENAME" "$TAGGED"

# Generate SSTV audio
~/PiSSTVpp/pisstvpp -r 22050 -p m2 "$TAGGED"

# Transmit via speaker, check hardware designation with aplay -l
sox "$TAGGED.wav" -t alsa -D plughw:2,0
