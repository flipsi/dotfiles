# don't show welcome message
set fish_greeting ""

# find out host once (useful for multiple things, but saves cycles)
set hostname (hostname)


set PATH ~/bin $PATH
set PATH ~/shellscripts $PATH


# edit files with vim
set -x EDITOR vim

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
