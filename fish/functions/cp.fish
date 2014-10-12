function cp
	/bin/cp -i -r $argv
	and echo "Copied successfully."
	or echo "Could not copy!"
end
