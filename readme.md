sflip's Configuration Files
===========================

These are some configuration files ("dotfiles", "rc files", ...). 

I use git to version control and github to sync them. Feel free to have a look!



## File Locations

There is a directory for each application. The directory structure does not necessarily have to represent the structure of the original files. 

These commands create symbolic links at the locations where the applications expect their files (if you cd'ed  into the dotfiles directory):

    ### absolute path to this directory. adjust this!
    DOTFILESDIR='/home/sflip/dotfiles'

    ### cmus
    mkdir -p ~/.cmus
    ln -s $DOTFILESDIR/cmus/rc ~/.mpdconf

    ### dactyl
    ln -s $DOTFILESDIR/dactyl/pentadactyl ~/.pentadactyl
    ln -s $DOTFILESDIR/dactyl/pentadactylrc ~/.pentadactylrc

    ### elinks
    mkdir -p ~/.elinks
    ln -s $DOTFILESDIR/elinks/elinks.conf ~/.elinks/elinks.conf

    ### fish
    mkdir -p ~/.config
    ln -s $DOTFILESDIR/fish ~/.config/fish

    ### ghci
    ln -s $DOTFILESDIR/ghci/ghci ~/.ghci

    ### git
    ln -s $DOTFILESDIR/git/gitconfig ~/.gitconfig

    ### i3
    mkdir -p ~/.i3
    ln -s $DOTFILESDIR/i3/config ~/.i3/config

    ### lesskey
    lesskey $DOTFILESDIR/lesskey/lesskey

    ### luakit
    ln -s $DOTFILESDIR/luakit ~/.config/

    ### mpd
    ln -s $DOTFILESDIR/mpd/mpdconf ~/.mpdconf

    ### muttator
    ln -s $DOTFILESDIR/muttator/muttatorrc ~/.muttatorrc

    ### ranger
    mkdir -p ~/.config/ranger
    ln -s $DOTFILESDIR/ranger/* ~/.config/ranger/
    chmod u+x ~/.config/ranger.scope.sh

    ### sublime text
    mkdir -p ~/.config/sublime-text-3/Packages
    ln -s $DOTFILESDIR/sublime/User ~/.config/sublime-text-3/Packages/User
    ln -s $DOTFILESDIR/sublime/jsbeautifyrc ~/.jsbeautifyrc

    ### tmux
    ln -s $DOTFILESDIR/tmux/tmux.conf ~/.tmux.conf

    ### vim
    ln -s $DOTFILESDIR/vim/vimrc ~/.vimrc

    ### vimpc (mpd client)
    ln -s $DOTFILESDIR/vimpc/vimpcrc ~/.vimpcrc

    ### vimperator
    ln -s $DOTFILESDIR/vimperator/vimperatorrc ~/.vimperatorrc

    ### vimus (mpd client)
    ln -s $DOTFILESDIR/vimus/vimusrc ~/.vimusrc

    ### vlc
    mkdir ~/.config
    ln -s $DOTFILESDIR/vlc ~/.config/vlc

    ### X keyboard layout
    ln -s $DOTFILESDIR/xkb/de_sflip /usr/share/X11/xkb/symbols/de_sflip
    setxkbmap de_sflip

    ### zathura
    mkdir ~/.config/zathura
    ln -s $DOTFILESDIR/zathura/zathurarc ~/.config/zathura/zathurarc


## Contact

Shoot me a mail to soziflip gmail com.
