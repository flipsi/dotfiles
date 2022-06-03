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

setup_wallpaper() {
    if [[ -f "$HOME/.i3/wallpaper" ]]; then
        feh --bg-scale "$HOME/.i3/wallpaper"
    fi
}


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

    dwarf | falbala )

        if test -n "$ONLY"; then

            OUTPUT_TO_KEEP='eDP1'

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

            xrandr --output "$OUTPUT_TO_KEEP" --mode '1920x1080' --auto

        elif xrandr | grep 'DP.-. connected' >/dev/null; then
            BAR_MAIN_MONITOR=$(xrandr | grep 'DP.-2 connected' | cut -d' ' -f1 | head -n1)
            BAR_SECOND_MONITOR=$(xrandr | grep 'DP.-1 connected' | cut -d' ' -f1 | head -n1)
            BAR_THIRD_MONITOR='eDP1'

            xrandr --output "$BAR_MAIN_MONITOR" --auto --primary \
                --output "$BAR_SECOND_MONITOR" --auto --left-of "$BAR_MAIN_MONITOR" \
                --output "$BAR_THIRD_MONITOR" --auto --left-of "$BAR_SECOND_MONITOR" \
                || ( \
                sleep 0.1 && xrandr --output "$BAR_THIRD_MONITOR" --off && \
                sleep 0.1 && xrandr --output "$BAR_MAIN_MONITOR" --primary --auto && \
                sleep 0.1 && xrandr --output "$BAR_SECOND_MONITOR" --auto --right-of "$BAR_MAIN_MONITOR" && \
                sleep 0.1 && xrandr --output "$BAR_THIRD_MONITOR" --auto --left-of "$BAR_SECOND_MONITOR" \
                )

        elif xrandr | grep 'HDMI1 connected' >/dev/null; then

            sleep 0.1 && xrandr --output 'HDMI1' --left-of 'eDP1'  --auto

        fi
        ;;

    * )

        echo ERROR: Unknown host!
        exit 1

esac


# setup_wallpaper

