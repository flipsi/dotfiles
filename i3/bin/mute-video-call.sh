#!/usr/bin/env bash


function mute_or_unmute_google_meet() {
    xdotool search --name '^Meet - .+ - Chromium$' \
        windowactivate --sync \
        sleep 0.1 \
        key ctrl+d
}

function mute_or_unmute_slack_huddle() {
    xdotool search --name '^Slack - .+ - Huddle$' \
        windowactivate --sync \
        sleep 0.1 \
        key ctrl+shift+space
}

ACTIVE_WINDOW=$(xdotool getactivewindow)
mute_or_unmute_slack_huddle || mute_or_unmute_google_meet
xdotool windowactivate $ACTIVE_WINDOW
