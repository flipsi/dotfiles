#!/bin/bash

if [[ -z "$1" ]]; then
    echo 'ERROR: Please enter window matching expression'
    exit 1
fi

if [[ -z "$2" ]]; then
    echo 'ERROR: Please enter timeout in seconds'
    exit 1
fi

echo Killing "$1" in "$2" seconds >> /tmp/i3-kill-window-soon.log
sleep "$2"
i3-msg "$1" kill
