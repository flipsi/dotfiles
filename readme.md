sflip's dotfiles
================

These files pretty much constitute my digital home.


## Usage

First clone this project via

    git clone --recursive https://github.com/sflip/dotfiles

Then, install my configuration (symlinks/packages) with the installation script

    cd dotfiles
    ./install.sh [OPTIONS] TARGET...

where a `TARGET` can be one or more items from the list printed with `-l`.
Note that `-ap` also installs some additional packages, not listed with `-l`.

    OPTIONS:
    -h | --help             Don't do anything, just print this help message.
    -l | --list-targets     Don't do anything, just list supported targets.
    -a | --all              Install almost everything. TARGET will be ignored.
    -i | --interactive      If configuration exists, ask what to do.
    -f | --force            If configuration exists, overwrite it.
    -u | --uninstall        Remove configuration.
    -p | --package-install  Also (un-)install the corresponding system packages.


### Example

    ./install.sh -i vim


## Contact

Bugs? Questions? Comments?
Do not hesitate
[create a Github issue](https://github.com/sflip/dotfiles/issues/new) or
[shoot me a mail](mailto://soziflip@gmail.com)!
