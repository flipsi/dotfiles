function bak --description 'make a copy of files as a backup'
    set timestamp (date +%Y-%m-%d-%H-%M)
    for file in $argv
        set backup_file "$file.$timestamp.bak"
        if touch "$backup_file" > /dev/null 2> /dev/null
            cp -r "$file" "$backup_file"
        else
           sudo cp -r "$file" "$backup_file"
       end
    end
end
