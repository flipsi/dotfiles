#!/usr/bin/env fish

# Author: Philipp Moers <soziflip@gmail.com>

# Initial desktop setup with i3 window manager (should be executed after i3 startup).
# We have more power here than in the i3 config file (functions, loops, etc).


function new_screen_resolution
    set screen $argv[1]
    set h_resolution $argv[2]
    set v_resolution $argv[3]
    set modeline (cvt $h_resolution $v_resolution | grep Modeline)
    set modeline (echo $modeline | sed 's/Modeline //' | sed 's/\s\+/ /g')
    set modeline (string split ' ' $modeline)
    set modename $modeline[1]
    xrandr --newmode $modeline
    and xrandr --addmode $screen $modename
    xrandr --output $screen --mode $modename
end


function setup_screen_resolution
    if test (hostname) = 'asterix'
        if not xrandr | grep "eDP1 connected 1920x1080" >/dev/null
            new_screen_resolution eDP1 1920 1080
        end
    end
end


function setup_screen_layout
    set primary_screens LVDS0 LVDS1 LVDS-0 LVDS-1 eDP1
    set secondary_screens VGA0 VGA1 VGA-0 VGA-1 HDMI1 HDMI2 HDMI-1 HDMI-2
    for secondary_screen in $secondary_screens
        if xrandr | grep "$secondary_screen connected" >/dev/null
            for primary_screen in $primary_screens
                if xrandr | grep "$primary_screen connected" >/dev/null
                    xrandr --output $secondary_screen --auto --below $primary_screen --auto
                    i3-msg restart
                    if test -f $HOME/.i3/wallpaper
                        feh --bg-scale $HOME/.i3/wallpaper
                    end
                    break
                end
            end
            break
        end
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
                        >/tmp/mopidy.log ^&1 &
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
            nohup $HOME/.i3/i3pystatus-mpd-notification.sh >/dev/null &
            return 0
        else
            sleep $t
        end
    end
    return 1
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
    # if not pgrep -x urxvt; nohup urxvt -e tmux -2 new-session -A -s main &; end
    if not pgrep -x firefox; nohup firefox &; end
end



setup_screen_resolution
setup_screen_layout
desktop_session
setup_musicserver
# tmux-system-sessions
autostart


