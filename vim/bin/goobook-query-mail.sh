#!/bin/sh

# https://atechnologyjobisnoexcuse.com/2010/04/google-contacts-in-mutt-and-vim/

goobook query "$*" \
    | sed -e '/^$/d' -e 's/\(.*\) \(.*\)\t.*/\1 \2/' -e 's/\(^\<.*\)\t\(.*\)/"\2" \<\1\>/' \
    | dmenu -l 5 -fn 'Monospace-9' -i -nb \#1E1E1E -sb \#00AFAF -sf \#1E1E1E

