#!/usr/bin/env bash

SND_HOME="$HOME/snd/"
STOP_KEY="Control+c"

snd="$(find "$SND_HOME" -maxdepth 1 -type f -printf '%f\n' | \
    sort -nr | \
    rofi -i -mesg "Select file. ${STOP_KEY} to stop" \
        -dmenu \
        -kb-custom-1 "${STOP_KEY}" \
        -p "play: ")"
rofi_exit=$?

if [[ $rofi_exit -eq 0 ]]; then
    cvlc "$SND_HOME/$snd" &
elif [[ $rofi_exit -eq 10 ]]; then
    pkill -f "vlc .* $SND_HOME"
else
    exit
fi

# vim:sw=4:ts=4:et:
