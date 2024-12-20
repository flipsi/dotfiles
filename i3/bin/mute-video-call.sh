#!/usr/bin/env bash

set -e

# This mutes and unmutes the microphone for video calls and is meant to be bound to a shortcut.

# Look for WM_NAME in `xprop` output, e.g.
# WM_NAME(UTF8_STRING) = "Google Meet - Meet - qup-bwhq-mbc"
# to configue WINDOW_* variables

SLEEP_INTERVAL=0.1

function mute_or_unmute_google_meet() {
    local WINDOW_NAME_GOOGLE_MEET='Meet - .+'
    xdotool search --name "$WINDOW_NAME_GOOGLE_MEET" \
        windowactivate --sync \
        sleep "$SLEEP_INTERVAL" \
        key ctrl+d
}

function mute_or_unmute_microsoft_teams() {
    local WINDOW_NAME_MS_TEAMS='.* \| Microsoft Teams.*'
    xdotool search --name "$WINDOW_NAME_MS_TEAMS" \
        windowactivate --sync \
        sleep "$SLEEP_INTERVAL" \
        key ctrl+shift+m
}

function mute_or_unmute_slack_huddle() {
    local WINDOW_NAME_SLACK_MAIN=' - Slack'
    local WINDOW_NAME_SLACK_HUDDLE='^Slack - .+ - Huddle$'
    xdotool search --name "$WINDOW_NAME_SLACK_HUDDLE" \
        windowactivate --sync \
        sleep "$SLEEP_INTERVAL" \
        key ctrl+shift+space \
    || xdotool search --name "$WINDOW_NAME_SLACK_MAIN" \
        windowactivate --sync \
        sleep "$SLEEP_INTERVAL" \
        key ctrl+shift+space
    }

ACTIVE_WINDOW=$(xdotool getactivewindow)
false \
    || mute_or_unmute_microsoft_teams \
    || mute_or_unmute_google_meet \
    || mute_or_unmute_slack_huddle
xdotool windowactivate "$ACTIVE_WINDOW"
