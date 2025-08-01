#!/bin/bash

INPUT_IMG="$1"
RESIZED="resized.jpg"
WAVFILE="sstv.wav"

# Resize for SSTV (forces 320x256 even if it distorts)
convert "$INPUT_IMG" -resize '320x256!' "$RESIZED"

# Generate SSTV audio
~/PiSSTVpp/pisstvpp -r 22050 -p m2 "$RESIZED"

# Transmit via speaker, check hardware designation with aplay -l
sox "$RESIZED.wav" -t alsa -D plughw:2,0
