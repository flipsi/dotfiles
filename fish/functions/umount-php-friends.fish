function umount-php-friends --description 'unmount webspace from /media/php-friends'
	fusermount -u /media/sflip/php-friends/
	and echo "Unmounted successfully."
	or echo "Could not unmount!"
end
