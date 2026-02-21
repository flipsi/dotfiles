#!/usr/bin/env bash

if ! command -v jq &>/dev/null; then
    echo "jq could not be found"
    exit 1
fi

# Goal: move workspace $1 to the currently focused output, move the workspace on the current output
# to the output where $1 was.

# The workspace we want to end up on
dest_ws=$1
# The output where the destination ws resides
output_of_dest_ws=$(i3-msg -t get_workspaces | jq .[] | jq -r 'select(.name == "'$dest_ws'").output')
# The currently focused output
current_output=$(i3-msg -t get_workspaces | jq .[] | jq -r "select(.focused == true).output")
# The workspace on the current output
current_ws=$(i3-msg -t get_workspaces | jq .[] | jq -r "select(.focused == true).name")

# Send away the current workspace
i3-msg move workspace to output $output_of_dest_ws
# Select the destination workspace
i3-msg workspace $dest_ws

# Move the destination workspace to what was the current output in the beginning
i3-msg move workspace to output $current_output

# Re-activate the destination workspace
# sleep 0.2
i3-msg workspace $dest_ws
