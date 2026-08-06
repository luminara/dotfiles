#!/bin/bash

# Get BS date using full path
BSDATE=$(/home/squares/go/bin/nepcal date 2>/dev/null)

# Fallback if it fails
if [ -z "$BSDATE" ]; then
  BSDATE="Could not get BS date"
fi

# Send notification
notify-send -e "Bikram Sambat" "$BSDATE" -t 8000
