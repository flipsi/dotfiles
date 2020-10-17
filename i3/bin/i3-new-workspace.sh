#!/usr/bin/env bash

set -e

JSON=$(i3-msg -t get_workspaces)

MAX_WORKSPACE=$(echo "$JSON" | tr , '\n' | grep '"num":' | cut -d : -f 2 | sort -rn | head -1)

if [[ "$MAX_WORKSPACE" -eq -1 ]]; then
    NEW_WORKSPACE=1 # start with 1 instead of 0
else
    NEW_WORKSPACE=$((MAX_WORKSPACE + 1))
fi


function create_new_workspace() {
    i3-msg workspace "$NEW_WORKSPACE"
}

function move_container_to_new_workspace() {
    i3-msg move container to workspace "$NEW_WORKSPACE"
}

case "$1" in
    -m|--move-container)    move_container_to_new_workspace ;;
    *)                      create_new_workspace ;;
esac
