#!/usr/bin/env bash

# mutt wrapper
# this script runs offlineimap in the background and starts mutt in the foreground


##########
# CONFIG #
##########

# really do the whole sync thing or just open mutt? ['sync', 'offline', 'ask']
MODE=ask

# how long to wait between syncs (in seconds)
LOOP_SLEEPTIME=900

# whether to do a full or quick sync the first time (afterwards, only quick syncs)
FIRST_TIME_FULL=true

# what to do when quitting: ['sync_full', 'sync_quick', 'nothing', 'ask']
LAST_TIME_ACTION=ask




# commands

MUTT_COMMAND="/usr/bin/mutt"


## FOR DEBUGGING:
# SYNC_COMMAND_FULL="sleep 3; echo normal >> /tmp/offlineimap.log 2>&1"
# SYNC_COMMAND_QUICK="sleep 1; echo quick >> /tmp/offlineimap.log 2>&1"

# ## FOR PRODUCTION:
# SYNC_COMMAND_FULL="offlineimap -o >> /tmp/offlineimap.log 2>&1"
# SYNC_COMMAND_QUICK="offlineimap -o -q >> /tmp/offlineimap.log 2>&1"

## FOR PRODUCTION:
SYNC_COMMAND_FULL="mbsync -V -a >> /tmp/mbsync.log 2>&1"
SYNC_COMMAND_QUICK="mbsync -V -a >> /tmp/mbsync.log 2>&1"


NOTMUCH_COMMAND="notmuch new >> /tmp/notmuch.log 2>&1"







####################
# set window title #
####################

# http://stackoverflow.com/a/1687708/4568748

TITLE="mutt"

echo -e '\033k'$TITLE'\033\\'
# echo -e '\033]2;'$TITLE'\007'



#########################
# what to do what to do #
#########################


case $MODE in
    offline )
        eval $MUTT_COMMAND
        exit $?
        ;;
    ask )
        read -n 1 -p "Sync (default) or use [o]ffline mode? " user_input; echo
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



###############################################################
# unlock gpg encrypted passwords and let the agent do its job #
###############################################################

# THIS IS HANDLED ON DEMAND

# for gpg_file in $HOME/.mutt/credentials/*.gpg; do
    # gpg --quiet --use-agent --for-your-eyes-only --decrypt $gpg_file > /dev/null
    # echo status is $?
# done



################################################
# run offlineimap in a loop while running mutt #
################################################


while true                  # run forever
do
    if [[ $FIRST_TIME_FULL = true ]]; then
        eval $SYNC_COMMAND_FULL
        FIRST_TIME_FULL=false
    else
        eval $SYNC_COMMAND_QUICK
    fi
    sleep $LOOP_SLEEPTIME   # sleep a while before doing that again
done &                      # run loop in background
LOOP_PID=$!                 # copy PID of loop

eval $MUTT_COMMAND          # run mutt in foreground (and wait for mutt to exit)

kill $LOOP_PID              # these two lines are a cool trick to kill the
wait $LOOP_PID 2>/dev/null  # infinite loop and hide the error that it generates



##############################
# run offlineimap at the end #
##############################

# wait for last loop to finish
while pkill --signal 0 offlineimap; do
    sleep 2
done

# sync one last time?
case $LAST_TIME_ACTION in
    sync_full )
        eval $SYNC_COMMAND_FULL
        ;;
    sync_quick )
        eval $SYNC_COMMAND_QUICK
        ;;
    ask )
        while true; do
            read -n 1 -p "Sync? " user_input; echo
            case $user_input in
                [Nn]* ) exit 0;;
                * )     eval $SYNC_COMMAND_FULL; break;;
            esac
        done
        ;;
    * )
        ;;
esac
