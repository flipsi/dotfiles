#!/bin/bash


# notify i3pystatus when a song changes, so that it doesn't need to check on its
# own every few seconds


# time interval in seconds to check again when there is no mpd
SLEEP_NO_MPD=100

if test -z $MPD_HOST; then
    MPD_HOST=localhost
fi
if test -z $MPD_PORT; then
    MPD_PORT=6600
fi

while true; do
    if nc -z $MPD_HOST $MPD_PORT; then
        pkill -USR1 -x -f '^python.? /home/.*/\.i3/i3pystatus$'
        mpc --host $MPD_HOST --port $MPD_PORT current --wait
    else
        sleep $SLEEP_NO_MPD
    fi
done

