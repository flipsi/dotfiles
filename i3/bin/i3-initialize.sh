#!/usr/bin/env fish

# Author: Philipp Moers <soziflip@gmail.com>

# Initial desktop setup with i3 window manager (should be executed after i3 startup).
# We have more power here than in the i3 config file (functions, loops, etc).


function setup_power_management
    switch (hostname)
        case 'dwarf'
            xset dpms 595 0 0 # seconds until standby/suspend/off
            xset s noblank # screensaver should not turn off screen
            xset s off # screensaver should be disabled
            nohup xautolock -time 10 -locker 'i3lock -e -t -i ~/.i3/wallpaper.png' -notify 15 -notifier 'notify-send -u critical -t 10000 -- \'Turning off screen in 10 seconds...\'' &
        case '*'
            xset dpms 14400 0 0 # seconds until standby/suspend/off
    end
end


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


function autostart
    if not pgrep -x vivaldi-stable
        nohup vivaldi-stable &
    end
    if not pgrep -x chromium
        nohup chromium &
    end
    if not pgrep alacritty
        nohup alacritty --command tmux -2 new-session -A -s init &
    end
    if not pgrep spotify
        nohup spotify &
    end
    if not pgrep telegram-desktop
        nohup telegram-desktop &
    end
end


setup_power_management
desktop_session
setup_musicserver
autostart
toggle_redshift


if test -x $HOME/dotfiles/tmux/tmux-initialize-sessions.sh
    $HOME/dotfiles/tmux/tmux-initialize-sessions.sh >> /tmp/tmux-initialize-sessions.log 2>&1
end

