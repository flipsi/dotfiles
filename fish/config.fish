# don't show welcome message
set fish_greeting ""


# environment variables
# set PATH /opt/ghc-7.8.2/bin $PATH
# set PATH /opt/ghc-7.6.3/bin $PATH
# set PATH /opt/haskell-platform-2013.2.0.0/bin/ $PATH
# set PATH /usr/local/haskell/ghc-7.8.3-x86_64/bin/ $PATH
set PATH /opt/cc0/bin $PATH
set PATH ~/.cabal/bin $PATH
set PATH ~/bin $PATH

set -x LESSOPEN "| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
set -x LESS " -c -R "

# if test (hostname) = "asterix"
#     set -x MPD_HOST (ifconfig wlan0 | grep 'inet ' | sed 's/.*addr:\(.*\)  Bcast.*/\1/')
# end
set -x MPD_HOST (hostname)
