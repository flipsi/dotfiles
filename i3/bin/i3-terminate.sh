#!/usr/bin/env fish

# Author: Philipp Moers <soziflip@gmail.com>

# Terminate my i3 session gently.

# optional arg: <action> which is one of
# ['poweroff', 'reboot', ...] or any i3exit action
# default action is 'poweroff'


if set -q argv[1]
    set action $argv[1]
end


# shutdown to poweroff
function poweroff
    notify-send 'Now Poweroff!'
    sleep 1
    sudo poweroff
end


# terminate some applications gently
function terminate_apps
    set apps firefox palemoon thunderbird vim
    for app in $apps
        if pgrep -x $app > /dev/null
            notify-send "Asking $app to terminate..."
            pkill -2 -x $app
            sleep 1
        end
        if pgrep -x $app > /dev/null
            notify-send "Pressing $app to terminate..."
            pkill -15 -x $app
            sleep 5
        end
        if pgrep -x $app > /dev/null
            notify-send "Forcing $app to terminate..."
            pkill -9 -x $app
        end
    end
end



# block until the currently played song ends
function sleep_music
    # check mpd
    if nc -z localhost 6600
        if test (mpc | wc -l) -gt 1
            notify-send "Waiting for music to end..."
            mpc single on > /dev/null
            mpc current --wait > /dev/null
        end
    end
    if pgrep -x cmus > /dev/null
        notify-send "Waiting for music to end..."
        # TODO: implement
    end
    if pgrep -x spotify > /dev/null
        notify-send "Waiting for music to end..."
        # TODO: implement (not gonna happen)
    end
    # check other players (these should kill themselves after playback)
    set mediaplayers mplayer vlc
    for player in $mediaplayers
        if pgrep -x $player > /dev/null
            notify-send "Waiting for playback to end..."
            while pgrep -x $player > /dev/null
                sleep 1
            end
        end
    end
end




notify-send 'Terminating...'

sleep_music
terminate_apps

# to hopefully have nice wallpaper at next boot
random-wallpaper.sh

if set -q action
    i3exit $action
else
    systemctl poweroff
end

