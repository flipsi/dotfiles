#!/usr/bin/env bash

function set_env_vars() {
    export HOSTNAME
    export  ETH_INTERFACE
    export WLAN_INTERFACE
    export MAIN_MONITOR

    ETH_INTERFACE=$( ip link show | grep enp | sed 's/.*: \(.*\):.*/\1/')
    WLAN_INTERFACE=$(ip link show | grep wlp | sed 's/.*: \(.*\):.*/\1/')

    HOSTNAME=$(hostname)
    case $HOSTNAME in
        asterix )
            MAIN_MONITOR=eDP1
            ;;
        dwarf )
            MAIN_MONITOR=HDMI-2
            ;;
        * )
            MAIN_MONITOR=$(xrandr | grep ' connected' | grep DP | cut -d' ' -f1)
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
