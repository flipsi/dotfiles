#!/usr/bin/env bash

# Author: Philipp Moers <soziflip@gmail.com>

# Set up a tmux session for a git project
# (or change to it, if it already exists)




function print_help_msg() {

    cat <<-EOF
Set up a tmux session for a git project (or switch to it, if existing).

Usage: tmux-project-session { NAME | [NAME] PATH }

    NAME := Name of the project.
    PATH := Path to the project. Should be a git project.

    If only NAME is given, a session with this name should already exist.
    If only PATH is given and NAME is ommited, NAME will be guessed from PATH.
EOF
}



function create_project_session() {

    local SESSION_NAME="$1"
    local SESSION_PATH="$2"

    # create the session
    tmux new-session -s ${SESSION_NAME} -c ${SESSION_PATH} -n ${SESSION_NAME} -d

    # (1) fish
    #tmux send-keys -t ${SESSION_NAME} 'pwd' C-m

    # (2) vim
    tmux new-window -t ${SESSION_NAME} -c ${SESSION_PATH} -n vim
    tmux send-keys -t ${SESSION_NAME}:2 'vim --servername VIM' C-m

    # (3) version-control
    tmux new-window  -t ${SESSION_NAME} -c ${SESSION_PATH} -n version-control
    if (command -v tig >/dev/null 2>&1); then
        tmux send-keys -t ${SESSION_NAME}:3 'tig' C-m 's'
    else
        tmux send-keys -t ${SESSION_NAME}:3 'git status' C-m
    fi

    # (4) file-manager
    tmux new-window -t ${SESSION_NAME} -c ${SESSION_PATH} -n file-manager
    if (command -v 'ranger' >/dev/null 2>&1); then
        tmux send-keys -t ${SESSION_NAME}:4 'ranger' C-m
    elif (command -v 'vifm' >/dev/null 2>&1); then
        tmux send-keys -t ${SESSION_NAME}:4 'vifm' C-m
    elif (command -v 'lfm' >/dev/null 2>&1); then
        tmux send-keys -t ${SESSION_NAME}:4 'lfm' C-m
    elif (command -v 'mc' >/dev/null 2>&1); then
        tmux send-keys -t ${SESSION_NAME}:4 'mc' C-m
    else
        tmux send-keys -t ${SESSION_NAME}:4 'ls -la' C-m
    fi

    # (5)(6)(7) some shells for whatever
    tmux new-window -t ${SESSION_NAME} -c ${SESSION_PATH}
    tmux new-window -t ${SESSION_NAME} -c ${SESSION_PATH}
    tmux new-window -t ${SESSION_NAME} -c ${SESSION_PATH}

    # ('last' window)
    tmux select-window -t ${SESSION_NAME}:2
    # (active window)
    tmux select-window -t ${SESSION_NAME}:3

    echo "Session ${SESSION_NAME} created."
}





# GET ARGUMENTS


# no arguments?
if [[ "$#" -eq 0 ]]; then
    print_help_msg
    exit 0

# too many arguments?
elif [[ "$#" -gt 2 ]]; then
    print_help_msg
    exit 1

# name and path given?
elif [[ "$#" -eq 2 ]]; then
    SESSION_NAME="$1"
    SESSION_PATH="$2"

# only one given?
elif [[ "$#" -eq 1 ]]; then

    # HELP
    if [[ "$1" = "-h" ]] || [[ "$1" = "--help" ]]
    then
        print_help_msg
        exit 0
    fi

    # NAME
    if (tmux has-session -t "$1" 2>/dev/null); then
        tmux switch-client -t "$1"
        exit 0

    # PATH
    else
        SESSION_NAME=$(basename "$1")
        SESSION_PATH="$1"
    fi
fi


# is it a git project?
if ! [ -d "$SESSION_PATH/.git" ] ; then
    echo "This seems not to be a git project, sorry. Aborting..."
    exit 1
fi


if ! (tmux has-session -t ${SESSION_NAME} 2>/dev/null); then
    create_project_session $SESSION_NAME $SESSION_PATH
fi
tmux switch-client -t ${SESSION_NAME}



