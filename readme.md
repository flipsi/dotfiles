sflip's Configuration Files
===========================

These are some configuration files ("dotfiles", "rc files", ...). 

I use git to version control and github to sync them. Feel free to have a look!


## Usage

First clone this project via

    git clone https://github.com/sflip/dotfiles

Then change into the cloned directory (this is important for the script to work!)

    cd ./dotfiles

Finally, install my configuration with the installation script

    ./install.sh [OPTIONS] TARGET

where `TARGET` can either be an item from the targets listed below, or `all` to install every target.

### Example

    ./install.sh -i vim


## Targets

* `bash` basic stuff for bash, will be sourced additionally
* `cmus` music player for the terminal
* `dactyl` vim-addons for mozilla applications (currently only pentadactyl for firefox)
* `elinks` web browser for the terminal
* `fish` great interactive shell
* `ghci` repl for the glorious haskell compiler
* `git` global git configuration
* `i3` tiling window manager
* `lesskey` keybindings and more for less
* `luakit` lightweight web browser
* `mpd` music player daemon
* `mutt` a really nerdy mail client for the terminal
* `muttator` vim-addon for thunderbird
* `pentadactyl` vim-addon for firefox
* `ranger` file manager for the terminal
* `sublime-text-3` the text editor of my choice
* `telegram-cli` a command line client for the messenger
* `tmux` a must have for terminal junkies
* `turses` twitter client for the terminal
* `vim` the best reason not to use emacs
* `vimpc` mpd client for the terminal
* `vimperator` vim-addon for firefox
* `vimus` mpd client for the terminal
* `vlc` great media player
* `xkb` keyboard layout for X
* `xmonad` a haskell based window manager
* `zathura` pdf viewer

## Contact

Shoot me a mail to soziflip gmail com.
