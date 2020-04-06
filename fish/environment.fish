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



# load local environment if present
if test -f $HOME/.config/fish/environment.local.fish
  source $HOME/.config/fish/environment.local.fish
end

