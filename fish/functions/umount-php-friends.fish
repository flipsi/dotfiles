function umount-php-friends --description 'unmount webspace from /media/php-friends'
	fusermount -u /media/php-friends/
and echo "Unmounted successfully."
or echo "Could not unmount!"
end
