# don't show welcome message
set fish_greeting ""



# only do this stuff when login shell...
if status --is-login

    # QUICKFIX FOR LOCALE ISSUE
    set -x LANG de_DE.UTF-8

    # find out host once (useful for multiple things, but saves cycles)
    set hostname (hostname)

    # some more stuff in PATH
    set -x PATH ~/bin $PATH
    set -x PATH ~/shellscripts $PATH

    # edit files with vim
    set -x EDITOR vim

    # web browser
    set -x BROWSER firefox

    # setup fzf to use ag instead of find
    set -x FZF_DEFAULT_COMMAND 'ag -g ""'

    # music player daemon
    # if test $hostname = "asterix"
    #     set -x MPD_HOST (ifconfig wlan0 | grep 'inet ' | sed 's/.*addr:\(.*\)  Bcast.*/\1/')
    # end
    set -x MPD_HOST $hostname


    # keychain takes care of ssh-agent and can also do gpg
    if test $hostname = "asterix" -o $hostname = "obelix"
        eval (command keychain --eval --quiet ~/.ssh/id_rsa)
    end


    # correct typos the fun way
    # https://github.com/nvbn/thefuck
    # (the following does not work, so i added the function manually)
    #eval (thefuck --alias)


    # on some hosts, start desktop if not already running
    if test $hostname = "obelix"
        if not set -q DISPLAY
            if not pgrep -x xinit >/dev/null
                startx
            end
        end
    end

end
