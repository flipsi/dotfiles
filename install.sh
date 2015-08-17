#!/bin/bash

# Author: Philipp Moers <soziflip@gmail.com>


function print_help_msg() {
    cat <<-EOF
Create symbolic links to these files where applications want them.

Usage: install.sh [OPTIONS] TARGET

    OPTIONS:
    -h | --help             print this help message
    -i | --interactive      if file(s) exist(s), ask what to do
    -f | --force            if file(s) exist(s), overwrite it/them

    TARGET := { all | cmus | dactyl | elinks | fish | ghci | git | i3 | 
                lesskey | luakit | mpd | muttator | pentadactyl | ranger | 
                sublime-text-3 | telegram-cli | tmux | turses | vim | vimpc | 
                vimperator | vimus | vlc | xkb | xmonad | zathura }
EOF
}


function create_link_for_target() {
    local TARGET="$1"
    case "$TARGET" in

        cmus)
            mkdir -p $HOME/.cmus
            create_link $PWD/cmus/rc $HOME/.cmus/rc
            ;;

        elinks)
            mkdir -p $HOME/.elinks
            create_link $PWD/elinks/elinks.conf $HOME/.elinks/elinks.conf
            ;;

        fish)
            mkdir -p $HOME/.config
            create_link $PWD/fish $HOME/.config/fish
            ;;

        ghci)
            create_link $PWD/ghci/ghci $HOME/.ghci
            ;;

        git)
            create_link $PWD/git/gitconfig $HOME/.gitconfig
            ;;

        i3)
            mkdir -p $HOME/.i3
            create_link $PWD/i3/config $HOME/.i3/config
            # create_link $PWD/i3/i3status $HOME/.i3/i3status
            create_link $PWD/i3/i3pystatus $HOME/.i3/i3pystatus
            ;;

        lesskey)
            lesskey $PWD/lesskey/lesskey
            ;;

        luakit)
            create_link $PWD/luakit $HOME/.config/
            ;;

        mpd)
            create_link $PWD/mpd/mpdconf $HOME/.mpdconf
            ;;

        muttator)
            create_link $PWD/muttator/muttatorrc $HOME/.muttatorrc
            ;;

        pentadactyl)
            create_link $PWD/dactyl/pentadactyl $HOME/.pentadactyl
            create_link $PWD/dactyl/pentadactylrc $HOME/.pentadactylrc
            ;;

        ranger)
            mkdir -p $HOME/.config/ranger
            create_link $PWD/ranger/* $HOME/.config/ranger/
            chmod u+x $HOME/.config/ranger/scope.sh
            ;;

        sublime-text-3)
            mkdir -p $HOME/.config/sublime-text-3/Packages
            create_link $PWD/sublime/User $HOME/.config/sublime-text-3/Packages/User
            create_link $PWD/sublime/jsbeautifyrc $HOME/.jsbeautifyrc
            ;;

        telegram-cli)
            mkdir -p $HOME/.telegram-cli
            create_link $PWD/telegram-cli/config $HOME/.telegram-cli/config
            ;;

        tmux)
            create_link $PWD/tmux/tmux.conf $HOME/.tmux.conf
            ;;

        turses)
            mkdir -p $HOME/.turses
            create_link $PWD/turses/config $HOME/.turses/config
            ;;

        vim)
            create_link $PWD/vim/vimrc $HOME/.vimrc
            ;;

        vimpc)
            create_link $PWD/vimpc/vimpcrc $HOME/.vimpcrc
            ;;

        vimperator)
            create_link $PWD/vimperator/vimperatorrc $HOME/.vimperatorrc
            ;;

        vimus)
            create_link $PWD/vimus/vimusrc $HOME/.vimusrc
            ;;

        vlc)
            mkdir -p $HOME/.config
            create_link $PWD/vlc $HOME/.config/vlc
            ;;

        xkb)
            create_link $PWD/xkb/de_sflip /usr/share/X11/xkb/symbols/de_sflip
            setxkbmap de_sflip
            ;;

        xmonad)
            mkdir -p $HOME/.xmonad
            create_link $PWD/xmonad/xmonad.hs $HOME/.xmonad/xmonad.sh
            ;;

        zathura)
            mkdir -p $HOME/.config/zathura
            create_link $PWD/zathura/zathurarc $HOME/.config/zathura/zathurarc
            ;;

        *)
            echo "Unknown target: $1"
            echo "Type './install --help' for a list of valid targets."
            ;;
    esac
}


function create_link() {
    local DESTPATH="$1"
    local LINKPATH="$2"

    if [[ $FORCE = true ]]; then
        ln -sf $DESTPATH $LINKPATH

    elif [[ $INTERACTIVE = true ]]; then
        ln -si $DESTPATH $LINKPATH

    else
        ln -s $DESTPATH $LINKPATH

    fi
}



# check if script is executed in this very dotfiles directory
# (otherwise the creating of links won't work!)
if [[ $0 != "./install.sh" ]]; then
    echo "Please change into the directory containing this script to execute it!"
    exit 1
fi


# get arguments
INTERACTIVE=false
FORCE=false
TEMP=`getopt -o hif --long help,interactive,force -n 'test.sh' -- "$@"`
eval set -- "$TEMP"
while true ; do
    case "$1" in
        -h|--help) print_help_msg; exit 0 ;;
        -i|--interactive) INTERACTIVE=true; shift ;;
        -f|--force) FORCE=true ; shift ;;
        --) shift ; break ;;
        *) echo "Internal error!" ; exit 1 ;;
    esac
done


# test options
# note that both are not allowed simultaneously!
if [ $INTERACTIVE = true ] && [ $FORCE = true ]; then
    echo "You can not use interactive and force mode together!"
    # print_help_msg
    exit 1
fi


# we currently only handle one target
if [[ $# -eq 0 ]]; then
    print_help_msg
    exit 0
elif [[ $# -gt 1 ]]; then
    echo "Please specify exactly one target! It can be 'all'."
    exit 1
else
    if [[ $1 = dactyl ]]; then
        create_link_for_target pentadactyl
    elif [[ $1 = all ]]; then
        create_link_for_target cmus
        create_link_for_target elinks
        create_link_for_target fish
        create_link_for_target ghci
        create_link_for_target git
        create_link_for_target i3
        create_link_for_target lesskey
        create_link_for_target luakit
        create_link_for_target mpd
        create_link_for_target muttator
        create_link_for_target pentadactyl
        create_link_for_target ranger
        create_link_for_target sublime-text-3
        create_link_for_target telegram-cli
        create_link_for_target tmux
        create_link_for_target turses
        create_link_for_target vim
        create_link_for_target vimpc
        create_link_for_target vimperator
        create_link_for_target vimus
        create_link_for_target vlc
        create_link_for_target xkb
        create_link_for_target xmonad
        create_link_for_target zathura
    else
        create_link_for_target $1
    fi
    exit 0
fi



