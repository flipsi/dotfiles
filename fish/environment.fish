# QUICKFIX FOR LOCALE ISSUE
# set -x LANG de_DE.UTF-8
set -x LANG en_US.UTF-8


function prepend_to_path
    set -l DIR $argv[1]
    if test -n "$DIR" -a -d "$DIR"
        set -x PATH "$DIR" $PATH
    end
end

# prepend_to_path /usr/sbin # breaks node version managers if node present (wrong order of this and their PATH)
prepend_to_path ~/.babashka/bbin/bin
prepend_to_path ~/.cargo/bin
prepend_to_path ~/.npm-global/bin
prepend_to_path ~/.gem/ruby/2.4.0/bin
prepend_to_path ~/.gem/ruby/2.6.0/bin
prepend_to_path ~/.i3/bin
prepend_to_path ~/.local/bin
prepend_to_path ~/.local/share/coursier/bin
prepend_to_path ~/bin
prepend_to_path ~/cifuzz/bin
prepend_to_path ~/go/bin
prepend_to_path ~/shellscripts

# bun
set --export BUN_INSTALL "$HOME/.bun"
prepend_to_path $BUN_INSTALL/bin

# edit files with neovim or vim
if command -v nvim >/dev/null 2>&1
    set -x EDITOR nvim
else
    set -x EDITOR vim
end

# web browser
if ! cat /etc/os-release | grep -q Fedora
    set -x BROWSER vivaldi-stable
end

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


# required for gpg-agent to work properly
set -x GPG_TTY (tty)


# load local environment if present
if test -f $HOME/.config/fish/environment.local.fish
    source $HOME/.config/fish/environment.local.fish
end

