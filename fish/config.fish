# don't show welcome message
set fish_greeting ""


#########################
# environment variables #
#########################

source $HOME/.config/fish/environment.fish


#########################
# default applications  #
#########################

function set_xdg_default_app
    set -l MIME_TYPE $argv[1]
    set -l APP $argv[2]
    set -l CURRENT_APP (xdg-mime query default "$MIME_TYPE")
    if test -z "$CURRENT_APP" -o "$CURRENT_APP" != "$APP"
        xdg-mime default "$APP" "$MIME_TYPE"
    end
end

function set_xdg_default_apps
    if command -v xdg-mime >/dev/null
        set_xdg_default_app 'application/pdf'           'org.pwmt.zathura.desktop'
        set_xdg_default_app 'image/jpeg'                'sxiv.desktop'
        set_xdg_default_app 'image/png'                 'sxiv.desktop'
        set_xdg_default_app 'x-scheme-handler/http'     'vivaldi-stable.desktop'
        set_xdg_default_app 'x-scheme-handler/https'    'vivaldi-stable.desktop'
    end
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



#############################################################

function set_hostname
    # find out host once (useful for multiple things, but saves cycles)
    if test -z $hostname
        set hostname (hostname)
    end
end


function set_color_theme

    # change colors
    fish_my_colors gruvbox

    # change colors for virtual console
    set_tty_colors gruvbox

    # modify the terminal's 256 color palette to use the gruvbox theme
    set -l GRUVBOX_SCRIPT ~/.vim/bundle/gruvbox/gruvbox_256palette.sh
    if test -f $GRUVBOX_SCRIPT
        bash $GRUVBOX_SCRIPT
    end

    # change colors of ls
    # eval (dircolors -c LS_COLORS)
    if test -f ~/.dircolors
        set -x LS_COLORS (bash -c 'eval `dircolors ~/.dircolors`; echo $LS_COLORS')
    end

end

# show error exit status after each command
function setup_exit_status_printing
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
end

function autostart_keychain_on_some_hosts
    # keychain takes care of ssh-agent and gpg-agent
    function keychain_start
        eval (command keychain --eval --quiet ~/.ssh/id_*)
    end
    if command -v keychain >/dev/null
        set -l host_where_to_start_keychain_automatically 'falbala' 'mimir' 'frey'
        if contains $hostname $host_where_to_start_keychain_automatically
            keychain_start
        end
    end
end

function in_X
    set -q DISPLAY
end

#############################################################

if status --is-login
    set_xdg_default_apps
    set_hostname
end


if status --is-interactive

    # load abbreviations
    source $HOME/.config/fish/abbr.fish
    if test -f $HOME/.config/fish/abbr.local.fish
        source $HOME/.config/fish/abbr.local.fish
    end

end

if status --is-interactive; and status --is-login

    # aliases (also see abbr file)
    if command -v hub >/dev/null
        alias git hub
    end

    # asdf version manager
    if test -f ~/.asdf/asdf.fish
        source ~/.asdf/asdf.fish
    end

    set_color_theme

    # configuration for fish-command-timer
    set -x fish_command_timer_enabled      1
    set -x fish_command_timer_color        $fish_my_color_gray_middle
    set -x fish_command_timer_time_format  '%b %d %I:%M%p'

    setup_exit_status_printing

    # correct typos the fun way
    # https://github.com/nvbn/thefuck
    # if command -v thefuck >/dev/null
        # eval (thefuck --alias) # (does not work, so i added the function manually)
    # end

    if in_X
        autostart_keychain_on_some_hosts
    end

end

