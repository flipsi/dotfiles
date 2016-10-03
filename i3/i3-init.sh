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
                    if test -f ~/.i3/wallpaper
                        feh --bg-scale ~/.i3/wallpaper
                    end
                    break
                end
            end
            break
        end
    end
end


function start_mpd_if_music_is_accessible
    set mountpoints /mnt/extern /media/sflip/extern /media/sflip/Extern
    pgrep -x mpd >/dev/null
    if test $status -gt 0
        for m in $mountpoints
            if mountpoint -q /mnt/extern
                mpd
                return 0
            end
        end
        return 1
    else
        return 0
    end
end


function setup_mpd
    set try_again_after 0 1 3 5 15
    for t in $try_again_after
        if start_mpd_if_music_is_accessible
            return 0
        else
            sleep $t
        end
    end
    return 1
end



setup_screen_resolution
setup_screen_layout
setup_mpd

