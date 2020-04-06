# don't show welcome message
set fish_greeting ""


#########################
# environment variables #
#########################

source $HOME/.config/fish/environment.fish


#########################
# default applications  #
#########################

set BROWSER_APP "vivaldi-stable.desktop"
set PDF_VIEWER_APP "org.pwmt.zathura.desktop"
set IMAGE_VIEWER_APP "sxiv.desktop"

if test (xdg-mime query default 'x-scheme-handler/https') != $BROWSER_APP
    echo "Setting default browser to $BROWSER_APP"
    xdg-mime default $BROWSER_APP 'x-scheme-handler/https'
    xdg-mime default $BROWSER_APP 'x-scheme-handler/http'
end

if test (xdg-mime query default 'application/pdf') != $PDF_VIEWER_APP
    echo "Setting default application for 'application/pdf' to $PDF_VIEWER_APP"
    xdg-mime default $PDF_VIEWER_APP 'application/pdf'
end

if test (xdg-mime query default 'image/png') != $IMAGE_VIEWER_APP
    echo "Setting default application for 'image/png' to $IMAGE_VIEWER_APP..."
    xdg-mime default $IMAGE_VIEWER_APP 'image/png'
end

if test (xdg-mime query default 'image/jpeg') != $IMAGE_VIEWER_APP
    echo "Setting default application for 'image/jpeg' to $IMAGE_VIEWER_APP..."
    xdg-mime default $IMAGE_VIEWER_APP 'image/jpeg'
end



#############################################################
# print number of lines of output after executing a command #
#############################################################

# TODO: make this work
# https://unix.stackexchange.com/questions/518068/automatically-print-number-of-lines-of-command-line-output

# function fish_command_line_counter -e fish_preexec
    # commandline -a ' | tee /proc/self/fd/2 | wc -l'
    # commandline -f end-of-line
# end


####################################
# login and interactive shell only #
####################################

if status --is-interactive; and status --is-login

    # aliases (also see abbr file)
    if command -v hub >/dev/null
        alias git hub
    end

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

    # asdf version manager
    if test -f ~/.asdf/asdf.fish
        source ~/.asdf/asdf.fish
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
