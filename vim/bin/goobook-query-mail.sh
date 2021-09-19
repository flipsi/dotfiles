#!/usr/bin/env bash

set -e

function print_help_msg() {
    cat <<-EOF
goobook allows to access Google Contacts via the command line.
This script wraps goobook to search interactively for a contacts and print their name/email.

Usage: $(basename "$0") <SEARCH>

Credits to this blog post:
https://atechnologyjobisnoexcuse.com/2010/04/google-contacts-in-mutt-and-vim/

On Arch Linux, I recommend installing goobook via pip:
  \`pip install --user goobook\`
because for the goobook AUR package there as package conflict:
  Installing python-xdg will remove: python-pyxdg, python-pyxdg (python-xdg)
EOF
}


if [[ "$1" = "--help" ]]; then
    print_help_msg
    exit 0
fi

# Get search string from argument or interactively
SEARCH="$*"
if [[ -z "$SEARCH" ]]; then
    SEARCH=$(rofi -dmenu -l 0 -p 'Contact search')
fi
if [[ -z "$SEARCH" ]]; then
    echo "ERROR: No search string given!"
    exit 1
fi

# Query Google contacts
mapfile -t GOOBOOK_RESULTS < <(goobook query "$SEARCH")

# Choose output format
FORMAT_OPTION_ONLY_EMAIL="Only Email"
FORMAT_OPTION_LONG_THING="Name with Email formatted professionally"
FORMAT_CHOICE=$(echo -e "$FORMAT_OPTION_ONLY_EMAIL\n$FORMAT_OPTION_LONG_THING" | rofi -dmenu -l 2)

# Choose result and print it
# shellcheck disable=SC2145
if [[ "$FORMAT_CHOICE" = "$FORMAT_OPTION_LONG_THING" ]]; then
    printf "%s\n${GOOBOOK_RESULTS[@]}" \
        | sed -E -e '/^$/d' -e 's/(.*) (.*)\t.*/\1 \2/' -e 's/(^\<.*)\t(.*)/"\2" \<\1\>/' \
        | rofi -dmenu
else
    printf "%s\n${GOOBOOK_RESULTS[@]}" \
        | sed -E -e '/^$/d' -e 's/([[:alnum:]]*)\t.*/\1/' \
        | rofi -dmenu
fi

