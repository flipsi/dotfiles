#!/usr/bin/env bash

set -e

FALLBACK_DEVICE='1-4'


function print_help_msg() {
    cat <<-EOF
Disable USB device (like mouse) to wake up from suspend.

You may want to run this at startup as root:
Execute \`sudo crontab -e\`
and add the following at the end of the file:
@reboot $(realpath "$0")

Source:
https://askubuntu.com/a/1373808/1240029
https://codetrips.com/2020/03/18/ubuntu-disable-mouse-wake-from-suspend/


Usage: $(basename "$0") (--help|--list)
or:    $(basename "$0") [--enable] [DEVICE]

    OPTIONS:

    -h|--help
        Print this help message.

    -l|--list
        Lists USB devices that can currently wakeup from suspend.

    -e|--enable
        Enable device instead of disable. If omitted, device is disabled.

    DEVICE
        Optional.
        Device to disable (or enable). Defaults to "$FALLBACK_DEVICE"

EOF
}


function parse_arguments() {
    while [[ $# -ge 1 ]]; do
        case "$1" in
            -e|--enable)
                ENABLE_DEVICE=true
                ;;
            -l|--list)
                list_devices
                exit
                ;;
            -h|--help)
                print_help_msg
                exit
                ;;
            *)
                DEVICE="$1"
                ;;
        esac
        shift
    done
}


# Also, `lsusb | sort` may be helpful
function list_devices() {
    grep . /sys/bus/usb/devices/*/power/wakeup | grep enabled
}


function require_superuser() {
    if [[ $(whoami) != 'root' ]]; then
        echo "Superuser privileges required."
        exit 1
    fi
}


function disable_device() {
    DEVICE="$1"
    if [[ -n "$ENABLE_DEVICE" ]]; then
        VALUE='enabled'
    else
        VALUE='disabled'
    fi
    sh -c "echo '$VALUE' > /sys/bus/usb/devices/$DEVICE/power/wakeup"
}


parse_arguments "$@"
DEVICE="${DEVICE:-$FALLBACK_DEVICE}"

require_superuser
disable_device "$DEVICE"
