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

function is_screen_enabled() {
    local screen="$1"
    xrandr | grep -w "$screen" | grep -qP '\d+x\d+\+\d+\+\d+'
}

function get_laptop_screen() {
    xrandr | grep -E 'eDP-?.? connected' | head -n1 | cut -d ' ' -f1
}

function get_external_screen() { # (assuming there is only one)
    xrandr | grep ' connected' | grep -v -E 'eDP-?.? connected' | head -n1 | cut -d ' ' -f1
}

function get_remaining_screen() { # (assuming there is only one)
    xrandr | grep ' connected' | head -n1 | cut -d ' ' -f1
}

function get_screen_with_greater_x_position() {
    local screen1="$1"
    local screen2="$2"
    x1=$(xrandr | grep -w "$screen1" | grep -oP '\+\K\d+' | head -n1)
    x2=$(xrandr | grep -w "$screen2" | grep -oP '\+\K\d+' | head -n1)
    if [[ "$x1" -gt "$x2" ]]; then
        echo "$screen1"
    elif [[ "$x2" -gt "$x1" ]]; then
        echo "$screen2"
    else
        echo "Both screens have the same X position."
    fi
}

# TODO: pick highest resolution automatically?
#
function arrange_outputs() {

    # only at home, I've got 3 external screens (2 of them in portrait mode, so rotate them).
    # use them and disable laptop screen.
    if true && \
        xrandr | grep -q "$MAIN_SCREEN connected" && \
        xrandr | grep -q "$SECOND_SCREEN connected" && \
        xrandr | grep -q "$THIRD_SCREEN connected"; then
        xrandr \
            --output "$LAPTOP_SCREEN" --off \
            --output "$THIRD_SCREEN" --mode 2560x1440 --pos 0x0 --rotate left \
            --output "$MAIN_SCREEN" --primary --mode 2560x1440 --pos 1440x560 --rotate normal \
            --output "$SECOND_SCREEN" --mode 2560x1440 --pos 4000x0 --rotate left \
            || ( \
            sleep 0.1 && xrandr --output "$LAPTOP_SCREEN" --off && \
            sleep 0.1 && xrandr --output "$THIRD_SCREEN" --off && \
            sleep 0.1 && xrandr --output "$MAIN_SCREEN" --primary --auto && \
            sleep 0.1 && xrandr --output "$SECOND_SCREEN" --auto --right-of "$MAIN_SCREEN" --rotate right && \
            sleep 0.1 && xrandr --output "$THIRD_SCREEN" --auto --left-of "$MAIN_SCREEN" --rotate left
        )

    # but one of the 3 may be disconnected
    elif true && \
        xrandr | grep -q "$MAIN_SCREEN connected" && \
        xrandr | grep -q "$SECOND_SCREEN connected"; then
        xrandr \
            --output "$LAPTOP_SCREEN" --off \
            --output "$MAIN_SCREEN" --primary --mode 2560x1440 --rotate normal \
            --output "$SECOND_SCREEN" --mode 2560x1440 --pos 2560x0 --rotate left \
            || ( \
            sleep 0.1 && xrandr --output "$LAPTOP_SCREEN" --off && \
            sleep 0.1 && xrandr --output "$SECOND_SCREEN" --off && \
            sleep 0.1 && xrandr --output "$MAIN_SCREEN" --primary --auto && \
            sleep 0.1 && xrandr --output "$SECOND_SCREEN" --auto --left-of "$MAIN_SCREEN" --rotate right
        )

    # or the other
    elif true && \
        xrandr | grep -q "$MAIN_SCREEN connected" && \
        xrandr | grep -q "$THIRD_SCREEN connected"; then
        xrandr \
            --output "$LAPTOP_SCREEN" --off \
            --output "$THIRD_SCREEN" --mode 2560x1440 --pos 0x0 --rotate left \
            --output "$MAIN_SCREEN" --primary --mode 2560x1440 --pos 1440x500 --rotate normal \
            || ( \
            sleep 0.1 && xrandr --output "$LAPTOP_SCREEN" --off && \
            sleep 0.1 && xrandr --output "$THIRD_SCREEN" --off && \
            sleep 0.1 && xrandr --output "$MAIN_SCREEN" --primary --auto && \
            sleep 0.1 && xrandr --output "$THIRD_SCREEN" --auto --right-of "$MAIN_SCREEN" --rotate right
        )

    # otherwise (in the office) use the one external screen as primary, and laptop screen as secondary.
    # (here the configuration with $MAIN_SCREEN, $SECOND_SCREEN, $THIRD_SCREEN is irrelevant)
    else
        EXTERNAL_SCREEN="${MAIN_SCREEN:-$(get_external_screen)}"
        LAPTOP_SCREEN="${LAPTOP_SCREEN:-$(get_laptop_screen)}"
        if [[ -n "$EXTERNAL_SCREEN" ]] ; then
            if ! is_screen_enabled "$EXTERNAL_SCREEN"; then
                xrandr \
                    --output "$LAPTOP_SCREEN" --auto \
                    --output "$MAIN_SCREEN" --primary --auto --right-of "$LAPTOP_SCREEN"
            else
                # swap left and right on every invocation, which could be handy
                right_screen=$(get_screen_with_greater_x_position "$LAPTOP_SCREEN" "$EXTERNAL_SCREEN")
                if [[ "$right_screen" = "$EXTERNAL_SCREEN" ]]; then
                    xrandr \
                        --output "$LAPTOP_SCREEN" --auto \
                        --output "$MAIN_SCREEN" --primary --auto --left-of "$LAPTOP_SCREEN"
                else
                    xrandr \
                        --output "$LAPTOP_SCREEN" --auto \
                        --output "$MAIN_SCREEN" --primary --auto --right-of "$LAPTOP_SCREEN"
                fi
            fi
        else
            # if everything else fails, enable laptop/remaining screen
            xrandr --output "$LAPTOP_SCREEN" --auto || \
            xrandr --output "$(get_remaining_screen)" --auto
        fi
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

function fix_resolution() {
    # if resolution is "broken" (lower than native), fix it "manually" like this:
    LAPTOP_SCREEN=${LAPTOP_SCREEN:-$(get_laptop_screen)}
    if xrandr | grep "$LAPTOP_SCREEN connected 960x540" >/dev/null; then
        xrandr --output "$(get_external_screen)" --off
        xrandr --newmode "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
        xrandr --addmode "$LAPTOP_SCREEN" "1920x1080_60.00"
        xrandr --output "$LAPTOP_SCREEN" --mode "1920x1080_60.00"
    fi
}

function main() {

    case $(hostname) in

        falbala )
            LAPTOP_SCREEN='eDP1'
            MAIN_SCREEN='DP1'
            SECOND_SCREEN='HDMI2'
            THIRD_SCREEN='DisplayPort-0'
            ;;

        frey )
            LAPTOP_SCREEN='eDP'
            MAIN_SCREEN='DisplayPort-0'
            SECOND_SCREEN='DisplayPort-1'
            THIRD_SCREEN='HDMI-A-0'
            ;;

        nott )
            LAPTOP_SCREEN='eDP-1'
            MAIN_SCREEN='DP-1'
            SECOND_SCREEN='DP-3'
            THIRD_SCREEN='HDMI-1'
            ;;

        * )
            LAPTOP_SCREEN="$(get_laptop_screen)"
            MAIN_SCREEN="$(get_external_screen)"
            ;;

    esac

    if test -n "$ONLY"; then
        OUTPUT_TO_KEEP="$(get_laptop_screen)"
        disable_all_but_one_output
    else
        arrange_outputs
    fi

}

main
"$DIRNAME/i3-polybar.sh" restart
setup_wallpaper

