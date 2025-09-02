#!/usr/bin/env fish

# Author: Philipp Moers <soziflip@gmail.com>

# Initial desktop setup with i3 window manager (should be executed after i3 startup).
# We have more power here than in the i3 config file (functions, loops, etc).


function start_musicserver_if_music_is_accessible
    set mountpoints /mnt/extern /media/sflip/extern /media/sflip/Extern
    if not nc -z localhost 6600
        for m in $mountpoints
            if mountpoint -q $m
                # if command -v mopidyctl >/dev/null
                    # systemctl start mopidy
                if command -v mopidy >/dev/null
                    # nohup mopidy --option spotify/password=(gpg --for-your-eyes-only --quiet --no-tty -d $HOME/.config/mopidy/spotify.password.gpg) >/tmp/mopidy.log ^&1 &
                    nohup mopidy \
                        --option spotify/password=(pass spotify/soziflip+spotify@gmail.com  | head -n1) \
                        --option spotify/client_secret=(pass spotify/mopidy | head -n1) \
                        >/tmp/mopidy.log 2>&1 &
                else
                    mpd
                end
                return 0
            end
        end
        return 1
    else
        return 0
    end
end


function setup_musicserver
    set try_again_after 0 1 3 5 15
    for t in $try_again_after
        if start_musicserver_if_music_is_accessible
            nohup $HOME/.i3/bin/i3pystatus-mpd-notification.sh >/dev/null &
            return 0
        else
            sleep $t
        end
    end
    return 1
end


# redshift makes it dark after startup at day (major use case), so toggle once
function toggle_redshift
    for t in (seq 60)
        if pgrep -x redshift >/dev/null
           pkill -USR1 '^redshift$'
        else
            sleep 1
        end
    end
end


function desktop_session

    # daemon for theme settings and shit
    if command -v gnome-session >/dev/null
        if not pgrep -x gnome-session; nohup gnome-session &; end
    else if command -v xfsettingsd >/dev/null
        xfsettingsd --replace --sm-client-disable
    else if command -v cinnamon-settings-daemon >/dev/null
        if not pgrep -x cinnamon-settings-daemon; nohup cinnamon-settings-daemon &; end
    end

    # power manager takes care of lid closing, standby, display brightness etc.
    if command -v xfce4-power-manager >/dev/null
        if not pgrep -x xfce4-power-manager; nohup xfce4-power-manager &; end
    end

    # start the gnome network manager, because it automatically connects to eduroam etc.
    # and kill it after a few seconds when it is not needed anymore
    #timelimit -t 30 -T 35 nm-applet

end

function initialize-tmux-sessions
    if test -x $HOME/dotfiles/tmux/tmux-initialize-sessions.sh
        $HOME/dotfiles/tmux/tmux-initialize-sessions.sh >> /tmp/tmux-initialize-sessions.log 2>&1
    end
end

# to autostart applications, use dex

initialize-tmux-sessions
desktop_session
setup_musicserver
toggle_redshift
