#!/usr/bin/env bash

# Author: Philipp Moers <soziflip@gmail.com>

# Set up tmux sessions that i always use

set -e

HOSTNAME=$(hostname)
SESSION_NAME_MAIN="main"
SESSION_NAME_CODE="code"


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
    return "$INTERNET_CONNECTION"
}

# For a given directory, return a list of the most recently updated git projects within it
function get_last_recent_git_projects() {
    PROJECTS_DIR="$1"
    SEARCH_DEPTH=2
    NUMBER_OF_PROJECTS="$2"
    PROJECTS_DIR=${PROJECTS_DIR%/} # remove trailing slash if any

    # get list of git projects and their last commit timestamp
    while IFS= read -r -d '' CHILD; do
        if [[ -d "$CHILD/.git" ]]; then
            PROJECT_NAME="${CHILD#"$PROJECTS_DIR/"}"
            PROJECTS=("$(git -C "$CHILD" log -1 --format=%ct) $PROJECT_NAME" "${PROJECTS[@]}")
        fi
    done <  <(find "$PROJECTS_DIR" -maxdepth "$SEARCH_DEPTH" -type d -print0)

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

function open_project_in_vim() {
    PROJECT_PATH="$1"
    PROJECT_NAME="$2"
    tmux new-window -t "$SESSION_NAME_CODE:" -n "$PROJECT_NAME" -c "$PROJECT_PATH" \
        "fish -i -C \"nvim --listen $PROJECT_NAME"\"
}

function create_session_main() {
    if ! (tmux has-session -t $SESSION_NAME_MAIN 2>/dev/null); then

        tmux new-session -d -s $SESSION_NAME_MAIN -n "delete-me" # can't create a session without window
        tmux new-window -t $SESSION_NAME_MAIN: -n "top" "bpytop || htop"
        tmux kill-window -t "$SESSION_NAME_MAIN:delete-me"

        if has_internet_connection; then
            if [[ -d $HOME/.local/share/mail/ ]]; then
                tmux new-window -t $SESSION_NAME_MAIN: -n mail "mail --mode sync --disable-tmux-rename --disable-tail-logs"
            fi
        fi
    fi
}

function create_session_code() {
    if ! (tmux has-session -t $SESSION_NAME_CODE 2>/dev/null); then

        tmux new-session -d -s $SESSION_NAME_CODE -n "delete-me" # can't create a session without window
        open_project_in_vim "$HOME/src-projects/dotfiles" "dotfiles"
        open_project_in_vim "$HOME/src-projects/shellscripts" "shellscripts"
        tmux kill-window -t "$SESSION_NAME_CODE:delete-me"

        PROJECTS_DIR="$HOME/work-projects"
        NUMBER_OF_PROJECTS=8

        if [[ -d "$PROJECTS_DIR" ]]; then
            for PROJECT in $(get_last_recent_git_projects "$PROJECTS_DIR" "$NUMBER_OF_PROJECTS"); do
                echo "$PROJECT"
                open_project_in_vim "$PROJECTS_DIR/$PROJECT" "$PROJECT"
            done
        fi
    fi
}

function set_state()
{

    tmux switch-client -t $SESSION_NAME_MAIN
    tmux select-window -t $SESSION_NAME_MAIN:2 # (set 'last' window)
    tmux select-window -t $SESSION_NAME_MAIN:1 # (set active window)
}

if (tmux has-session -t init 2>/dev/null); then
    tmux kill-session -t init
fi

create_session_main
create_session_code
set_state
