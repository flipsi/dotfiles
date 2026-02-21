#!/usr/bin/env bash

if ! command -v jq &>/dev/null; then
    exit 1
fi

arg=$1

function workspace_exists
{
    i3-msg -t get_workspaces | jq -e --arg ws "$arg" '.[] | select(.name==$ws)' >/dev/null
}

function get_focused_output
{
    i3-msg -t get_workspaces | jq -r '.[] | select(.focused).output'
}

function get_visible_workspace_on_focused_output
{
    i3-msg -t get_workspaces | jq -r '.[] | select(.visible and .focused).name'
}

current_output=$(get_focused_output)

current_ws=$(get_visible_workspace_on_focused_output)

if workspace_exists; then

    dest_ws=$arg

    i3-msg workspace "$dest_ws" >/dev/null

    dest_output=$(get_focused_output)

    i3-msg focus output "$current_output" >/dev/null

else

    i3-msg focus output "$arg" >/dev/null 2>&1 || exit 0

    dest_output=$(get_focused_output)

    dest_ws=$(get_visible_workspace_on_focused_output)

    i3-msg focus output "$current_output" >/dev/null

fi

if [ "$dest_ws" = "$current_ws" ]; then
    exit 0
fi

i3-msg move workspace to output "$dest_output" >/dev/null

i3-msg workspace "$dest_ws" >/dev/null

i3-msg move workspace to output "$current_output" >/dev/null

i3-msg workspace "$dest_ws" >/dev/null
