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

    TARGET := { all | bash | cmus | dactyl | elinks | fish | ghci | git | i3 |
                konsole | lesskey | luakit | mopidy |mpd | mplayer | mutt |
                muttator | ncmpcpp | pentadactyl | ranger | sublime-text-3 |
                telegram-desktop | telegram-cli | tig | tmux | turses |
                urlview | vim | vimpc | vimperator | vimus | vlc | xfce4 | xkb |
                xmonad | zathura }
EOF
}


function create_link_for_target() {
    local TARGET="$1"
    TARGET=`echo $TARGET | sed 's#/$##'`
    case "$TARGET" in

        bash)
            local sourcestring="source $PWD/bash/bashrc_sflip"
            grep "$sourcestring" $HOME/.bashrc > /dev/null || echo "$sourcestring" >> $HOME/.bashrc
            ;;

        cmus)
            mkdir -p $HOME/.cmus
            create_link $PWD/cmus/rc $HOME/.cmus/rc
            create_link $PWD/cmus/sflea.theme $HOME/.cmus/sflea.theme
            ;;

        elinks)
            mkdir -p $HOME/.elinks
            create_link $PWD/elinks/elinks.conf $HOME/.elinks/elinks.conf
            ;;

        fish)
            mkdir -p $HOME/.config/fish
            create_link $PWD/fish/functions $HOME/.config/fish/functions
            create_link $PWD/fish/config.fish $HOME/.config/fish/config.fish
            ;;

        ghci)
            create_link $PWD/ghci/ghci $HOME/.ghci
            ;;

        git)
            create_link $PWD/git/gitconfig $HOME/.gitconfig
            create_link $PWD/git/gitignore $HOME/.gitignore
            ;;

        i3)
            mkdir -p $HOME/.i3
            create_link $PWD/i3/config $HOME/.i3/config
            # create_link $PWD/i3/i3status $HOME/.i3/i3status
            create_link $PWD/i3/i3pystatus $HOME/.i3/i3pystatus
            create_link $PWD/i3/i3pystatus-mpd-notification.sh $HOME/.i3/i3pystatus-mpd-notification.sh
            mkdir -p $HOME/bin
            create_link $PWD/i3/i3-initialize.sh $HOME/bin/i3-initialize.sh
            create_link $PWD/i3/i3-terminate.sh $HOME/bin/i3-terminate.sh
            ;;

        konsole)
            mkdir -p $HOME/.config
            mkdir -p $HOME/.local/share/konsole
            create_link $PWD/konsole/konsolerc $HOME/.config/konsolerc
            create_link $PWD/konsole/NicNacPower.profile $HOME/.local/share/konsole/NicNacPower.profile
            create_link $PWD/konsole/Tango-like.colorscheme $HOME/.local/share/konsole/Tango-like.colorscheme
            ;;

        lesskey)
            lesskey $PWD/lesskey/lesskey
            ;;

        luakit)
            create_link $PWD/luakit $HOME/.config/
            ;;

        mopidy)
            # USER:
            create_link /mnt/extern/data/music $HOME/.music
            mkdir -p $HOME/.config/mopidy
            create_link $PWD/mopidy/mopidy.conf $HOME/.config/mopidy/mopidy.conf
            mopidy local scan
            # SERVICE:
            # create_link /mnt/extern/data/music /var/lib/mopidy/media
            # mkdir -p /etc/mopidy
            # create_link $PWD/mopidy/mopidy.conf /etc/mopidy/mopidy.conf
            # mopidyctl local scan
            ;;

        mpd)
            create_link /mnt/extern/data/music $HOME/.mpd/music
            create_link $PWD/mpd/mpdconf $HOME/.mpdconf
            ;;

        mplayer)
            mkdir -p $HOME/.mplayer
            create_link $PWD/mplayer/config $HOME/.mplayer/config
            create_link $PWD/mplayer/input.conf $HOME/.mplayer/input.conf
            ;;

        mutt)
            create_link $PWD/mutt/muttrc $HOME/.muttrc
            ;;

        muttator)
            create_link $PWD/muttator/muttatorrc $HOME/.muttatorrc
            ;;

        ncmpcpp)
            mkdir -p $HOME/.ncmpcpp
            create_link $PWD/ncmpcpp/config $HOME/.ncmpcpp/config
            create_link $PWD/ncmpcpp/bindings $HOME/.ncmpcpp/bindings
            ;;

        pentadactyl)
            create_link $PWD/dactyl/pentadactyl $HOME/.pentadactyl
            create_link $PWD/dactyl/pentadactylrc $HOME/.pentadactylrc
            ;;

        ranger)
            mkdir -p $HOME/.config/ranger
            create_link $PWD/ranger/commands.py $HOME/.config/ranger/commands.py
            create_link $PWD/ranger/rc.conf $HOME/.config/ranger/rc.conf
            create_link $PWD/ranger/rifle.conf $HOME/.config/ranger/rifle.conf
            create_link $PWD/ranger/scope.sh $HOME/.config/ranger/scope.sh
            chmod u+x $HOME/.config/ranger/scope.sh
            create_link $PWD/ranger/colorschemes $HOME/.config/ranger/colorschemes
            ;;

        sublime-text-3)
            mkdir -p $HOME/.config/sublime-text-3/Packages
            create_link $PWD/sublime/User $HOME/.config/sublime-text-3/Packages/User
            create_link $PWD/sublime/jsbeautifyrc $HOME/.jsbeautifyrc
            ;;

        telegram-desktop)
            mkdir -p $HOME/.TelegramDesktop/tdata
            mkdir -p $HOME/.local/share/TelegramDesktop/tdata
            create_link $PWD/telegram-desktop/shortcuts-custom.json $HOME/.local/share/TelegramDesktop/tdata/shortcuts-custom.json
            create_link $PWD/telegram-desktop/shortcuts-custom.json $HOME/.TelegramDesktop/tdata/shortcuts-custom.json
            ;;

        telegram-cli)
            mkdir -p $HOME/.telegram-cli
            create_link $PWD/telegram-cli/config $HOME/.telegram-cli/config
            ;;

        tig)
            create_link $PWD/tig/tigrc $HOME/.tigrc
            ;;

        tmux)
            create_link $PWD/tmux/tmux.conf $HOME/.tmux.conf
            mkdir -p $HOME/bin
            create_link $PWD/tmux/tmux-project-session.sh $HOME/bin/tmux-project-session
            mkdir -p $HOME/.tmux/plugins
            if test ! -d $HOME/.tmux/plugins/tpm; then
                git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm
                # tmux command "run-shell '~/.tmux/plugins/tpm/bindings/install_plugins'"
            fi
            ;;

        turses)
            mkdir -p $HOME/.turses
            create_link $PWD/turses/config $HOME/.turses/config
            ;;

        urlview)
            create_link $PWD/urlview/urlview $HOME/.urlview
            mkdir -p $HOME/bin
            create_link $PWD/urlview/url_handler.sh $HOME/bin/url_handler.sh
            ;;

        vim)
            create_link $PWD/vim/vimrc $HOME/.vimrc
            create_link $PWD/vim/gvimrc $HOME/.gvimrc
            mkdir -p $HOME/.vim
            mkdir -p $HOME/.vim/undodir
            create_link $PWD/vim/vim/sflipsnippets $HOME/.vim/sflipsnippets
            create_link $PWD/vim/vim/spell $HOME/.vim/spell
            create_link $PWD/vim/vim/spellfile.utf-8.add $HOME/.vim/spellfile.utf-8.add
            create_link $PWD/vim/vim/syntax $HOME/.vim/syntax
            create_link $PWD/vim/vim/filetype.vim $HOME/.vim/filetype.vim
            if test ! -d $HOME/.vim/bundle/vundle; then
                git clone https://github.com/gmarik/vundle.git $HOME/.vim/bundle/vundle
                vim -c "exec ':PluginInstall' | qall"
            fi
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

        xfce4)
            mkdir -p $HOME/.config/xfce4
            mkdir -p $HOME/.config/xfce4/terminal
            create_link $PWD/xfce4/xfconf $HOME/.config/xfce4/xfconf
            create_link $PWD/xfce4/terminal $HOME/.config/xfce4/terminal
            create_link $PWD/xfce4/xfce4-screenshooter $HOME/.config/xfce4/xfce4-screenshooter
            ;;

        xkb)
            create_link $PWD/xkb/symbols/de_sflip /usr/share/X11/xkb/symbols/de_sflip
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
        ln -nsf $DESTPATH $LINKPATH

    elif [[ $INTERACTIVE = true ]]; then
        ln -nsi $DESTPATH $LINKPATH

    else
        ln -ns $DESTPATH $LINKPATH

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
        create_link_for_target bash
        create_link_for_target cmus
        create_link_for_target elinks
        create_link_for_target fish
        create_link_for_target ghci
        create_link_for_target git
        create_link_for_target i3
        create_link_for_target lesskey
        create_link_for_target luakit
        create_link_for_target mpd
        create_link_for_target mplayer
        create_link_for_target mutt
        create_link_for_target muttator
        create_link_for_target pentadactyl
        create_link_for_target ranger
        create_link_for_target sublime-text-3
        create_link_for_target telegram-cli
        create_link_for_target tig
        create_link_for_target tmux
        create_link_for_target turses
        create_link_for_target urlview
        create_link_for_target vim
        create_link_for_target vimpc
        create_link_for_target vimperator
        create_link_for_target vimus
        create_link_for_target vlc
        create_link_for_target xfce4
        create_link_for_target xkb
        create_link_for_target xmonad
        create_link_for_target zathura
    else
        create_link_for_target $1
    fi
    exit 0
fi



