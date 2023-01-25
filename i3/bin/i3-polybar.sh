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
    export BAR_TRAY_MAXSIZE

    ETH_INTERFACE=$(find_network_interface_name_by_pattern 'enp')
    WLAN_INTERFACE=$(find_network_interface_name_by_pattern '(wlan|wlp)')

    HOSTNAME=$(hostname)
    case $HOSTNAME in
        falbala )
            if xrandr | grep -q 'DVI-I-1-1 connected'; then
                BAR_MAIN_MONITOR='DP1'
                BAR_SECOND_MONITOR='DVI-I-2-2'
                BAR_THIRD_MONITOR='DVI-I-1-1'
            else
                BAR_MAIN_MONITOR='eDP1'
            fi
            ;;
        mimir )
            if xrandr | grep -q 'DVI-I-1-1 connected'; then
                BAR_MAIN_MONITOR='DP-1'
                BAR_SECOND_MONITOR='DVI-I-1-1'
                BAR_THIRD_MONITOR='DVI-I-2-2'
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
                BAR_TRAY_MAXSIZE=28
            elif xrandr | grep -q 'DVI-I-1-1 connected'; then
                # BAR_MAIN_MONITOR=$(xrandr | grep -E '[^e]DP.-?. connected' | cut -d' ' -f-2 | head -n1) # ^ not working
                BAR_MAIN_MONITOR=$(xrandr | grep -E 'DP.-?. connected' | cut -d' ' -f-2 | head -n1)
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
    BAR_TRAY_MAXSIZE=16
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
