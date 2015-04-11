sflip's Configuration Files
===========================

These are some configuration files ("dotfiles", "rc files", ...). 

I use git to version control and github to sync them. Feel free to have a look!



## File Locations

There is a directory for each application. The directory structure does not necessarily have to represent the structure of the original files. 

These commands create symbolic links at the locations where the applications expect their files (if you cd'ed  into the dotfiles directory):

    ### cmus
    mkdir -p ~/.cmus
    ln -s ./cmus/rc ~/.mpdconf

    ### dactyl
    ln -s ./dactyl/pentadactyl ~/.pentadactyl
    ln -s ./dactyl/pentadactylrc ~/.pentadactylrc

    ### elinks
    mkdir -p ~/.elinks
    ln -s ./elinks/elinks.conf ~/.elinks/elinks.conf

    ### fish
    mkdir -p ~/.config
    ln -s ./fish ~/.config/fish

    ### ghci
    ln -s ghci/ghci ~/.ghci

    ### git
    ln -s git/gitconfig ~/.gitconfig

    ### i3
    mkdir -p ~/.i3
    ln -s i3/config ~/.i3/config

    ### lesskey
    lesskey ./lesskey/lesskey

    ### mpd
    ln -s ./mpd/mpdconf ~/.mpdconf

    ### muttator
    ln -s ./muttator/muttatorrc ~/.muttatorrc

    ### ranger
    mkdir -p ~/.config/ranger
    ln -s ./ranger/rc.conf ~/.config/ranger/rc.conf
    ln -s ./ranger/rifle.conf ~/.config/ranger/rifle.conf
    ln -s ./ranger/scope.sh ~/.config/ranger/scope.sh

    ### sublime text
    mkdir -p ~/.config/sublime-text-3/Packages
    ln -s ./sublime/User ~/.config/sublime-text-3/Packages/User
    ln -s ./sublime/jsbeautifyrc ~/.jsbeautifyrc

    ### tmux
    ln -s ./tmux/tmux.conf ~/.tmux.conf

    ### vim
    ln -s ./vim/vimrc ~/.vimrc

    ### vimpc (mpd client)
    ln -s ./vimpc/vimpcrc ~/.vimpcrc

    ### vimperator
    ln -s ./vimperator/vimperatorrc ~/.vimperatorrc

    ### vimus (mpd client)
    ln -s ./vimus/vimusrc ~/.vimusrc

    ### vlc
    mkdir ~/.config
    ln -s ./vlc ~/.config/vlc

    ### X keyboard layout
    ln -s ./xkb/de_sflip /usr/share/X11/xkb/symbols/de_sflip
    setxkbmap de_sflip

    ### zathura
    mkdir ~/.config/zathura
    ln -s ./zathura/zathurarc ~/.config/zathura/zathurarc


## Contact

Shoot me a mail to soziflip gmail com.
