#!/usr/bin/env bash

if [ "$1" != "up" ] && [ "$1" != "down" ]; then
    echo "Usage: $0 up|down"
    exit 1
fi

STEP="0.02"
OP="$STEP$([[ $1 == up ]] && echo "+" || echo "-")"

ID=$(wpctl status | awk '/RtAudio/ {gsub("\\.",""); id=$1} END{print id}')

wpctl set-volume "$ID" "$OP"
