#!/bin/bash

# Author: Philipp Moers <soziflip@gmail.com>


function print_help_msg() {
    cat <<-EOF
sflip's dotfiles - installation script
This script installs my configuration by placing symbolic links and optionally
installing corresponding system packages.

Usage: install.sh [OPTIONS] TARGET...

    OPTIONS:
    -h | --help             Don't do anything, just print this help message.
    -l | --list-targets     Don't do anything, just list supported targets.
    -a | --all              Install everything. TARGET will be ignored.
    -i | --interactive      If configuration exists, ask what to do.
    -f | --force            If configuration exists, overwrite it.
    -u | --uninstall        Remove configuration.
    -p | --package-install  Also (un-)install the corresponding system packages.

EOF
}


SUPPORTED_TARGETS=(\
    bash \
    cmus \
    elinks \
    fish \
    ghci \
    git \
    i3 \
    konsole \
    lesskey \
    luakit \
    mopidy \
    mpd \
    mplayer \
    mutt \
    muttator \
    ncmpcpp \
    pentadactyl \
    ranger \
    sublime-text-3 \
    taskwarrior \
    telegram-cli \
    telegram-desktop \
    tig \
    tmux \
    turses \
    urlview \
    vim \
    vimpc \
    vimperator \
    vimus \
    vlc \
    xfce4 \
    xkb \
    xmonad \
    zathura \
)

ADDITIONAL_PACKAGE_TARGETS=(\
    atool \
    fzf \
    pydf \
    rar \
    ripgrep \
    silver_searcher \
)


function print_supported_targets() {
    for target in ${SUPPORTED_TARGETS[*]}; do
        printf "%s\n" "$target"
    done
}


function create_link() {
    local DESTPATH="$1"
    local LINKPATH="$2"

    if [[ $UNINSTALL != true ]]; then
        # INSTALL
        if [[ $FORCE = true ]]; then
            ln -nsf "$DESTPATH" "$LINKPATH"
        elif [[ $INTERACTIVE = true ]]; then
            ln -nsi "$DESTPATH" "$LINKPATH"
        else
            ln -ns "$DESTPATH" "$LINKPATH"
        fi

    else
        # UNINSTALL
        if [[ -h "$LINKPATH" ]]; then
            if [[ $INTERACTIVE = true ]]; then
                rm -i "$LINKPATH"
            else
                rm "$LINKPATH"
            fi
            # also remove containing dir if empty
            local dir_containing_link
            dir_containing_link=$(dirname "$LINKPATH")
            if [[ "$dir_containing_link" != "$HOME" ]]; then
                rmdir --ignore-fail-on-non-empty "$dir_containing_link"
            fi
        fi

    fi
}


function create_link_for_target() {
    local TARGET="$1"
    case "$TARGET" in

        bash )
            local sourcestring="source $PWD/bash/bashrc_sflip"
            if [[ $UNINSTALL != true ]]; then
                grep "$sourcestring" "$HOME/.bashrc" > /dev/null || echo "$sourcestring" >> "$HOME/.bashrc"
            else
                sed -i -- "/^${sourcestring//\//\\/}$/d" "$HOME/.bashrc"
            fi
            ;;

        cmus )
            mkdir -p "$HOME/.cmus"
            create_link "$PWD/cmus/rc" "$HOME/.cmus/rc"
            create_link "$PWD/cmus/sflea.theme" "$HOME/.cmus/sflea.theme"
            ;;

        elinks )
            mkdir -p "$HOME/.elinks"
            create_link "$PWD/elinks/elinks.conf" "$HOME/.elinks/elinks.conf"
            ;;

        fish )
            mkdir -p "$HOME/.config/fish"
            create_link "$PWD/fish/functions" "$HOME/.config/fish/functions"
            create_link "$PWD/fish/config.fish" "$HOME/.config/fish/config.fish"
            ;;

        ghci )
            create_link "$PWD/ghci/ghci" "$HOME/.ghci"
            ;;

        git )
            create_link "$PWD/git/gitconfig" "$HOME/.gitconfig"
            create_link "$PWD/git/gitignore" "$HOME/.gitignore"
            ;;

        i3 )
            mkdir -p "$HOME/.i3"
            create_link "$PWD/i3/config" "$HOME/.i3/config"
            # create_link "$PWD/i3/i3status" "$HOME/.i3/i3status"
            create_link "$PWD/i3/i3pystatus" "$HOME/.i3/i3pystatus"
            create_link "$PWD/i3/i3pystatus-mpd-notification.sh" "$HOME/.i3/i3pystatus-mpd-notification.sh"
            mkdir -p "$HOME/bin"
            create_link "$PWD/i3/i3-initialize.sh" "$HOME/bin/i3-initialize.sh"
            create_link "$PWD/i3/i3-terminate.sh" "$HOME/bin/i3-terminate.sh"
            ;;

        konsole )
            mkdir -p "$HOME/.config"
            mkdir -p "$HOME/.local/share/konsole"
            create_link "$PWD/konsole/konsolerc" "$HOME/.config/konsolerc"
            create_link "$PWD/konsole/NicNacPower.profile" "$HOME/.local/share/konsole/NicNacPower.profile"
            create_link "$PWD/konsole/Tango-like.colorscheme" "$HOME/.local/share/konsole/Tango-like.colorscheme"
            ;;

        lesskey )
            lesskey "$PWD/lesskey/lesskey"
            ;;

        luakit )
            create_link "$PWD/luakit" "$HOME/.config/"
            ;;

        mopidy )
            # USER:
            create_link "/mnt/extern/data/music" "$HOME/.music"
            mkdir -p "$HOME/.config/mopidy"
            create_link "$PWD/mopidy/mopidy.conf" "$HOME/.config/mopidy/mopidy.conf"
            # SERVICE:
            # create_link /mnt/extern/data/music /var/lib/mopidy/media
            # mkdir -p /etc/mopidy
            # create_link $PWD/mopidy/mopidy.conf /etc/mopidy/mopidy.conf
            ;;

        mpd )
            create_link /mnt/extern/data/music "$HOME/.mpd/music"
            create_link "$PWD/mpd/mpdconf" "$HOME/.mpdconf"
            ;;

        mplayer )
            mkdir -p "$HOME/.mplayer"
            create_link "$PWD/mplayer/config" "$HOME/.mplayer/config"
            create_link "$PWD/mplayer/input.conf" "$HOME/.mplayer/input.conf"
            ;;

        mutt )
            mkdir -p "$HOME/.mutt"
            mkdir -p "$HOME/.mutt/mail"
            mkdir -p "$HOME/.mutt/cache"
            mkdir -p "$HOME/.mutt/credentials"
            create_link "$PWD/mutt/muttrc" "$HOME/mutt/muttrc"
            create_link "$PWD/mutt/accounts" "$HOME/.mutt/accounts"
            create_link "$PWD/mutt/keybindings" "$HOME/.mutt/keybindings"
            create_link "$PWD/mutt/colors" "$HOME/.mutt/colors"
            create_link "$PWD/mutt/mailcap" "$HOME/.mutt/mailcap"
            create_link "$PWD/mutt/signature" "$HOME/.mutt/signature"
            create_link "$PWD/mutt/offlineimaprc" "$HOME/.offlineimaprc"
            create_link "$PWD/mutt/offlineimapcredentials.py" "$HOME/.mutt/offlineimapcredentials.py"
            create_link "$PWD/mutt/msmtprc" "$HOME/.msmtprc"
            create_link "$PWD/mutt/notmuch-config" "$HOME/.notmuch-config"
            create_link "$PWD/mutt/proofread.zsh" "$HOME/.mutt/proofread.zsh"
            ;;

        muttator )
            create_link "$PWD/muttator/muttatorrc" "$HOME/.muttatorrc"
            ;;

        ncmpcpp )
            mkdir -p "$HOME/.ncmpcpp"
            create_link "$PWD/ncmpcpp/config" "$HOME/.ncmpcpp/config"
            create_link "$PWD/ncmpcpp/bindings" "$HOME/.ncmpcpp/bindings"
            ;;

        pentadactyl )
            create_link "$PWD/pentadactyl/pentadactyl" "$HOME/.pentadactyl"
            create_link "$PWD/pentadactyl/pentadactylrc" "$HOME/.pentadactylrc"
            ;;

        ranger )
            mkdir -p "$HOME/.config/ranger"
            create_link "$PWD/ranger/commands.py" "$HOME/.config/ranger/commands.py"
            create_link "$PWD/ranger/rc.conf" "$HOME/.config/ranger/rc.conf"
            create_link "$PWD/ranger/rifle.conf" "$HOME/.config/ranger/rifle.conf"
            create_link "$PWD/ranger/scope.sh" "$HOME/.config/ranger/scope.sh"
            chmod u+x "$HOME/.config/ranger/scope.sh"
            create_link "$PWD/ranger/colorschemes" "$HOME/.config/ranger/colorschemes"
            ;;

        sublime-text-3 )
            mkdir -p "$HOME/.config/sublime-text-3/Packages"
            create_link "$PWD/sublime/User" "$HOME/.config/sublime-text-3/Packages/User"
            create_link "$PWD/sublime/jsbeautifyrc" "$HOME/.jsbeautifyrc"
            ;;

        taskwarrior )
            create_link "$PWD/taskwarrior/taskrc" "$HOME/.taskrc"
            ;;

        telegram-desktop )
            mkdir -p "$HOME/.TelegramDesktop/tdata"
            mkdir -p "$HOME/.local/share/TelegramDesktop/tdata"
            create_link "$PWD/telegram-desktop/shortcuts-custom.json" "$HOME/.local/share/TelegramDesktop/tdata/shortcuts-custom.json"
            create_link "$PWD/telegram-desktop/shortcuts-custom.json" "$HOME/.TelegramDesktop/tdata/shortcuts-custom.json"
            ;;

        telegram-cli )
            mkdir -p "$HOME/.telegram-cli"
            create_link "$PWD/telegram-cli/config" "$HOME/.telegram-cli/config"
            ;;

        tig )
            create_link "$PWD/tig/tigrc" "$HOME/.tigrc"
            ;;

        tmux )
            create_link "$PWD/tmux/tmux.conf" "$HOME/.tmux.conf"
            mkdir -p "$HOME/bin"
            create_link "$PWD/tmux/tmux-project-session.sh" "$HOME/bin/tmux-project-session"
            ;;

        turses )
            mkdir -p "$HOME/.turses"
            create_link "$PWD/turses/config" "$HOME/.turses/config"
            ;;

        urlview )
            create_link "$PWD/urlview/urlview" "$HOME/.urlview"
            mkdir -p "$HOME/bin"
            create_link "$PWD/urlview/url_handler.sh" "$HOME/bin/url_handler.sh"
            ;;

        vim )
            create_link "$PWD/vim/vimrc" "$HOME/.vimrc"
            create_link "$PWD/vim/gvimrc" "$HOME/.gvimrc"
            mkdir -p "$HOME/.vim"
            mkdir -p "$HOME/.vim/undodir"
            create_link "$PWD/vim/vim/sflipsnippets" "$HOME/.vim/sflipsnippets"
            create_link "$PWD/vim/vim/spell" "$HOME/.vim/spell"
            create_link "$PWD/vim/vim/spellfile.utf-8.add" "$HOME/.vim/spellfile.utf-8.add"
            create_link "$PWD/vim/vim/syntax" "$HOME/.vim/syntax"
            create_link "$PWD/vim/vim/filetype.vim" "$HOME/.vim/filetype.vim"
            ;;

        vimpc )
            create_link "$PWD/vimpc/vimpcrc" "$HOME/.vimpcrc"
            ;;

        vimperator )
            create_link "$PWD/vimperator/vimperatorrc" "$HOME/.vimperatorrc"
            ;;

        vimus )
            create_link "$PWD/vimus/vimusrc" "$HOME/.vimusrc"
            ;;

        vlc )
            mkdir -p "$HOME/.config"
            create_link "$PWD/vlc" "$HOME/.config/vlc"
            ;;

        xfce4 )
            mkdir -p "$HOME/.config/xfce4"
            mkdir -p "$HOME/.config/xfce4/terminal"
            create_link "$PWD/xfce4/xfconf" "$HOME/.config/xfce4/xfconf"
            create_link "$PWD/xfce4/terminal" "$HOME/.config/xfce4/terminal"
            create_link "$PWD/xfce4/xfce4-screenshooter" "$HOME/.config/xfce4/xfce4-screenshooter"
            ;;

        xkb )
            create_link "$PWD/xkb/symbols/de_sflip" "/usr/share/X11/xkb/symbols/de_sflip"
            setxkbmap de_sflip
            ;;

        xmonad )
            mkdir -p "$HOME/.xmonad"
            create_link "$PWD/xmonad/xmonad.hs" "$HOME/.xmonad/xmonad.hs"
            ;;

        zathura )
            mkdir -p "$HOME/.config/zathura"
            create_link "$PWD/zathura/zathurarc" "$HOME/.config/zathura/zathurarc"
            ;;

        * )
            echo "Unknown target: $1"
            echo "Use --list-targets' for a list of valid targets."
            ;;
    esac
}


function package_install_target() {
    if [[ $PACKAGE != true ]]; then
        return 0
    fi

    local TARGET="$1"
    local PLATFORM
    if command -v pacman >/dev/null 2>&1; then
        PLATFORM=arch # PLATFORM: Arch Linux / Manjaro Linux
    elif command -v apt >/dev/null 2>&1; then
        PLATFORM=ubuntu # PLATFORM: Ubuntu Linux / Linux Mint / Debian
    elif [[ "$(uname -s)" = Darwin ]]; then
        PLATFORM=osx # PLATFORM: Mac OSX
    fi


    local LIST_OF_SYSTEM_PACKAGES
    case "$TARGET" in

        i3 )
            LIST_OF_SYSTEM_PACKAGES="i3-wm i3exit i3status i3lock dmenu quickswitch-i3 rofi compton unclutter syndaemon numlockx"
            ;;

        mutt )
            LIST_OF_SYSTEM_PACKAGES="mutt msmtp offlineimap notmuch notmuch-mutt goobook"
            ;;

        taskwarrior )
            LIST_OF_SYSTEM_PACKAGES="task"
            ;;

        vim )
            if [[ "$PLATFORM" = arch ]]; then
                LIST_OF_SYSTEM_PACKAGES="gvim"
            elif [[ "$PLATFORM" = ubuntu ]]; then
                LIST_OF_SYSTEM_PACKAGES="vim-gtk"
            elif [[ "$PLATFORM" = osx ]]; then
                LIST_OF_SYSTEM_PACKAGES="vim"
            fi
            ;;

        xfce )
            LIST_OF_SYSTEM_PACKAGES="xfce4-appfinder xfce4-screenshoter xfce4-terminal xfdesktop"
            ;;

        # TODO list more packages names for different platforms

        * )
            LIST_OF_SYSTEM_PACKAGES="$TARGET"
            ;;
    esac


    # INSTALL PACKAGES FOR TARGET ETC.
    if [[ "$UNINSTALL" != true ]]; then
        echo "Installing ${TARGET}......"

        if [[ "$PLATFORM" = arch ]]; then
            if [[ "$FORCE" != true ]]; then
                sudo pacman --needed --confirm -S $LIST_OF_SYSTEM_PACKAGES
            else
                sudo pacman --noconfirm -S $LIST_OF_SYSTEM_PACKAGES
            fi
        elif [[ "$PLATFORM" = ubuntu ]]; then
            if [[ "$FORCE" != true ]]; then
                sudo apt install $LIST_OF_SYSTEM_PACKAGES
            else
                sudo apt --assume-yes install $LIST_OF_SYSTEM_PACKAGES
            fi
        elif [[ "$PLATFORM" = osx ]]; then
            brew install $LIST_OF_SYSTEM_PACKAGES
        fi

        case "$TARGET" in

            mopidy )
                mopidy local scan
                ;;

            tmux )
                mkdir -p "$HOME/.tmux/plugins"
                if test ! -d "$HOME/.tmux/plugins/tpm"; then
                    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
                    tmux command "run-shell '~/.tmux/plugins/tpm/bindings/install_plugins'"
                fi
                ;;

            vim )
                if test ! -d "$HOME/.vim/bundle/vundle"; then
                    git clone https://github.com/gmarik/vundle.git "$HOME/.vim/bundle/vundle"
                    vim -c "exec ':PluginInstall' | qall"
                fi
                ;;

        esac


    # UNINSTALL PACKAGES FOR TARGET ETC.
    else
        echo "Uninstalling ${TARGET}......"

        case "$TARGET" in

            bash)
                echo 'You really should not uninstall bash.'
                return 1
                ;;

        esac

        if [[ "$PLATFORM" = arch ]]; then
            if [[ "$FORCE" != true ]]; then
                sudo pacman --confirm -R $LIST_OF_SYSTEM_PACKAGES
            else
                sudo pacman --noconfirm -R $LIST_OF_SYSTEM_PACKAGES
            fi
        elif [[ "$PLATFORM" = ubuntu ]]; then
            if [[ "$FORCE" != true ]]; then
                sudo apt remove $LIST_OF_SYSTEM_PACKAGES
            else
                sudo apt --assume-yes remove $LIST_OF_SYSTEM_PACKAGES
            fi
        elif [[ "$PLATFORM" = osx ]]; then
            brew uninstall $LIST_OF_SYSTEM_PACKAGES
        fi
    fi
}




# cd into directory of this very script
# (otherwise the creating of links won't work!)
# http://stackoverflow.com/a/246128/4568748
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DIR" || exit 1


# get arguments
ALL=false
INTERACTIVE=false
FORCE=false
UNINSTALL=false
PACKAGE=false
TEMP=$(getopt -o hlaifup --long help,list-targets,all,interactive,force,uninstall,package-install -n 'test.sh' -- "$@")
eval set -- "$TEMP"
while true ; do
    case "$1" in
        -h|--help)              print_help_msg; exit 0 ;;
        -l|--list-targets)      print_supported_targets; exit 0 ;;
        -i|--interactive)       INTERACTIVE=true; shift ;;
        -f|--force)             FORCE=true ; shift ;;
        -a|--all)               ALL=true ; shift ;;
        -u|--uninstall)         UNINSTALL=true ; shift ;;
        -p|--package-install)   PACKAGE=true ; shift ;;
        --) shift ; break ;;
        *) echo 'Internal error!' ; exit 1 ;;
    esac
done


# test options
# note that both are not allowed simultaneously!
if [ $INTERACTIVE = true ] && [ $FORCE = true ]; then
    echo "You can not use interactive and force mode together!"
    # print_help_msg
    exit 1
fi


# handle targets
if [[ $# -eq 0 ]] && [[ $ALL != true ]]; then
    print_help_msg
    exit 0
elif [[ $ALL = true ]]; then
    for TARGET in ${SUPPORTED_TARGETS[*]}; do
        TARGET=${TARGET//\//}
        create_link_for_target "$TARGET"
        package_install_target "$TARGET"
    done
    for TARGET in ${ADDITIONAL_PACKAGE_TARGETS[*]}; do
        package_install_target "$TARGET"
    done
else
    while [[ $# -ne 0 ]]; do
        TARGET=${1//\//}
        create_link_for_target "$TARGET"
        package_install_target "$TARGET"
        shift
    done
fi



