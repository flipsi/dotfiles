#!/bin/bash


setup_wallpaper() {
    if [[ -f "$HOME/.i3/wallpaper" ]]; then
        feh --bg-scale "$HOME/.i3/wallpaper"
    fi
}


case $(hostname) in

    asterix )

        if xrandr | grep -q 'HDMI2 connected'; then

            # on big tv, turn off laptop screen
            if xrandr | grep -q '4096x2160'; then
                xrandr --output HDMI2 --mode 4096x2160 --output eDP1 --off
                setup_wallpaper
            else
                xrandr --output HDMI2 --mode 1920x1080 --pos 0x540 --rotate normal --output HDMI1 --off --output DP1 --off --output eDP1 --mode 960x540 --pos 0x0 --rotate normal --output VIRTUAL1 --off
                setup_wallpaper
            fi

        elif xrandr | grep 'eDP1 connected 960x540' >/dev/null; then

            xrandr --output HDMI2 --off
            xrandr --newmode "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
            xrandr --addmode eDP1 "1920x1080_60.00"
            xrandr --output eDP1 --mode "1920x1080_60.00"
            setup_wallpaper

        fi
        ;;

    dwarf )

        if xrandr | grep 'DP3-1 connected' >/dev/null; then

            xrandr --output VIRTUAL1 --off --output DP3 --off --output eDP1 --primary --mode 1920x1080 --pos 3840x0 --rotate normal --output DP1 --off --output DP2 --off --output HDMI3 --off --output HDMI2 --off --output HDMI1 --off --output DP3-1 --mode 1920x1080 --pos 0x0 --rotate normal --output DP3-3 --off --output DP3-2 --mode 1920x1080 --pos 1920x0 --rotate normal \
                || ( \
                sleep 0.1 && xrandr --output DP3-2 --off && \
                sleep 0.1 && xrandr --output DP3-1 --auto && \
                sleep 0.1 && xrandr --output DP3-2 --auto --right-of DP3-1 && \
                sleep 0.1 && xrandr --output eDP1 --right-of DP3-2 --auto \
                )

            setup_wallpaper

        fi

        ;;

    * )

        echo ERROR: Unknown host!
        exit 1

esac

