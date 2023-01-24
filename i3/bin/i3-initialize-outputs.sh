#!/bin/bash

TEMP=$(getopt -o o --long only -n 'test.sh' -- "$@")
eval set -- "$TEMP"
while true ; do
    case "$1" in
        -o|--only) ONLY=true ; shift ;;
        --) shift ; break ;;
        *) echo 'Internal error!' ; exit 1 ;;
    esac
done

function setup_wallpaper() {
    if [[ -f "$HOME/.i3/wallpaper" ]]; then
        feh --bg-scale "$HOME/.i3/wallpaper"
    fi
}


function arrange_outputs_at_home() {
    xrandr \
        --output "$LAPTOP_SCREEN" --off \
        --output "$THIRD_MONITOR" --mode 2560x1440 --pos 0x0 --rotate left \
        --output "$MAIN_MONITOR" --primary --mode 2560x1440 --pos 1440x500 --rotate normal \
        --output "$SECOND_MONITOR" --mode 2560x1440 --pos 4000x560 --rotate normal \
        || ( \
        sleep 0.1 && xrandr --output "$LAPTOP_SCREEN" --off && \
        sleep 0.1 && xrandr --output "$THIRD_MONITOR" --off && \
        sleep 0.1 && xrandr --output "$MAIN_MONITOR" --primary --auto && \
        sleep 0.1 && xrandr --output "$SECOND_MONITOR" --auto --right-of "$MAIN_MONITOR" && \
        sleep 0.1 && xrandr --output "$THIRD_MONITOR" --auto --left-of "$MAIN_MONITOR" --rotate left \
    )
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

            if test -n "$ONLY"; then

                OUTPUT_TO_KEEP='eDP-1'

                disable_all_but_one_output

            elif xrandr | grep -q 'DVI-I-1-1 connected'; then

                MAIN_MONITOR='DP-1'
                SECOND_MONITOR='DVI-I-1-1'
                THIRD_MONITOR='DVI-I-2-2'
                LAPTOP_SCREEN='eDP-1'

                arrange_outputs_at_home

            elif xrandr | grep 'HDMI-1 connected' >/dev/null; then

                sleep 0.1 && xrandr --output 'HDMI-1' --above 'eDP-1'  --auto

            fi
            ;;

        falbala )

            if test -n "$ONLY"; then

                OUTPUT_TO_KEEP='eDP1'

                disable_all_but_one_output

            elif xrandr | grep -q 'DVI-I-1-1 connected'; then

                MAIN_MONITOR='DP1'
                SECOND_MONITOR='DVI-I-1-1'
                THIRD_MONITOR='DVI-I-2-2'
                LAPTOP_SCREEN='eDP1'

                xrandr --output "$LAPTOP_SCREEN" --auto \
                    --output "$SECOND_MONITOR" --auto --above "$LAPTOP_SCREEN" \
                    --output "$MAIN_MONITOR" --primary --auto --left-of "$SECOND_MONITOR" \
                    --output "$THIRD_MONITOR" --off

            elif xrandr | grep 'HDMI1 connected' >/dev/null; then

                sleep 0.1 && xrandr --output 'HDMI1' --above 'eDP1'  --auto

            fi
            ;;

        * )

            echo ERROR: Unknown host!
            exit 1

        esac

}

main

# setup_wallpaper

