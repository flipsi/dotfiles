#!/usr/bin/env bash

# Author: Philipp Moers <soziflip@gmail.com>

# Cycle through tmux sessions, skipping any session that is already open (attached) in another client.

set -e

DIRECTION="next"
CLIENT=""
CURRENT_SESSION=""
POSITIONAL_ARGS=()

# Parse arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -p|--prev|--previous|prev|previous)
            DIRECTION="prev"
            shift
            ;;
        -n|--next|next)
            DIRECTION="next"
            shift
            ;;
        --client=*)
            CLIENT="${1#*=}"
            shift
            ;;
        --session=*)
            CURRENT_SESSION="${1#*=}"
            shift
            ;;
        *)
            POSITIONAL_ARGS+=("$1")
            shift
            ;;
    esac
done

if [[ -z "$CLIENT" && ${#POSITIONAL_ARGS[@]} -ge 1 ]]; then
    CLIENT="${POSITIONAL_ARGS[0]}"
fi

if [[ -z "$CURRENT_SESSION" && ${#POSITIONAL_ARGS[@]} -ge 2 ]]; then
    CURRENT_SESSION="${POSITIONAL_ARGS[1]}"
fi

# If client or session is not provided, query tmux
if [[ -z "$CLIENT" ]]; then
    CLIENT="$(tmux display-message -p '#{client_name}' 2>/dev/null || true)"
fi

if [[ -z "$CURRENT_SESSION" ]]; then
    CURRENT_SESSION="$(tmux display-message -p '#{session_name}' 2>/dev/null || true)"
fi

# Find sessions attached to OTHER clients
declare -A OTHER_ATTACHED

if [[ -n "$CLIENT" ]]; then
    while IFS=$'\t' read -r c_name c_session; do
        [[ -z "$c_name" || -z "$c_session" ]] && continue
        if [[ "$c_name" != "$CLIENT" ]]; then
            OTHER_ATTACHED["$c_session"]=1
        fi
    done < <(tmux list-clients -F "#{client_name}	#{client_session}" 2>/dev/null || true)
else
    while IFS=$'\t' read -r s_name s_attached; do
        [[ -z "$s_name" ]] && continue
        if [[ "$s_attached" -gt 0 && "$s_name" != "$CURRENT_SESSION" ]]; then
            OTHER_ATTACHED["$s_name"]=1
        fi
    done < <(tmux list-sessions -F "#{session_name}	#{session_attached}" 2>/dev/null || true)
fi

# Get list of all sessions
mapfile -t ALL_SESSIONS < <(tmux list-sessions -F "#{session_name}" 2>/dev/null || true)
NUM_SESSIONS=${#ALL_SESSIONS[@]}

if (( NUM_SESSIONS <= 1 )); then
    exit 0
fi

# Find index of current session
CUR_IDX=-1
for i in "${!ALL_SESSIONS[@]}"; do
    if [[ "${ALL_SESSIONS[$i]}" == "$CURRENT_SESSION" ]]; then
        CUR_IDX=$i
        break
    fi
done

if (( CUR_IDX == -1 )); then
    CUR_IDX=0
fi

# Search for the next candidate session in circular order
TARGET_SESSION=""
for (( step = 1; step < NUM_SESSIONS; step++ )); do
    if [[ "$DIRECTION" == "prev" ]]; then
        idx=$(( (CUR_IDX - step + NUM_SESSIONS) % NUM_SESSIONS ))
    else
        idx=$(( (CUR_IDX + step) % NUM_SESSIONS ))
    fi
    candidate="${ALL_SESSIONS[$idx]}"
    if [[ -z "${OTHER_ATTACHED[$candidate]}" ]]; then
        TARGET_SESSION="$candidate"
        break
    fi
done

# Switch to the target session if found
if [[ -n "$TARGET_SESSION" ]]; then
    if [[ -n "$CLIENT" ]]; then
        tmux switch-client -c "$CLIENT" -t "$TARGET_SESSION"
    else
        tmux switch-client -t "$TARGET_SESSION"
    fi
fi
