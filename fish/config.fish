# don't show welcome message
set fish_greeting ""


# environment variables
set PATH /opt/ghc-7.8.2/bin $PATH
set PATH /opt/ghc-7.6.3/bin $PATH
set PATH /opt/haskell-platform-2013.2.0.0/bin/ $PATH
set PATH /home/flip/.cabal/bin $PATH
set PATH /opt/cc0/bin $PATH

set -x LESSOPEN "| /usr/share/source-highlight/src-hilite-lesspipe.sh %s"
set -x LESS=" -R "
