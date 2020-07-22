#!/usr/bin/env bash

function set_env_vars() {
    export HOSTNAME
    export  ETH_INTERFACE
    export WLAN_INTERFACE
    export BAR_MAIN_MONITOR
    export BAR_MAIN_DPI
    export BAR_MAIN_HEIGHT
    export BAR_TRAY_MAXSIZE

    ETH_INTERFACE=$( ip link show | grep enp | sed 's/.*: \(.*\):.*/\1/')
    WLAN_INTERFACE=$(ip link show | grep wlp | sed 's/.*: \(.*\):.*/\1/')

    HOSTNAME=$(hostname)
    case $HOSTNAME in
        falbala )
            if xrandr | grep -q 'DP2-1 connected 4096x2160'; then
                BAR_MAIN_MONITOR=HDMI2
                BAR_MAIN_DPI=300
                BAR_MAIN_HEIGHT=60
                BAR_TRAY_MAXSIZE=28
            elif xrandr | grep -q 'DP2-1 connected'; then
                BAR_MAIN_MONITOR=DP2-1
                BAR_MAIN_DPI=108
                BAR_MAIN_HEIGHT=24
                BAR_TRAY_MAXSIZE=16
            else
                BAR_MAIN_DPI=100
            fi
            ;;
        dwarf )
            if xrandr | grep -q 'DP3-1 connected'; then
                BAR_MAIN_MONITOR='DP3-1'
            elif xrandr | grep -q 'DP3-2 connected'; then
                BAR_MAIN_MONITOR='DP3-2'
            elif xrandr | grep -q 'HDMI1 connected'; then
                BAR_MAIN_MONITOR='HDMI1'
            fi
            BAR_MAIN_DPI=108
            BAR_MAIN_HEIGHT=24
            BAR_TRAY_MAXSIZE=16
            ;;
        * )
            BAR_MAIN_MONITOR=$(xrandr | grep ' connected' | cut -d' ' -f1 | head -n1)
            ;;
    esac
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
