#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then

    xrdb -merge $sysresources

fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then

    xrdb -merge "$userresources"

fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi


# start desktop or window manager or whatever by argument

default_session="i3"
session=${1:-$default_session}


case $session in
    term|terminal|alacritty)
      exec alacritty --dimensions 190 48 -e tmux
      ;;
    http*|www*|*.com)
      exec chromium --start-maximized --incognito --kiosk "$session"
      ;;
    browser|chrome|chromium)
      exec chromium --start-maximized --incognito https://duckduckgo.com/
      ;;
    i3|i3wm)
      exec i3
      ;;
    gnome|gnome-session)
      export XDG_SESSION_TYPE=x11
      export GDK_BACKEND=x11
      exec gnome-session
      ;;
    kde)
      exec startplasma-x11
      ;;
    xfce|xfce4)
      exec startxfce4
      ;;
    *)
      echo "Unknown session $session"
      exit 1
      ;;
esac
