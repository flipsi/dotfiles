#!/usr/bin/env bash

# Author: Philipp Moers <soziflip@gmail.com>

# Set up tmux sessions that i always use


SESSION_NAME_1="main"
SESSION_NAME_2="top"


function check_internet_connection() {
    if [ -z "$INTERNET_CONNECTION" ]; then
        for try in {0,1,3,5}; do
            sleep $try
            ping -c 1 google.com >/dev/null 2>&1
            INTERNET_CONNECTION=$?
            if [ $INTERNET_CONNECTION -eq 0 ]; then
                return 0
            else
                echo 'no internet!!!'
            fi
        done
    fi
    return $INTERNET_CONNECTION
}


function check_home() {
    for try in {0,1,3,5}; do
        sleep $try
        xrandr --query | grep 'HDMI2 connected' >/dev/null 2>&1 && mountpoint /mnt/extern >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            return 0
        fi
    done
    return 1
}


function create_system_sessions() {

    if ! (tmux has-session -t ${SESSION_NAME_1} 2>/dev/null); then

        tmux new-session -d -s ${SESSION_NAME_1} -c "${HOME}"
        tmux new-window -t ${SESSION_NAME_1}:2 -n dotfiles -c "${HOME}/dotfiles" "vim --servername dotfiles"
        tmux new-window -t ${SESSION_NAME_1}:3 -n file-manager "ranger ${HOME}/tmp"


        if check_internet_connection; then

            tmux new-window -t ${SESSION_NAME_1}:4 "mutt"
            tmux new-window -t ${SESSION_NAME_1}:5 -n telegram "telegram-cli"
            tmux send-keys -t ${SESSION_NAME_1}:5 "contact_list" C-m "dialog_list" C-m "chat_with_peer "

            # additional session for second monitor
            if check_home; then
                if ! (tmux has-session -t ${SESSION_NAME_2} 2>/dev/null); then
                    tmux new-session -d -s ${SESSION_NAME_2} -n htop "htop"
                    tmux move-window -s ${SESSION_NAME_1}:5 -t ${SESSION_NAME_2}
                    tmux new-window -t ${SESSION_NAME_2} -n ncmpcpp "bash -c 'sleep 5; nc -z localhost 6600 && ncmpcpp'"
                fi
            fi
        fi

        # ('last' window)
        tmux select-window -t ${SESSION_NAME_1}:2
        # (active window)
        tmux select-window -t ${SESSION_NAME_1}:1

    fi
}




create_system_sessions
# tmux switch-client -t ${SESSION_NAME_1}
