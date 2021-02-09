#!/usr/bin/env bash

set -e

function print_help_msg() {
    cat <<-EOF
Mail utility.
This script basically runs mbsync in the background and starts (neo-)mutt in the foreground.

Usage: $(basename "$0") [OPTIONS]

    OPTIONS:

    -m|--mode <mode>
        One of ['sync', 'offline', 'ask].
        In 'sync' mode, mbsync is started in the background.
        In 'offline' mode, mbsync is not started, only mutt (using local mailbox).
        In 'ask' mode, one can choose between those two interactively.
        OPTIONAL. Defaults to 'ask'.

    -R|--disable-rename-window
        By default, the script renames the tmux window.
        With this option, this does not happen.

    -L|--disable-tail-logs
        By default, the script opens mbsync logs in a new tmux pane.
        With this option, this does not happen.

EOF
}

DEFAULT_MODE=ask
LAST_TIME_ACTION=ask # when not in offline mode, what to do when quitting: ['sync', 'ask', 'nope']
LOOP_SLEEPTIME=900 # how long to wait between syncs (in seconds)

MUTT_COMMAND="/usr/bin/neomutt"
SYNC_APP="mbsync"
SYNC_LOGFILE="/tmp/mbsync.log"
SYNC_COMMAND="mbsync -a --verbose >> $SYNC_LOGFILE 2>&1"

TMUX_TITLE="mail"


function parse_arguments() {
    while [[ $# -ge 1 ]]; do
        case "$1" in
            -m|--mode)
                MODE="$2"
                shift
                ;;
            -R|--disable-rename-window)
                DISABLE_RENAME_WINDOW=true
                ;;
            -L|--disable-tail-logs)
                DISABLE_TAIL_LOGS=true
                ;;
            -h|--help)
                print_help_msg
                exit
                ;;
            *)
                ;;
        esac
        shift
    done
    if [[ -z "$MODE" ]]; then
        MODE="$DEFAULT_MODE"
    fi
}


function start_mail_util() {
    case $MODE in
        ask )
            read -r -n 1 -p "Sync [enter] or use [o]ffline mode or [q]uit? " user_input; echo
            case $user_input in
                q )
                    exit 0
                    ;;
                o )
                    eval $MUTT_COMMAND
                    ;;
                * )
                    start_mail_util_with_sync
                    ;;
            esac
            ;;
        offline )
            eval $MUTT_COMMAND
            ;;
    esac
}


function start_mail_util_with_sync() {
    # run sync command in the background in a loop
    while true
    do
        eval "$SYNC_COMMAND"
        sleep $LOOP_SLEEPTIME
    done &
    LOOP_PID=$!
    tail_logs

    # run mutt in foreground (and wait for mutt to exit)
    eval $MUTT_COMMAND

    # finalize after mutt exited
    kill $LOOP_PID || true
    wait $LOOP_PID 2>/dev/null || true
    final_sync
    close_logs
}


function final_sync() {
    # wait for last loop to finish
    while pkill --signal 0 "$SYNC_APP"; do
        sleep 2
    done

    # sync one last time?
    if [[ "$MODE" != "offline" ]]; then
        case $LAST_TIME_ACTION in
            sync )
                eval "$SYNC_COMMAND"
                ;;
            ask )
                while true; do
                    read -r -n 1 -p "Sync? " user_input; echo
                    case $user_input in
                        [Nn]* ) return 0;;
                        * )     eval "$SYNC_COMMAND"; break;;
                    esac
                done
                ;;
            * )
                ;;
        esac
    fi
}


function tail_logs() {
    if [[ -z "$DISABLE_TAIL_LOGS" && -n $TMUX ]]; then
        tmux split-window -v -l 10 -d "tail -F $SYNC_LOGFILE"
    fi
}

function close_logs() {
    if [[ -z "$DISABLE_TAIL_LOGS" && -n $TMUX ]]; then
        tmux kill-pane -t 2
    fi
}

function rename_window() {
    if [[ -z "$DISABLE_RENAME_WINDOW" && -n $TMUX ]]; then
        ORIGINAL_TITLE=$(tmux display-message -p '#W')
        tmux rename-window "$TMUX_TITLE"
    fi
}

function undo_rename_window() {
    if [[ -z "$DISABLE_RENAME_WINDOW" && -n "$TMUX" ]]; then
        tmux rename-window "$ORIGINAL_TITLE"
    fi
}


parse_arguments "$@"
rename_window
start_mail_util
undo_rename_window
