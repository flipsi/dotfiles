# don't show welcome message
set fish_greeting ""


#########################
# environment variables #
#########################

# QUICKFIX FOR LOCALE ISSUE
# set -x LANG de_DE.UTF-8
set -x LANG en_US.UTF-8

# some more stuff in PATH
set -x PATH ~/.local/bin $PATH
set -x PATH ~/.cargo/bin $PATH
set -x PATH ~/.gem/ruby/2.6.0/bin $PATH
set -x PATH ~/.i3/bin $PATH
set -x PATH ~/shellscripts $PATH
set -x PATH ~/bin $PATH

# edit files with vim
set -x EDITOR vim

# web browser
set -x BROWSER vivaldi-stable

# setup fzf to use ag instead of find
set -x FZF_DEFAULT_COMMAND 'ag --hidden --ignore .git -f -g ""'

# use rofi instead of dmenu
set -x CM_LAUNCHER "rofi"

# # music player daemon
# if test $hostname = "asterix"
#     set -x MPD_HOST (ifconfig wlan0 | grep 'inet ' | sed 's/.*addr:\(.*\)  Bcast.*/\1/')
# else
    # set -x MPD_HOST $hostname
    set -x MPD_HOST localhost
# end



####################################
# login and interactive shell only #
####################################

if status --is-interactive; and status --is-login

    # change colors
    fish_my_colors gruvbox

    # modify the terminal's 256 color palette to use the gruvbox theme
    set -l GRUVBOX_SCRIPT ~/.vim/bundle/gruvbox/gruvbox_256palette.sh
    if test -f $GRUVBOX_SCRIPT
        bash $GRUVBOX_SCRIPT
    end

    # change colors of ls
    # eval (dircolors -c LS_COLORS)
    set -x LS_COLORS (bash -c 'eval `dircolors ~/.dircolors`; echo $LS_COLORS')

    # find out host once (useful for multiple things, but saves cycles)
    if test -z $hostname
        set hostname (hostname)
    end

    # keychain takes care of ssh-agent and can also do gpg
    if command -v keychain >/dev/null
        eval (command keychain --eval --quiet ~/.ssh/id_rsa)
    end

    # load abbreviations
    if not set -q __abbr_init
      set -gx __abbr_init
      source $HOME/.config/fish/abbr.fish
      if test -f $HOME/.config/fish/abbr.local.fish
          source $HOME/.config/fish/abbr.local.fish
      end
    end

    # configuration for fish-command-timer
    set -x fish_command_timer_enabled      1
    set -x fish_command_timer_color        $fish_my_color_gray_middle
    set -x fish_command_timer_time_format  '%b %d %I:%M%p'

    # show error exit status after each command
    function postcmd --on-event fish_postexec
        switch $status
            case 0
                true
            case '*'
                set last_status $status
                echo
                set_color --bold $fish_my_color_red
                printf "%"$COLUMNS"s" "[ Exit status: $last_status ] "
                set_color normal
        end
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

    if test $hostname = "dwarf"
        if tmux has-session -t src 2>/dev/null
        else
            tmux-ryte-sessions.sh
        end
    end

end
