# don't show welcome message
set fish_greeting ""



# only do this stuff when login shell...
if status --is-login

    # change colors of ls
    # eval (dircolors -c LS_COLORS)
    set -x LS_COLORS (bash -c 'eval `dircolors ~/.dircolors`; echo $LS_COLORS')


    # QUICKFIX FOR LOCALE ISSUE
    set -x LANG de_DE.UTF-8

    # find out host once (useful for multiple things, but saves cycles)
    set hostname (hostname)

    # some more stuff in PATH
    set -x PATH ~/.cargo/bin $PATH
    set -x PATH ~/.gem/ruby/2.4.0/bin $PATH
    set -x PATH ~/bin $PATH
    set -x PATH ~/shellscripts $PATH

    # edit files with vim
    set -x EDITOR vim

    # web browser
    set -x BROWSER firefox

    # setup fzf to use ag instead of find
    set -x FZF_DEFAULT_COMMAND 'ag --hidden --ignore .git -f -g ""'

    # # music player daemon
    # if test $hostname = "asterix"
    #     set -x MPD_HOST (ifconfig wlan0 | grep 'inet ' | sed 's/.*addr:\(.*\)  Bcast.*/\1/')
    # else
        # set -x MPD_HOST $hostname
        set -x MPD_HOST localhost
    # end


    # keychain takes care of ssh-agent and can also do gpg
    if command -v keychain >/dev/null
        eval (command keychain --eval --quiet ~/.ssh/id_rsa)
    end

    # abbreviations
    if not set -q __abbr_init
      set -gx __abbr_init
      source $HOME/.config/fish/abbr.fish
      if test -f $HOME/.config/fish/abbr.local.fish
          source $HOME/.config/fish/abbr.local.fish
      end
    end

    # configuration for fish-command-timer
    set fish_command_timer_enabled      1
    set fish_command_timer_color        '#005F5F'
    set fish_command_timer_time_format  '%b %d %I:%M%p'

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
