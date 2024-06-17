#!/usr/bin/env bash

typeset -r video_file="$1"
typeset -r output_file="$2"
typeset -r usage_text='Usage: gifencode.sh <video file> <output_file>.gif'

if ! hash ffmpeg 2>/dev/null; then
    echo "[ERROR]: ffmpeg must be installed"
    exit 1;
fi

if [ -z "$video_file" ] || [ -z "$output_file" ]; then
    echo "$usage_text"
    exit 1;
fi

typeset -r palette="/tmp/palette.png"
typeset -r filters="fps=24,scale=1080:-1:flags=lanczos"
# typeset -r filters="fps=60"

ffmpeg -v warning -i "$video_file" -vf "$filters,palettegen" -y "$palette"
ffmpeg -v warning -i "$video_file" -i "$palette" -lavfi "$filters [x]; [x][1:v] paletteuse" -y "$output_file"
