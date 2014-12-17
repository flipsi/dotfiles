function mount-php-friends --description 'mount webspace to /media/php-friends/'
	curlftpfs ftp://web2.php-friends.de /media/sflip/php-friends/
	and echo "Mounted successfully."
	or echo "Could not mount!"
end
