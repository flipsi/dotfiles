#!/bin/sh

# goobook allows to access Google Contacts via the command line.
# This script wraps goobook to search interactively for a contacts and print their name and email.

# https://atechnologyjobisnoexcuse.com/2010/04/google-contacts-in-mutt-and-vim/

# On Arch Linux, I recommend installing it via pip:
#   `pip install --user goobook`
# because for the goobook AUR package there as package conflict:
#   Installing python-xdg will remove: python-pyxdg, python-pyxdg (python-xdg)

set -e

SEARCH="$*"

goobook query "$SEARCH" \
    | sed -e '/^$/d' -e 's/\(.*\) \(.*\)\t.*/\1 \2/' -e 's/\(^\<.*\)\t\(.*\)/"\2" \<\1\>/' \
    | rofi -dmenu

