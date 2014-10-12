function rrm --description 'remove recursively and force'
	if read_confirm
		/bin/rm -rf $argv
		and echo "Removed file(s)."
	else
		echo "Done Nothing."
	end
end
