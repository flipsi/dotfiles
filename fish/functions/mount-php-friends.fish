function mount-php-friends --description 'mount webspace'
	curlftpfs ftp://web2.php-friends.de /mnt/php-friends/
	and echo "Mounted successfully."
	or echo "Could not mount!"
end
