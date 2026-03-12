#!/usr/bin/env bash

# Author: Philipp Moers <soziflip@gmail.com>

# Set up tmux sessions that i always use

set -e

SESSION_MAIN="main"
SESSION_CODE="code"

HOSTNAME=$(hostname)


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

function tmux_new_window_once() {
    local session="$1"
    local window="$2"
    local command_line="$3"
    local directory="${4:-$HOME}"

    if ! tmux has-session -t "$session" 2>/dev/null; then
        echo "tmux new session $session"
        tmux new-session -d -s "$session" -n "delete-me" # can't create a session without window
    fi

    if tmux list-windows -t "$session" -F '#W' | grep -qx "$window"; then
        echo "tmux window $session:$window already exists."
    else
        echo "tmux new window $session:$window"
        tmux new-window -t "$session:" -n "$window" -c "$directory" "$command_line"
        tmux set-window-option -t "$session:$window" automatic-rename off
    fi

    if tmux list-windows -t "$session" -F '#W' | grep -qx "delete-me"; then
        tmux kill-window -t "$session:delete-me"
    fi
}

function open_project_in_vim() {
    local project_path="$1"
    local project_name="$2"
    tmux_new_window_once \
        "$SESSION_CODE" \
        "$project_name" \
        "fish -i -C \"nvim --listen $project_name\"" \
        "$project_path"
}

function open_recent_subdir_projects() {
    local projects_dir="$1"
    local number_of_projects="$2"
    if [[ -d "$projects_dir" ]]; then
        for project in $(get_recent_git_projects "$projects_dir" "$number_of_projects"); do
            open_project_in_vim "$projects_dir/$project" "$project"
        done
    fi
}

# For a given directory, return a list of the most recently updated git projects within it
function get_recent_git_projects() {
    local projects_dir="$1"
    local search_depth=2
    local number_of_projects="$2"
    projects_dir=${projects_dir%/} # remove trailing slash if any

    # get list of git projects and their last commit timestamp
    local projects=()
    while IFS= read -r -d '' child; do
        if [[ -d "$child/.git" ]]; then
            local project_name="${child#"$projects_dir/"}"
            projects+=("$(git -C "$child" log -1 --format=%ct) $project_name")
        fi
    done <  <(find "$projects_dir" -maxdepth "$search_depth" -type d -print0)

    # sort by timestamp
    # shellcheck disable=SC2207
    IFS=$'\n' projects=($(sort --reverse <<<"${projects[*]}"))
    unset IFS

    # get the first $number_of_projects entries and throw away timestamp
    local result=()
    for project in "${projects[@]:0:$number_of_projects}"; do
        result+=("$(echo "$project" | cut -d' ' -f2)")
    done

    echo "${result[@]}"
}

function create_session_main() {
    tmux_new_window_once "$SESSION_MAIN" "top" "bpytop || htop"
    tmux_new_window_once "$SESSION_MAIN" "spotify" "spotify_player"

    # email
    if has_internet_connection && [[ -d "$HOME/.local/share/mail/" ]]; then
        # FIXME: invoke keychain, or is that not necessary anymore?
        # local email_cmd='fish -c "keychain --eval --quiet --timeout 48000 --shell fish ~/.ssh/id_* | source && mail --mode sync --disable-rename-window --disable-tail-logs"'
        local email_cmd="fish -c 'mail --mode sync --disable-rename-window --disable-tail-logs'"
        tmux_new_window_once "$SESSION_MAIN" "mail" "$email_cmd"
    fi

    tmux_new_window_once "$SESSION_MAIN" "tmp" "fish" "$HOME/tmp"
}

function create_session_code() {
    if [[ "$HOSTNAME" = "nott" ]]; then
        open_project_in_vim "$HOME/src-projects/dotfiles" "dotfiles"
        open_project_in_vim "$HOME/src-projects/shellscripts" "shellscripts"
        open_recent_subdir_projects "$HOME/work-projects" 7
    else
        open_recent_subdir_projects "$HOME/src-projects" 5
    fi
}

function set_state()
{

    tmux switch-client -t $SESSION_MAIN
    tmux select-window -t $SESSION_MAIN:2 # (set 'last' window)
    tmux select-window -t $SESSION_MAIN:1 # (set active window)
}

if (tmux has-session -t init 2>/dev/null); then
    tmux kill-session -t init
fi

create_session_main
create_session_code
set_state
