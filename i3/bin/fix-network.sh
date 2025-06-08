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
    # Check existing connections
    local has_wired=false
    local has_wireless=false

    # Check wired connection status
    if nmcli -t -f DEVICE,TYPE,STATE dev | grep -q 'ethernet:connected'; then
        has_wired=true
        echo "Wired connection already active"
    fi

    # Check wireless connection status
    if nmcli -t -f NAME,TYPE,STATE con | grep -q "$NMCLI_PRIMARY_WIFI_SSID:wireless:activated"; then
        has_wireless=true
        echo "Wireless connection already active"
    fi

    # Start wired if not active
    if ! $has_wired; then
        echo "Attempting to activate wired connection"
        for conn in $(nmcli -t -f NAME,TYPE con | grep ':ethernet$' | cut -d: -f1); do
            nmcli con up "$conn" || echo "Failed to activate wired connection $conn"
        done
    fi

    # Start wireless if not active
    if ! $has_wireless; then
        echo "Attempting to activate wireless connection"
        if nmcli con show | grep -q "$NMCLI_PRIMARY_WIFI_SSID"; then
            nmcli con up "$NMCLI_PRIMARY_WIFI_SSID"
        else
            nmcli device wifi connect "$NMCLI_PRIMARY_WIFI_SSID" --ask
        fi
    fi
}

function connect_with_netctl {
    # Load profiles and categorize them
    load_profiles() {
        local -n profiles=$1
        local type=$2
        profiles=($(find /etc/netctl -maxdepth 1 -type f -name "$type-*" -not -name '*examples*' -not -name '*.bak' -printf '%f\n'))

        if [ ${#profiles[@]} -eq 0 ] && [ "$type" = "ethernet" ]; then
            profiles=($(printf '%s\n' "${NETCTL_PROFILES[@]}" | grep '^ethernet-'))
        elif [ ${#profiles[@]} -eq 0 ] && [ "$type" = "wifi" ]; then
            profiles=($(printf '%s\n' "${NETCTL_PROFILES[@]}" | grep '^wifi-'))
        fi
    }

    # Attempt to connect profiles of given type
    try_connect() {
        local type=$1
        local -n profiles=$2
        local active=false

        for profile in "${profiles[@]}"; do
            if sudo netctl is-active "$profile"; then
                echo "$(tr '[:lower:]' '[:upper:]' <<< ${type:0:1})${type:1} profile '$profile' already active"
                active=true
            fi
        done

        if ! $active; then
            for profile in "${profiles[@]}"; do
                echo "Starting $type profile: $profile"
                sudo netctl stop "$profile" 2>/dev/null
                sudo netctl start "$profile" || echo "Starting $profile failed" &
            done
            [ "$type" = "ethernet" ] && sleep 2  # Give wired head start
        else
            echo "Skipping $type profiles - existing connection detected"
        fi
    }

    # Main logic
    local wired_profiles wireless_profiles
    load_profiles wired_profiles ethernet
    load_profiles wireless_profiles wifi

    try_connect ethernet wired_profiles
    try_connect wifi wireless_profiles

    # Poll connection status
    echo -n "Waiting for connection"
    for i in {1..10}; do
        online && echo " Done" && break
        echo -n "." && sleep 1
    done

    # Fallback sequential attempt if still offline
    if ! online; then
        for profile in "${wired_profiles[@]}" "${wireless_profiles[@]}"; do
            echo "Retrying profile: $profile"
            sudo netctl restart "$profile" || echo "Restarting $profile failed"
            sleep 2
            online && break
        done
    fi
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
        echo "We're online, but ensuring all connections are active..."
    else
        echo 'Fixing network...'
    fi
    connect_to_internet
}

set -e
main
