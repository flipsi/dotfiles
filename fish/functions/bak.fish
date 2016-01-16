function bak --description 'make a copy of files as a backup'
	for file in $argv
        cp -r $file $file.bak
    end
end
