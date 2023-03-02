#!/usr/bin/env bash

# Author: Philipp Moers <soziflip@gmail.com>

# Set up tmux sessions that i always use

set -e

HOSTNAME=$(hostname)
SESSION_NAME_1="main"
SESSION_NAME_2="src"

HOSTNAME_WORK="mimir"
PROJECTS_DIR="$HOME/work/code-intelligence/src"
NUMBER_OF_PROJECTS=3


function has_internet_connection() {
    if [ -z "$INTERNET_CONNECTION" ]; then
        for SLEEP in {0,1,3,5}; do
            sleep "$SLEEP"
            ping -c 1 8.8.8.8 >/dev/null 2>&1
            INTERNET_CONNECTION=$?
            if [ $INTERNET_CONNECTION -eq 0 ]; then
                return 0
            else
                echo "No internet!!!"
            fi
        done
    fi
    return $INTERNET_CONNECTION
}


# For a given directory, return a list of the most recently updated git projects within it
function get_last_recent_git_projects() {
    PROJECTS_DIR="$1"
    NUMBER_OF_PROJECTS="$2"
    PROJECTS_DIR=${PROJECTS_DIR%/} # remove trailing slash if any

    # get list of git projects and their last commit timestamp
    for CHILD in "$PROJECTS_DIR"/*; do
        if [[ -d "$CHILD/.git" ]]; then
            PROJECTS=("$(git -C "$CHILD" log -1 --format=%ct) $(basename "$CHILD")" "${PROJECTS[@]}")
        fi
    done

    # sort by timestamp
    # shellcheck disable=SC2207
    IFS=$'\n' PROJECTS=($(sort --reverse <<<"${PROJECTS[*]}"))
    unset IFS

    # get the first $NUMBER_OF_PROJECTS entries and throw away timestamp
    for PROJECT in "${PROJECTS[@]:0:$NUMBER_OF_PROJECTS}"; do
        RESULT=("$(echo "$PROJECT" | cut -d' ' -f2) ${RESULT[@]}")
    done

    echo "${RESULT[@]}"
}


function open_project_vim() {
    PROJECT_PATH="$1"
    PROJECT_NAME="$2"
    tmux new-window -t "$SESSION_NAME_2:" -n "$PROJECT_NAME" -c "$PROJECT_PATH" "fish -i -C \"nvim --listen $PROJECT_NAME"\"
}


function create_sessions() {

    if ! (tmux has-session -t $SESSION_NAME_1 2>/dev/null); then

        tmux new-session -d -s $SESSION_NAME_1 -c "$HOME"
        tmux new-window -t $SESSION_NAME_1: -n "top" "bpytop || htop"

        if has_internet_connection; then
            if [[ "$HOSTNAME" = "falbala" ]]; then
                tmux new-window -t $SESSION_NAME_1: -n mail "mail --mode sync --disable-tmux-rename --disable-tail-logs"
            fi
        fi

        tmux new-window -t $SESSION_NAME_1: -n "tmp" "ranger $HOME/tmp"

        tmux select-window -t $SESSION_NAME_1:2 # (set 'last' window)
        tmux select-window -t $SESSION_NAME_1:1 # (set active window)

    fi

    if ! (tmux has-session -t $SESSION_NAME_2 2>/dev/null); then

        tmux new-session -d -s $SESSION_NAME_2 -n "delete-me" # can't create a session without window
        open_project_vim "$HOME/dotfiles" "dotfiles"
        tmux kill-window -t "$SESSION_NAME_2:delete-me"

        if [[ "$HOSTNAME" = "$HOSTNAME_WORK" ]]; then
            for PROJECT in $(get_last_recent_git_projects "$PROJECTS_DIR" "$NUMBER_OF_PROJECTS"); do
                tmux new-window -t $SESSION_NAME_2: -n "$PROJECT" -c \
                    "$PROJECTS_DIR/$PROJECT" "fish -i -C \"nvim --listen $PROJECT"\"
            done
        fi

    fi

}


create_sessions
tmux switch-client -t $SESSION_NAME_1

if (tmux has-session -t init 2>/dev/null); then
    tmux kill-session -t init
fi
