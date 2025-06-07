#!/usr/bin/env bash

NMCLI_PRIMARY_WIFI_SSID='GALLISCHES'
NETCTL_PROFILES=('ethernet-home' 'wifi-GALLISCHES' 'wifi-reply-N')

function has {
    type "$1" > /dev/null 2>&1
}

function online {
    ping -c 1 8.8.8.8 >/dev/null 2>&1
}

function connect_with_nmcli {
    # https://docs.fedoraproject.org/en-US/quick-docs/configuring-ip-networking-with-nmcli/
    WIFI_CONNECTION_NAME="$NMCLI_PRIMARY_WIFI_SSID"
    if nmcli con show | grep -q "$WIFI_CONNECTION_NAME"; then
        nmcli con up "$WIFI_CONNECTION_NAME"
    else
        nmcli device wifi connect "$NMCLI_PRIMARY_WIFI_SSID" --ask
    fi
    # ethernet should work out of the box
}

function connect_with_netctl {
    # TODO: query existing profiles
    # TODO: create profile if no exist
    # TODO: try in a smart order
    for PROFILE in "${!NETCTL_PROFILES[@]}"; do
        sudo netctl restart "$PROFILE" || echo "Starting $ETH_PROFILE failed."
        if online; then return; fi
    done
}

function connect_to_internet {
    if has nmcli; then
        connect_with_nmcli
    elif has netctl; then
        connect_with_netctl
    else
        echo "ERROR: No supported network manager found"
        exit 1
    fi
}

function main {
    if online; then
        echo "We're already online."
    else
        echo 'Fixing network...'
        connect_to_internet
    fi
}

set -e
main
