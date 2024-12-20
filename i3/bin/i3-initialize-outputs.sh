#!/bin/bash

set -e

DIRNAME=$(dirname "$0")


TEMP=$(getopt -o osf --long only,swapped,fix-offset -n "$0" -- "$@")
eval set -- "$TEMP"
while true ; do
    case "$1" in
        -o|--only) ONLY=true ; shift ;;
        -s|--swapped) DISPLAY_LINK_OUTPUTS_SWAPPED=true ; shift ;;
        -f|--fix-offset) FIX_THIRD_MONITOR_OFFSET=true ; shift ;;
        --) shift ; break ;;
        *) echo 'Internal error!' ; exit 1 ;;
    esac
done

function setup_wallpaper() {
    WALLPAPER="$HOME/.i3/wallpaper/gray_3A3A3A_1920x1080.png"
    if [[ -f "$WALLPAPER" ]]; then
        feh --bg-scale "$WALLPAPER"
    fi
}


function arrange_outputs_at_home() {
    # TODO: pick highest resolution automatically?
    if xrandr | grep -q "$MAIN_MONITOR connected" && \
        xrandr | grep -q "$SECOND_MONITOR connected" && \
        xrandr | grep -q "$THIRD_MONITOR connected"; then
            xrandr \
                --output "$LAPTOP_SCREEN" --off \
                --output "$THIRD_MONITOR" --mode 2560x1440 --pos 0x0 --rotate left \
                --output "$MAIN_MONITOR" --primary --mode 2560x1440 --pos 1440x560 --rotate normal \
                --output "$SECOND_MONITOR" --mode 2560x1440 --pos 4000x0 --rotate left \
                || ( \
                sleep 0.1 && xrandr --output "$LAPTOP_SCREEN" --off && \
                sleep 0.1 && xrandr --output "$THIRD_MONITOR" --off && \
                sleep 0.1 && xrandr --output "$MAIN_MONITOR" --primary --auto && \
                sleep 0.1 && xrandr --output "$SECOND_MONITOR" --auto --right-of "$MAIN_MONITOR" --rotate right && \
                sleep 0.1 && xrandr --output "$THIRD_MONITOR" --auto --left-of "$MAIN_MONITOR" --rotate left
            )

    elif xrandr | grep -q "$MAIN_MONITOR connected" && \
        xrandr | grep -q "$SECOND_MONITOR connected"; then
            xrandr \
                --output "$LAPTOP_SCREEN" --off \
                --output "$SECOND_MONITOR" --mode 2560x1440 --pos 0x0 --rotate left \
                --output "$MAIN_MONITOR" --primary --mode 2560x1440 --pos 1440x500 --rotate normal \
                || ( \
                sleep 0.1 && xrandr --output "$LAPTOP_SCREEN" --off && \
                sleep 0.1 && xrandr --output "$THIRD_MONITOR" --off && \
                sleep 0.1 && xrandr --output "$MAIN_MONITOR" --primary --auto && \
                sleep 0.1 && xrandr --output "$SECOND_MONITOR" --auto --right-of "$MAIN_MONITOR" --rotate right
            )

    elif xrandr | grep -q "$MAIN_MONITOR connected" && \
        xrandr | grep -q "$THIRD_MONITOR connected"; then
            xrandr \
                --output "$LAPTOP_SCREEN" --off \
                --output "$MAIN_MONITOR" --primary --mode 2560x1440 --rotate normal \
                --output "$THIRD_MONITOR" --mode 2560x1440 --pos 2560x0 --rotate left \
                || ( \
                sleep 0.1 && xrandr --output "$LAPTOP_SCREEN" --off && \
                sleep 0.1 && xrandr --output "$SECOND_MONITOR" --off && \
                sleep 0.1 && xrandr --output "$MAIN_MONITOR" --primary --auto && \
                sleep 0.1 && xrandr --output "$THIRD_MONITOR" --auto --left-of "$MAIN_MONITOR" --rotate right
            )

    fi
}

function disable_all_but_one_output() {
    if ! xrandr | grep -q "$OUTPUT_TO_KEEP connected"; then
        echo "Only output $OUTPUT_TO_KEEP seems unavailable. Aborting."
        exit 1
    fi

    mapfile -t MONITOR_LIST < <(xrandr | grep ' connected' | cut -d' ' -f1)
    for MONITOR in "${MONITOR_LIST[@]}"; do
        if [[ "$MONITOR" != "$OUTPUT_TO_KEEP" ]]; then
            xrandr --output "$MONITOR" --off
        fi
    done

    xrandr --output "$OUTPUT_TO_KEEP" --auto
}

function main() {

    case $(hostname) in

        asterix )

            if test -n "$ONLY"; then

                xrandr --output 'HDMI2' --off
                xrandr --output 'eDP1' --mode '1920x1080_60.00' --auto

            elif xrandr | grep -q 'HDMI2 connected'; then

                # on big tv, turn off laptop screen
                if xrandr | grep -q '4096x2160'; then
                    xrandr --output 'HDMI2' --mode 4096x2160 --output 'eDP1' --off
                else
                    xrandr --output 'HDMI2' --mode 1920x1080 --pos 0x540 --rotate normal --output 'HDMI1' --off --output 'DP1' --off --output 'eDP1' --mode 960x540 --pos 0x0 --rotate normal --output VIRTUAL1 --off
                fi

            elif xrandr | grep 'eDP1 connected 960x540' >/dev/null; then

                xrandr --output 'HDMI2' --off
                xrandr --newmode "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
                xrandr --addmode 'eDP1' "1920x1080_60.00"
                xrandr --output 'eDP1' --mode "1920x1080_60.00"

            fi
            ;;

        mimir )

            LAPTOP_SCREEN='eDP-1'

            if test -n "$ONLY"; then

                OUTPUT_TO_KEEP='eDP-1'
                disable_all_but_one_output

            elif xrandr | grep -q 'DVI-I-1-1 connected'; then

                MAIN_MONITOR='DP-1'
                if test -n "$DISPLAY_LINK_OUTPUTS_SWAPPED"; then
                    SECOND_MONITOR='DVI-I-2-2'
                    THIRD_MONITOR='DVI-I-1-1'
                else
                    SECOND_MONITOR='DVI-I-1-1'
                    THIRD_MONITOR='DVI-I-2-2'
                fi

                if test -n "$FIX_THIRD_MONITOR_OFFSET"; then
                    xrandr --output "$THIRD_MONITOR" --off
                    sleep 2
                fi
                arrange_outputs_at_home

            # when displaylink is broken again and I connect multiple cables
            elif xrandr | grep 'HDMI-1 connected' >/dev/null && xrandr | grep 'DP-1 connected' >/dev/null; then
                xrandr --output "$LAPTOP_SCREEN" --off \
                    --output 'DP-1' --auto \
                    --output 'HDMI-1' --right-of 'DP-1'

            elif xrandr | grep 'HDMI-1 connected' >/dev/null; then
                xrandr --output 'HDMI-1' --above "$LAPTOP_SCREEN"  --auto

            elif xrandr | grep 'DP-1 connected' >/dev/null; then
                xrandr --output 'DP-1' --above "$LAPTOP_SCREEN"  --auto

            elif xrandr | grep 'DP-3 connected' >/dev/null; then
                xrandr --output 'DP-3' --right-of "$LAPTOP_SCREEN"  --auto

            fi
            ;;

        frey )

            LAPTOP_SCREEN='eDP'
            MAIN_MONITOR='DisplayPort-0'
            SECOND_MONITOR='DisplayPort-1'
            THIRD_MONITOR='HDMI-A-0'

            if xrandr | grep -q "$MAIN_MONITOR connected" && \
                xrandr | grep -q "$SECOND_MONITOR connected" && \
                xrandr | grep -q "$THIRD_MONITOR connected"; then
                            arrange_outputs_at_home

            elif xrandr | grep -q "$MAIN_MONITOR connected" && \
                xrandr | grep -q "$SECOND_MONITOR connected"; then
                            arrange_outputs_at_home

            elif xrandr | grep -q "$MAIN_MONITOR connected" && \
                xrandr | grep -q "$THIRD_MONITOR connected"; then
                            SECOND_MONITOR='HDMI-A-0'
                            THIRD_MONITOR='DisplayPort-1'
                            arrange_outputs_at_home

            elif xrandr | grep -q "$MAIN_MONITOR connected"; then
                xrandr --output "$MAIN_MONITOR" --auto \
                    --output "$LAPTOP_SCREEN" --right-of "$MAIN_MONITOR"

            fi
            ;;

        falbala )

            if test -n "$ONLY"; then

                OUTPUT_TO_KEEP='eDP1'

                disable_all_but_one_output

            elif xrandr | grep -q 'HDMI2 connected'; then

                MAIN_MONITOR='DP1'
                SECOND_MONITOR='HDMI2'
                THIRD_MONITOR='DisplayPort-0'
                LAPTOP_SCREEN='eDP1'
                arrange_outputs_at_home

            elif xrandr | grep -q 'DVI-I-1-1 connected'; then

                MAIN_MONITOR='DP1'
                SECOND_MONITOR='DVI-I-1-1'
                THIRD_MONITOR='DVI-I-2-2'
                LAPTOP_SCREEN='eDP1'
                arrange_outputs_at_home

            elif xrandr | grep -q 'DP1 connected'; then

                MAIN_MONITOR='DP1'
                SECOND_MONITOR='eDP1'

                xrandr --output "$LAPTOP_SCREEN" --auto \
                    --output "$MAIN_MONITOR" --primary --auto --left-of "$LAPTOP_SCREEN"

            elif xrandr | grep 'HDMI1 connected' >/dev/null; then
                sleep 0.1 && xrandr --output 'HDMI1' --above 'eDP1'  --auto

            elif xrandr | grep 'DP-1 connected' >/dev/null; then
                sleep 0.1 && xrandr --output 'DP-1' --above 'eDP1'  --auto

            fi
            ;;

        nott )

            if test -n "$ONLY"; then

                OUTPUT_TO_KEEP='eDP-1'

                disable_all_but_one_output

            elif xrandr | grep -q 'HDMI-1 connected'; then

                MAIN_MONITOR='DP-1'
                SECOND_MONITOR='DP-3'
                THIRD_MONITOR='HDMI-1'
                LAPTOP_SCREEN='eDP-1'
                arrange_outputs_at_home

            elif xrandr | grep -q 'DP-1 connected'; then

                MAIN_MONITOR='DP-1'
                LAPTOP_SCREEN='eDP-1'
                xrandr \
                    --output "$LAPTOP_SCREEN" --auto \
                    --output "$MAIN_MONITOR" --auto --right-of "$LAPTOP_SCREEN"

            elif xrandr | grep -q 'DP-3 connected'; then

                MAIN_MONITOR='DP-3'
                LAPTOP_SCREEN='eDP-1'
                xrandr \
                    --output "$LAPTOP_SCREEN" --auto \
                    --output "$MAIN_MONITOR" --auto --right-of "$LAPTOP_SCREEN"
            fi

            ;;

        * )

            echo ERROR: Unknown host!
            exit 1

        esac

}

main
"$DIRNAME/i3-polybar.sh" stop
"$DIRNAME/i3-polybar.sh" start

setup_wallpaper

