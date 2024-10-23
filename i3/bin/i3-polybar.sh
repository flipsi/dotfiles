#!/usr/bin/env bash

set -e

function find_network_interface_name_by_pattern() {
    PATTERN="$1"
    ip link show \
        | grep -E "$PATTERN" \
        | sed 's/.*: \(.*\):.*/\1/' \
        | tail -n 1
}

function set_env_vars() {
    export HOSTNAME
    export  ETH_INTERFACE
    export WLAN_INTERFACE
    export BAR_MAIN_MONITOR
    export BAR_SECOND_MONITOR
    export BAR_THIRD_MONITOR
    export BAR_DPI
    export BAR_HEIGHT
    export BAR_TRAY_SIZE
    export BAR_MODULES_MAIN_LEFT
    export BAR_MODULES_MAIN_CENTER
    export BAR_MODULES_MAIN_RIGHT
    export BAR_MODULES_SECOND_LEFT
    export BAR_MODULES_SECOND_CENTER
    export BAR_MODULES_SECOND_RIGHT
    export BAR_MODULES_THIRD_LEFT
    export BAR_MODULES_THIRD_CENTER
    export BAR_MODULES_THIRD_RIGHT

    ETH_INTERFACE='enp7s0f3u1u3u1'
    WLAN_INTERFACE=$(find_network_interface_name_by_pattern '(wlan|wlp)')

    HOSTNAME=$(hostname)
    case $HOSTNAME in
        falbala )
            if xrandr | grep -q '^DP1 connected'; then
                BAR_MAIN_MONITOR='DP1'
                if xrandr | grep -q 'DVI-I-2-2 connected'; then
                    BAR_SECOND_MONITOR='DVI-I-2-2'
                    BAR_THIRD_MONITOR='DVI-I-1-1'
                elif xrandr | grep -q 'HDMI2 connected'; then
                    BAR_SECOND_MONITOR='HDMI2'
                    BAR_THIRD_MONITOR='eDP1'
                else
                    BAR_SECOND_MONITOR='eDP1'
                fi
            else
                BAR_MAIN_MONITOR='eDP1'
            fi
            ;;
        mimir )
            if xrandr | grep -q 'DVI-I-1-1 connected'; then
                BAR_MAIN_MONITOR='DP-1'
                BAR_SECOND_MONITOR='DVI-I-1-1'
                BAR_THIRD_MONITOR='DVI-I-2-2'
            elif xrandr | grep -q 'HDMI-1 connected' && xrandr | grep -q '^DP-1 connected' ; then
                BAR_MAIN_MONITOR='DP-1'
                BAR_SECOND_MONITOR='HDMI-1'
            elif xrandr | grep -q 'HDMI-1 connected'; then
                BAR_MAIN_MONITOR='HDMI-1'
            elif xrandr | grep -q '^DP-1 connected'; then
                BAR_MAIN_MONITOR='DP-1'
            elif xrandr | grep -q '^DP-3 connected'; then
                BAR_MAIN_MONITOR='DP-3'
                BAR_SECOND_MONITOR='eDP-1'
            else
                BAR_MAIN_MONITOR='eDP-1'
            fi
            ;;
        * )
            if xrandr | grep -q 'HDMI2 connected 4096x2160'; then
                BAR_MAIN_MONITOR='HDMI2'
                BAR_SECOND_MONITOR='eDP1'
                BAR_DPI=300
                BAR_HEIGHT=60
                BAR_TRAY_SIZE=28
            elif xrandr | grep -q 'HDMI-A-0 connected' && xrandr | grep -q 'DisplayPort-0 connected' && xrandr | grep -q 'DisplayPort-1 connected'; then
                BAR_MAIN_MONITOR='DisplayPort-0'
                BAR_SECOND_MONITOR='DisplayPort-1'
                BAR_THIRD_MONITOR='HDMI-A-0'
            elif xrandr | grep -q 'HDMI-A-0 connected' && xrandr | grep -q 'DisplayPort-0 connected'; then
                BAR_MAIN_MONITOR='DisplayPort-0'
                BAR_SECOND_MONITOR='HDMI-A-0'
            elif xrandr | grep -q 'DisplayPort-1 connected' && xrandr | grep -q 'DisplayPort-0 connected'; then
                BAR_MAIN_MONITOR='DisplayPort-0'
                BAR_SECOND_MONITOR='DisplayPort-1'
            elif xrandr | grep -q 'DisplayPort-. connected'; then
                BAR_MAIN_MONITOR=$(xrandr | grep -E 'DisplayPort-. connected' | cut -d' ' -f1 | head -n1)
                BAR_SECOND_MONITOR='eDP'
            elif xrandr | grep -q 'DVI-I-1-1 connected'; then
                # BAR_MAIN_MONITOR=$(xrandr | grep -E '[^e]DP.-?. connected' | cut -d' ' -f2 | head -n1) # ^ not working
                BAR_MAIN_MONITOR=$(xrandr | grep -E 'DP.-?. connected' | cut -d' ' -f2 | head -n1)
                BAR_SECOND_MONITOR='DVI-I-2-2'
                BAR_THIRD_MONITOR='DVI-I-1-1'
            elif xrandr | grep -q 'DP1 connected'; then
                BAR_MAIN_MONITOR='DP1'
                BAR_SECOND_MONITOR='eDP1'
            elif xrandr | grep -q 'DP.-2 connected'; then
                BAR_MAIN_MONITOR=$(xrandr | grep 'DP.-2 connected' | cut -d' ' -f1 | head -n1)
                BAR_SECOND_MONITOR=$(xrandr | grep 'DP.-1 connected' | cut -d' ' -f1 | head -n1)
                BAR_THIRD_MONITOR='eDP1'
            elif xrandr | grep -q 'HDMI. connected'; then
                BAR_MAIN_MONITOR=$(xrandr | grep 'HDMI. connected' | cut -d' ' -f1 | head -n1)
                BAR_SECOND_MONITOR='eDP1'
            else
                BAR_MAIN_MONITOR=$(xrandr | grep ' connected' | cut -d' ' -f1 | head -n1)
            fi
            ;;
    esac
    BAR_DPI=108
    BAR_HEIGHT=24
    BAR_TRAY_SIZE=16

    if [[ -n "$BAR_THIRD_MONITOR" ]]; then
        BAR_MODULES_MAIN_LEFT="pulseaudio spotify"
        BAR_MODULES_MAIN_CENTER="i3"
        BAR_MODULES_MAIN_RIGHT="xkeyboard date powermenu"
        BAR_MODULES_SECOND_LEFT="battery wlan eth"
        BAR_MODULES_SECOND_CENTER="i3"
        BAR_MODULES_SECOND_RIGHT="spotify pulseaudio xkeyboard date powermenu tray"
        BAR_MODULES_THIRD_LEFT="filesystem"
        BAR_MODULES_THIRD_CENTER="i3"
        BAR_MODULES_THIRD_RIGHT="cpu memory"
    elif [[ -n "$BAR_SECOND_MONITOR" ]]; then
        BAR_MODULES_MAIN_LEFT="cpu memory"
        BAR_MODULES_MAIN_CENTER="i3"
        BAR_MODULES_MAIN_RIGHT="spotify pulseaudio xkeyboard date"
        BAR_MODULES_SECOND_LEFT="powermenu battery wlan eth"
        BAR_MODULES_SECOND_CENTER="i3"
        BAR_MODULES_SECOND_RIGHT="weather tray"
    else
        BAR_MODULES_MAIN_LEFT="i3"
        BAR_MODULES_MAIN_CENTER="battery wlan eth tray"
        BAR_MODULES_MAIN_RIGHT="spotify pulseaudio xkeyboard date powermenu"
    fi
}

function stop() {
    if pgrep polybar; then
        killall -q polybar
    fi
}

function start() {
    while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
    set_env_vars
    polybar main &
    if [[ -n $BAR_SECOND_MONITOR ]]; then
        polybar second &
        if [[ -n $BAR_THIRD_MONITOR ]]; then
            polybar third &
        fi
    fi
}

function toggle() {
    if pgrep polybar; then
        stop
    else
        start
    fi
}

case $1 in
    start|restart ) stop ; start ;;
    stop )          stop ;;
    toggle )        toggle ;;
    * )             echo "Say 'start', 'stop' or 'toggle' my sweetheart!"
                    exit 2
esac
