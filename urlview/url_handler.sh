#!/bin/bash

# Author: Philipp Moers <soziflip@gmail.com>

# This script handles URLs and wraps url_handler.sh from 'urlview'.

# It basically checks for web urls and opens them in a browser I want.
# Other than that, it just calls the original url_handler.sh.


# set BROWSER (e.g. in /etc/environment) to overwrite
BROWSER=vivaldi-stable

# checked browsers if BROWSER is not set
BROWSERS=`cat <<END
    vivaldi-stable\
    chromium\
    chromium-browser\
    google-chrome-stable\
    google-chrome\
    chrome\
    palemoon\
    firefox\
    luakit
END
`

function exec_browser()
{

    if [[ -n $BROWSER ]]; then
        $BROWSER $url
    else
        for BROWSER in $BROWSERS; do
            if (command -v $BROWSER >/dev/null 2>&1); then
                $BROWSER $url
                exit 0
            fi
        done
        return 1
    fi
}



url="$1"; shift

type="${url%%:*}"

if [ "$url" = "$type" ]; then
    type="${url%%.*}"
    case "$type" in
        www|web)
            type=http
            ;;
    esac
    url="$type://$url"
fi

case $type in
    https)
        exec_browser $url || /etc/urlview/url_handler.sh $url
        ;;
    http)
        exec_browser $url || /etc/urlview/url_handler.sh $url
        ;;
    *)
        /etc/urlview/url_handler.sh $url
        ;;
esac
