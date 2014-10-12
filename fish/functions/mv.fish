function mv
	/bin/mv -i $argv
	and echo "Moved successfully."
	or echo "Could not move!"
end
