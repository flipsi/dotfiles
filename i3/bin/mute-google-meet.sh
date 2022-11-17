#!/usr/bin/env bash

ACTIVE_WINDOW=$(xdotool getactivewindow)

xdotool search --name '^Meet - .+ - Chromium$' \
    windowactivate --sync \
    sleep 0.1 \
    key ctrl+d

xdotool windowactivate $ACTIVE_WINDOW
