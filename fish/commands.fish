# this is a collection of useful commands that might get lost if not written down

sudo nmcli device wifi connect WIFIonICE
curl -T $FILENAME temp.sh # upload file for sharing (expires after 3 days)
curl v4.ident.me # public IP address
curl wttr.in # weather report
date +%s # unix timestamp
docker run -it --rm alpine
docker pull postgres && docker run -p 5432:5432 --rm --name some-postgres -e POSTGRES_PASSWORD=strong postgres # ad hoc PostgreSQL database
exec su -l $USER # reload user groups in current shell
psql -h 127.0.0.1 -U postgres # connect to local PostgreSQL database
git branch -vv --merged | grep "\[.*/.*: gone\]" | cut -d" " -f3 | xargs git branch -d # delete merged branches
git checkout --quiet --detach; git fetch (git remote | head -n1) master:master; git checkout --quiet -
picom-trans -s -o 90 # set transparency for window to be clicked on
python -m http.server # start local HTTP server with file listing of current directory
ss -lt src :5432 # show all TCP sockets listening on a specific port
ssh clidle.ddns.net -p 3000 # wordle game
sudoedit /etc/X11/xorg.conf.d/00-keyboard.conf # configure Xorg keyboard layout
sudo pacman -Sy archlinux-keyring # update keys for pacman upgrade
yay -Sc # clear pacman cache (to free disk space)
yay -Yc # remove unused dependencies
sudo udevadm control --reload-rules && sudo udevadm trigger # reload udev rules without reboot
