#!/usr/bin/env bash

# Author: Philipp Moers <soziflip@gmail.com>

# Set up tmux sessions that i always use


SESSION_NAME_1="main"
SESSION_NAME_2="src"

PROJECTS_DIR="$HOME/work/ryte/src"
NUMBER_OF_PROJECTS_TO_OPEN=6


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

function create_sessions() {

    if ! (tmux has-session -t $SESSION_NAME_2 2>/dev/null); then

        tmux new-session -d -s $SESSION_NAME_2 -n "dotfiles" -c "$HOME/dotfiles" "nvim --listen dotfiles"

        if [[ -d "$PROJECTS_DIR" ]]; then
            # shellcheck disable=SC2012
            for PROJECT in $(ls -t1 "$PROJECTS_DIR" | head "-n$NUMBER_OF_PROJECTS_TO_OPEN"); do
                tmux new-window -t $SESSION_NAME_2: -n "$PROJECT" -c \
                    "$PROJECTS_DIR/$PROJECT" "fish -i -C \"nvim --listen $PROJECT"\"
            done
        fi

    fi

    if ! (tmux has-session -t $SESSION_NAME_1 2>/dev/null); then

        tmux new-session -d -s $SESSION_NAME_1 -c "$HOME"
        tmux new-window -t $SESSION_NAME_1: -n "top" "bpytop || htop"
        tmux new-window -t $SESSION_NAME_1: -n "tmp" "ranger $HOME/tmp"

        # if has_internet_connection; then
        #     tmux new-window -t $SESSION_NAME_1: -n mail "mail"
        #     tmux new-window -t $SESSION_NAME_1: -n telegram "telegram-cli"
        # fi

        tmux select-window -t $SESSION_NAME_1:2 # (set 'last' window)
        tmux select-window -t $SESSION_NAME_1:1 # (set active window)

    fi

}


create_sessions
# tmux switch-client -t $SESSION_NAME_1
