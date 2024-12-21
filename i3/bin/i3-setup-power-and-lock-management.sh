#!/usr/bin/env fish

function is_at_home
    xrandr | grep -E -q 'DisplayPort-. connected'
end

function setup_power_and_lock_management
    if is_at_home
        echo 'Seems like we\'re at home. Disabling auto suspend!'
        xset dpms 0 0 0 # never suspend
    else
        echo 'Seems like we\'re not at home. Enabling auto suspend and screensaver.'
        xset dpms 595 0 0 # seconds until standby/suspend/off
        xset s noblank # screensaver should not turn off screen
        xset s off # screensaver should be disabled
        nohup xautolock -time 10 -locker 'i3lock -e -t -i ~/.i3/wallpaper.png' -notify 15 -notifier 'notify-send -u critical -t 10000 -- \'Turning off screen in 10 seconds...\'' &
    end
end

setup_power_and_lock_management
