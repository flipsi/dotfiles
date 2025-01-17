#!/bin/bash

# Author: "Philipp Moers" <soziflip@gmail.com>


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
    alacritty \
    autostart \
    bash \
    cmus \
    dircolors \
    elinks \
    fish \
    gcalcli \
    ghci \
    git \
    gnupg \
    gtk \
    i3 \
    intellij\
    k9s \
    kitty \
    kbd \
    konsole \
    lesskey \
    luakit \
    mopidy \
    mpd \
    mplayer \
    mutt \
    muttator \
    ncmpcpp \
    ncspot \
    neovim \
    neovide \
    picom \
    pentadactyl \
    polybar \
    psql \
    qimgv \
    qutebrowser \
    ranger \
    redshift \
    screen \
    sbt \
    sublime-text-3 \
    sxiv \
    taskwarrior \
    telegram-cli \
    telegram-desktop \
    tig \
    tmux \
    turses \
    urxvt \
    urlview \
    vim \
    vimfx \
    vimpc \
    vimperator \
    vimus \
    vlc \
    xfce4 \
    xkb \
    xmonad \
    zathura \
    zellij \
)

ADDITIONAL_PACKAGE_TARGETS=(\
    atool \
    fzf \
    fd \
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

function install_xresources_inclusion() {
    local sourcestring="#include "\""$1"\"
    touch "$HOME/.Xresources"
    if [[ $UNINSTALL != true ]]; then
        grep -q -F "$sourcestring" "$HOME/.Xresources"  || echo "$sourcestring" >> "$HOME/.Xresources"
        xrdb -all "$HOME/.Xresources"
    else
        sed -i -- "/^${sourcestring//\//\\/}$/d" "$HOME/.Xresources"
    fi
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

        alacritty )
            mkdir -p "$HOME/.config/alacritty"
            create_link "$PWD/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
            ;;

        autostart )
            mkdir -p "$HOME/bin"
            mkdir -p "$HOME/.config/autostart"
            create_link "$PWD/autostart/clipmenud.desktop" "$HOME/.config/autostart/clipmenud.desktop"
            create_link "$PWD/autostart/numlockx.desktop" "$HOME/.config/autostart/numlockx.desktop"
            create_link "$PWD/autostart/syndaemon.desktop" "$HOME/.config/autostart/syndaemon.desktop"
            create_link "$PWD/autostart/unclutter.desktop" "$HOME/.config/autostart/unclutter.desktop"
            create_link "$PWD/autostart/keymapp.desktop" "$HOME/.config/autostart/keymapp.desktop"
            ;;

        bash )
            local sourcestring="source $PWD/bash/bashrc_sflip"
            if [[ $UNINSTALL != true ]]; then
                grep -q -F "$sourcestring" "$HOME/.bashrc" || echo "$sourcestring" >> "$HOME/.bashrc"
            else
                sed -i -- "/^${sourcestring//\//\\/}$/d" "$HOME/.bashrc"
            fi
            ;;

        bpytop )
            mkdir -p "$HOME/.config/bpytop"
            create_link "$PWD/bpytop/bpytop.conf" "$HOME/.config/bpytop/bpytop.conf"
            ;;

        cmus )
            mkdir -p "$HOME/.cmus"
            create_link "$PWD/cmus/rc" "$HOME/.cmus/rc"
            create_link "$PWD/cmus/sflea.theme" "$HOME/.cmus/sflea.theme"
            create_link "$PWD/cmus/gruvbox.theme" "$HOME/.cmus/gruvbox.theme"
            ;;

        picom )
            create_link "$PWD/picom/picom.conf" "$HOME/.config/picom.conf"
            ;;

        dircolors )
            create_link "$PWD/dircolors/dircolors" "$HOME/.dircolors"
            ;;

        elinks )
            mkdir -p "$HOME/.elinks"
            create_link "$PWD/elinks/elinks.conf" "$HOME/.elinks/elinks.conf"
            ;;

        fish )
            mkdir -p "$HOME/.config/fish"
            create_link "$PWD/fish/functions" "$HOME/.config/fish/functions"
            create_link "$PWD/fish/completions" "$HOME/.config/fish/completions"
            create_link "$PWD/fish/config.fish" "$HOME/.config/fish/config.fish"
            create_link "$PWD/fish/environment.fish" "$HOME/.config/fish/environment.fish"
            create_link "$PWD/fish/abbr.fish" "$HOME/.config/fish/abbr.fish"
            create_link "$PWD/fish/commands.fish" "$HOME/.config/fish/commands.fish"
            ;;

        gcalcli )
            create_link "$PWD/gcalcli/gcalclirc" "$HOME/.gcalclirc"
            ;;

        ghci )
            create_link "$PWD/ghci/ghci" "$HOME/.ghci"
            ;;

        git )
            create_link "$PWD/git/gitconfig" "$HOME/.gitconfig"
            create_link "$PWD/git/gitignore" "$HOME/.gitignore"
            ;;

        gnupg )
            mkdir -p "$HOME/.gnupg"
            create_link "$PWD/gnupg/gpg-agent.conf" "$HOME/.gnupg/gpg-agent.conf"
            ;;

        gtk )
            mkdir -p "$HOME/.config/gtk-3.0"
            mkdir -p "$HOME/.config/gtk-4.0"
            create_link "$PWD/gtk/settings.ini" "$HOME/.config/gtk-3.0/settings.ini"
            create_link "$PWD/gtk/settings.ini" "$HOME/.config/gtk-4.0/settings.ini"
            ;;

        i3 )
            mkdir -p "$HOME/.i3"
            create_link "$PWD/i3/config" "$HOME/.i3/config"
            # create_link "$PWD/i3/i3status" "$HOME/.i3/i3status"
            create_link "$PWD/i3/i3pystatus" "$HOME/.i3/i3pystatus"
            create_link "$PWD/i3/bin" "$HOME/.i3/bin"
            create_link "$PWD/i3/wallpaper" "$HOME/.i3/wallpaper"
            ;;

        intellij )
            create_link "$PWD/intellij/ideavimrc" "$HOME/.ideavimrc"
            INTELLIJ_DIRS=$(find "$HOME" -maxdepth 1 -type d -name '.IntelliJIdea*')
            for DIR in $INTELLIJ_DIRS; do
                create_link "$PWD/intellij/idea.properties" "$DIR/config/idea.properties"
            done
            ;;

        joshuto )
            create_link "$PWD/joshuto" "$HOME/.config/joshuto"
            ;;

        k9s )
            mkdir -p "$HOME/.config/k9s"
            create_link "$PWD/k9s/config.yaml" "$HOME/.config/k9s/config.yaml"
            create_link "$PWD/k9s/skins" "$HOME/.config/k9s/skins"
            ;;

        kbd )
            if [[ $(whoami) = 'root' ]]; then
                mkdir -p "/usr/local/share/kbd/keymaps/"
                create_link "$PWD/kbd/us_sflip.map" "/usr/local/share/kbd/keymaps/us_sflip.map"
            fi
            loadkeys us_sflip
            ;;

        kitty )
            mkdir -p "$HOME/.config/kitty"
            create_link "$PWD/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"
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
            mkdir -p "$HOME/.config/.mpd"
            create_link /mnt/extern/data/music "$HOME/.mpd/music"
            create_link "$PWD/mpd/mpdconf" "$HOME/.mpdconf"
            ;;

        mplayer )
            mkdir -p "$HOME/.mplayer"
            create_link "$PWD/mplayer/config" "$HOME/.mplayer/config"
            create_link "$PWD/mplayer/input.conf" "$HOME/.mplayer/input.conf"
            ;;

        mutt )
            create_link "$PWD/mutt/mutt" "$HOME/.config/mutt"
            create_link "$PWD/mutt/mbsyncrc" "$HOME/.mbsyncrc"
            create_link "$PWD/mutt/msmtprc" "$HOME/.msmtprc"
            mkdir -p "$HOME/bin"
            create_link "$PWD/mutt/mail.sh" "$HOME/bin/mail"
            create_link "$PWD/mutt/secrets.py" "$HOME/bin/mutt-secrets.py"
            ;;

        muttator )
            create_link "$PWD/muttator/muttatorrc" "$HOME/.muttatorrc"
            ;;

        ncmpcpp )
            mkdir -p "$HOME/.ncmpcpp"
            create_link "$PWD/ncmpcpp/config" "$HOME/.ncmpcpp/config"
            create_link "$PWD/ncmpcpp/bindings" "$HOME/.ncmpcpp/bindings"
            ;;

        ncspot )
            mkdir -p "$HOME/.config/ncspot/"
            create_link "$PWD/ncspot/config.toml" "$HOME/.config/ncspot/config.toml"
            ;;

        neovide )
            mkdir -p "$HOME/.config/neovide"
            create_link "$PWD/neovide/config.toml" "$HOME/.config/neovide/config.toml"
            ;;

        neovim )
            mkdir -p "$HOME/.config/nvim/lua"
            if [[ -L  "$HOME/.config/nvim/init.vim" ]]; then
                rm "$HOME/.config/nvim/init.vim"
            fi
            create_link "$PWD/nvim/init.lua" "$HOME/.config/nvim/init.lua"
            create_link "$PWD/nvim/lua/flipsi" "$HOME/.config/nvim/lua/flipsi"
            create_link "$PWD/nvim/ftplugin" "$HOME/.config/nvim/ftplugin"
            create_link "$PWD/nvim/syntax" "$HOME/.config/nvim/syntax"
            create_link "$PWD/vim/vim/coc-settings.json" "$HOME/.config/nvim/coc-settings.json"
            create_link "$PWD/vim/markdownlint.yaml" "$HOME/.markdownlint.yaml"
            ;;

        outlook-for-linux )
            mkdir -p "$HOME/.config/outlook-for-linux"
            create_link "$PWD/outlook-for-linux/config.json" "$HOME/.config/outlook-for-linux/config.json"
            ;;

        pentadactyl )
            create_link "$PWD/pentadactyl/pentadactyl" "$HOME/.pentadactyl"
            create_link "$PWD/pentadactyl/pentadactylrc" "$HOME/.pentadactylrc"
            ;;

        psql )
            create_link "$PWD/psql/psqlrc" "$HOME/.psqlrc"
            ;;

        polybar )
            mkdir -p "$HOME/.config/polybar"
            create_link "$PWD/polybar/config.ini" "$HOME/.config/polybar/config.ini"
            create_link "$PWD/polybar/scripts" "$HOME/.config/polybar/scripts"
            ;;

        qimgv )
            mkdir -p "$HOME/.config/qimgv"
            create_link "$PWD/qimgv/qimgv.conf" "$HOME/.config/qimgv/qimgv.conf"
            ;;

        qutebrowser )
            mkdir -p "$HOME/.config/.qutebrowser"
            create_link "$PWD/qutebrowser/config.py" "$HOME/.config/qutebrowser/config.py"
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

        rofi )
            mkdir -p "$HOME/.config/rofi"
            create_link "$PWD/rofi/config.rasi" "$HOME/.config/rofi/config.rasi"
            create_link "$PWD/rofi/themes" "$HOME/.config/rofi/themes"
            ;;

        redshift )
            create_link "$PWD/redshift/redshift.conf" "$HOME/.config/redshift.conf"
            mkdir -p "$HOME/.config/autostart"
            create_link "$PWD/redshift/redshift.desktop" "$HOME/.config/autostart/redshift.desktop"
            ;;

        sbt )
            create_link "$PWD/sbt/sbtconfig" "$HOME/.sbtconfig"
            mkdir -p "$HOME/.sbt/1.0/plugins"
            create_link "$PWD/sbt/plugins.sbt" "$HOME/.sbt/1.0/plugins/plugins.sbt"
            ;;

        screen )
            create_link "$PWD/screen/screenrc" "$HOME/.screenrc"
            ;;

        shellcheck )
            create_link "$PWD/shellcheck/shellcheckrc" "$HOME/.shellcheckrc"
            ;;

        sublime-text-3 )
            mkdir -p "$HOME/.config/sublime-text-3/Packages"
            create_link "$PWD/sublime/User" "$HOME/.config/sublime-text-3/Packages/User"
            create_link "$PWD/sublime/jsbeautifyrc" "$HOME/.jsbeautifyrc"
            ;;

        sxiv )
            mkdir -p "$HOME/bin"
            # create_link "$PWD/sxiv/nsxiv-extra/scripts/nsxiv-rifle/nsxiv-rifle" "$HOME/bin/nsxiv" sadly, the script doesn't use env to invoke nsxiv
            create_link "$PWD/sxiv/nsxiv-extra/scripts/nsxiv-rifle/nsxiv-rifle" "$HOME/bin/nsxiv-rifle"
            install_xresources_inclusion  "$PWD/sxiv/Xresources"
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
            create_link "$PWD/tmux/tmux-initialize-sessions.sh" "$HOME/bin/tmux-initialize-sessions.sh"
            create_link "$PWD/tmux/tmux-project-session.sh" "$HOME/bin/tmux-project-session.sh"
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

        urxvt )
            install_xresources_inclusion "$PWD/urxvt/Xresources"
            ;;

        vim )
            mkdir -p "$HOME/.vim"
            mkdir -p "$HOME/.vim/config"
            mkdir -p "$HOME/.vim/undodir"
            create_link "$PWD/vim/vimrc" "$HOME/.vimrc"
            create_link "$PWD/vim/gvimrc" "$HOME/.gvimrc"
            create_link "$PWD/vim/ctags" "$HOME/.ctags"
            create_link "$PWD/vim/config/" "$HOME/.vim/config"
            create_link "$PWD/vim/config/eslintrc.json" "$HOME/.eslintrc.json"
            create_link "$PWD/vim/vim/coc-settings.json" "$HOME/.vim/coc-settings.json"
            create_link "$PWD/vim/markdownlint.yaml" "$HOME/.markdownlint.yaml"
            create_link "$PWD/vim/vim/filetype.vim" "$HOME/.vim/filetype.vim"
            create_link "$PWD/vim/vim/sflipsnippets" "$HOME/.vim/sflipsnippets"
            create_link "$PWD/vim/vim/spell" "$HOME/.vim/spell"
            create_link "$PWD/vim/vim/spellfile.utf-8.add" "$HOME/.vim/spellfile.utf-8.add"
            create_link "$PWD/vim/vim/syntax" "$HOME/.vim/syntax"
            create_link "$PWD/vim/vim/ftdetect" "$HOME/.vim/ftdetect"
            mkdir -p "$HOME/bin"
            create_link "$PWD/vim/bin/goobook-query-mail.sh" "$HOME/bin/goobook-query-mail.sh"
            create_link "$PWD/vim/agignore" "$HOME/.agignore"
            ;;

        vimfx )
            mkdir -p "$HOME/.config/vimfx"
            create_link "$PWD/vimfx/config.js" "$HOME/.config/vimfx/config.js"
            create_link "$PWD/vimfx/frame.js" "$HOME/.config/vimfx/frame.js"
            local sourcestring="@import url("\""$PWD/vimfx/userChrome.css"\"");"
            local userChromeCssFilepath=$(find ~/.mozilla/firefox -name userChrome.css)
            # TODO: create profile chrome/userChrome.css if not exists
            if [[ $UNINSTALL != true ]]; then
                grep -q -F "${sourcestring}" "${userChromeCssFilepath}"  || echo "$sourcestring" >> "${userChromeCssFilepath}"
            else
                sed -i -- "/^${sourcestring//\//\\/}$/d" "${userChromeCssFilepath}"
            fi
            ;;

        vimium )
            echo "PLEASE OPEN THE VIMIUM EXTENSION'S OPTIONS IN THE BROWSER AND PASTE THE FOLLOWING:"
            echo
            cat "$PWD/vimium/custom-key-bindings.vim"
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
            mkdir -p "$HOME/.config/vlc"
            create_link "$PWD/vlc/vlcrc" "$HOME/.config/vlc/vlcrc"
            ;;

        xfce4 )
            mkdir -p "$HOME/.config/xfce4"
            mkdir -p "$HOME/.config/xfce4/terminal"
            create_link "$PWD/xfce4/xfconf" "$HOME/.config/xfce4/xfconf"
            create_link "$PWD/xfce4/terminal" "$HOME/.config/xfce4/terminal"
            create_link "$PWD/xfce4/xfce4-screenshooter" "$HOME/.config/xfce4/xfce4-screenshooter"
            ;;

        xkb )
            if [[ $(whoami) = 'root' ]]; then
                create_link "$PWD/xkb/symbols/de_sflip" "/usr/share/X11/xkb/symbols/de_sflip"
                create_link "$PWD/xkb/symbols/us_sflip" "/usr/share/X11/xkb/symbols/us_sflip"
                create_link "$PWD/xkb/symbols/us_norman_sflip" "/usr/share/X11/xkb/symbols/us_norman_sflip"
            fi
            setxkbmap us_sflip
            mkdir -p "$HOME/.config/autostart"
            create_link "$PWD/xkb/setxkbmap.desktop" "$HOME/.config/autostart/setxkbmap.desktop"
            ;;

        xmonad )
            mkdir -p "$HOME/.xmonad"
            create_link "$PWD/xmonad/xmonad.hs" "$HOME/.xmonad/xmonad.hs"
            ;;

        zathura )
            mkdir -p "$HOME/.config/zathura"
            create_link "$PWD/zathura/zathurarc" "$HOME/.config/zathura/zathurarc"
            ;;

        zellij )
            create_link "$PWD/zellij" "$HOME/.config/zellij"
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
            LIST_OF_SYSTEM_PACKAGES="i3-wm i3exit i3status i3lock dmenu clipmenud rofi picom redshift unclutter syndaemon numlockx"
            ;;

        fd )
            LIST_OF_SYSTEM_PACKAGES="fd-find"
            ;;

        mutt )
            echo 'WARNING: See mutt/README.md for packages to install!'
            ;;

        taskwarrior )
            LIST_OF_SYSTEM_PACKAGES="task"
            ;;

        urxvt )
            LIST_OF_SYSTEM_PACKAGES="rxvt-unicode urxvt-perls urxvt-resize-font-git"
            ;;

        neovim )
            LIST_OF_SYSTEM_PACKAGES="neovim python-neovim"
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

        case "$TARGET" in

            fd )
                cargo install $LIST_OF_SYSTEM_PACKAGES
                ;;

            * )

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
                ;;

        esac

        # ADDITIONAL STUFF
        case "$TARGET" in

            fish )
                if test ! -d "$HOME/opt/fish-command-timer"; then
                    echo "Installing fish-command-timer"
                    mkdir -p "$HOME/opt/fish-command-timer/"
                    curl https://raw.githubusercontent.com/jichu4n/fish-command-timer/master/conf.d/fish_command_timer.fish > "$HOME/opt/fish-command-timer/fish-command-timer.fish"
                    mkdir -p "$HOME/.config/fish/conf.d/"
                    create_link "$HOME/opt/fish-command-timer/fish-command-timer.fish" "$HOME/.config/fish/conf.d/"
                fi
                ;;

            git )
                gem install git-rc # git release
                ;;

            mopidy )
                mopidy local scan
                ;;

            tmux )
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

        # ADDITIONAL STUFF AND SPECIAL CASES
        case "$TARGET" in

            bash )
                echo 'You really should not uninstall bash.'
                return 1
                ;;

        esac

        # UNINSTALL PACKAGE
        case "$TARGET" in

            fd )
                cargo uninstall $LIST_OF_SYSTEM_PACKAGES
                ;;

            * )
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
                ;;
        esac
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



