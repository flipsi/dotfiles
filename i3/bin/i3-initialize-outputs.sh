#!/bin/bash

case $(hostname) in

    asterix )

        if xrandr | grep 'HDMI2 connected' >/dev/null; then

            xrandr --output HDMI2 --mode 1920x1080 --pos 0x540 --rotate normal --output HDMI1 --off --output DP1 --off --output eDP1 --mode 960x540 --pos 0x0 --rotate normal --output VIRTUAL1 --off

        elif xrandr | grep 'eDP1 connected 960x540' >/dev/null; then

            xrandr --output HDMI2 --off
            xrandr --newmode "1920x1080_60.00"  173.00  1920 2048 2248 2576  1080 1083 1088 1120 -hsync +vsync
            xrandr --addmode eDP1 "1920x1080_60.00"
            xrandr --output eDP1 --mode "1920x1080_60.00"

        fi
        ;;

    dwarf )

        # TODO add xrandr config

        ;;

    * )

        echo ERROR: Unknown host!
        exit 1

esac

