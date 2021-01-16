#!/usr/bin/env bash

# mutt/neomutt wrapper

# this script runs mbsync in the background and starts mutt in the foreground


##########
# CONFIG #
##########

# really do the whole sync thing or just open mutt? ['sync', 'offline', 'ask']
MODE=ask

# how long to wait between syncs (in seconds)
LOOP_SLEEPTIME=900

# what to do when quitting: ['sync', 'nothing', 'ask']
LAST_TIME_ACTION=ask

# whether to open sync logs in new tmux pane or not
TAIL_SYNC_LOGS=true



MUTT_COMMAND="/usr/bin/neomutt"

SYNC_APP="mbsync"
SYNC_LOGFILE="/tmp/mbsync.log"
SYNC_COMMAND="mbsync -a --verbose >> $SYNC_LOGFILE 2>&1"





####################
# set window title #
####################

# http://stackoverflow.com/a/1687708/4568748

TITLE="mutt"

if [[ -n $TMUX ]]; then
    ORIGINAL_TITLE=$(tmux display-message -p '#W')
    tmux rename-window "$TITLE"
else
    echo -e '\033k'$TITLE'\033\\'
    # echo -e '\033]2;'$TITLE'\007'
fi



#########################
# what to do what to do #
#########################


case $MODE in
    offline )
        eval $MUTT_COMMAND
        exit $?
        ;;
    ask )
        read -r -n 1 -p "Sync (default) or use [o]ffline mode? " user_input; echo
        case $user_input in
            q )
                exit 0
                ;;
            [Oo]* )
                eval $MUTT_COMMAND
                exit $?
                ;;
        esac
        ;;
esac



#####################################
# sync in a loop while running mutt #
#####################################


# open logs
if [[ -n $TMUX ]]; then
    if [[ $TAIL_SYNC_LOGS = "true" ]]; then
        tmux split-window -v -l 10 -d "tail -F $SYNC_LOGFILE"
    fi
fi

while true                  # run forever
do
    eval "$SYNC_COMMAND"
    sleep $LOOP_SLEEPTIME   # sleep a while before doing that again
done &                      # run loop in background
LOOP_PID=$!                 # copy PID of loop

eval $MUTT_COMMAND          # run mutt in foreground (and wait for mutt to exit)

kill $LOOP_PID              # these two lines are a cool trick to kill the
wait $LOOP_PID 2>/dev/null  # infinite loop and hide the error that it generates



###################
# sync at the end #
###################

# wait for last loop to finish
while pkill --signal 0 "$SYNC_APP"; do
    sleep 2
done

# sync one last time?
case $LAST_TIME_ACTION in
    sync )
        eval "$SYNC_COMMAND"
        ;;
    ask )
        while true; do
            read -r -n 1 -p "Sync? " user_input; echo
            case $user_input in
                [Nn]* ) exit 0;;
                * )     eval "$SYNC_COMMAND"; break;;
            esac
        done
        ;;
    * )
        ;;
esac

if [[ -n $TMUX ]]; then
    # close logs
    if [[ $TAIL_SYNC_LOGS = "true" ]]; then
        tmux kill-pane -t 2
    fi
    # restore window title
    tmux rename-window "$ORIGINAL_TITLE"
fi

