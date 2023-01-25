# QUICKFIX FOR LOCALE ISSUE
# set -x LANG de_DE.UTF-8
set -x LANG en_US.UTF-8


function prepend_to_path
    set -l DIR $argv[1]
    if test -n "$DIR" -a -d "$DIR"
        set -x PATH "$DIR" $PATH
    end
end

prepend_to_path ~/.babashka/bbin/bin
prepend_to_path ~/.local/share/coursier/bin
prepend_to_path ~/.local/bin
prepend_to_path ~/.cargo/bin
prepend_to_path ~/cifuzz/bin
prepend_to_path ~/.gem/ruby/2.4.0/bin
prepend_to_path ~/.gem/ruby/2.6.0/bin
prepend_to_path ~/.i3/bin
prepend_to_path ~/shellscripts
prepend_to_path ~/bin


# edit files with neovim or vim
if command -v nvim >/dev/null 2>&1
    set -x EDITOR nvim
else
    set -x EDITOR vim
end

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



# load local environment if present
if test -f $HOME/.config/fish/environment.local.fish
    source $HOME/.config/fish/environment.local.fish
end

