#!/usr/bin/env bash

set -e

# Look for WM_NAME in `xprop` output, e.g.
# WM_NAME(UTF8_STRING) = "Google Meet - Meet - qup-bwhq-mbc"

WINDOW_NAME_GOOGLE_MEET='Meet - .+'
WINDOW_NAME_SLACK=' - Slack'

function mute_or_unmute_google_meet() {
    xdotool search --name "$WINDOW_NAME_GOOGLE_MEET" \
        windowactivate --sync \
        sleep 0.1 \
        key ctrl+d
}

function mute_or_unmute_slack_huddle() {
    xdotool search --name "$WINDOW_NAME_SLACK" \
        windowactivate --sync \
        sleep 0.1 \
        key ctrl+shift+space
}

ACTIVE_WINDOW=$(xdotool getactivewindow)
mute_or_unmute_slack_huddle || mute_or_unmute_google_meet
xdotool windowactivate "$ACTIVE_WINDOW"
