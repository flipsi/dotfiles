function joshuto --description 'ranger-like file manager'
	set -l PID "$fish_pid"
	mkdir -p "/tmp/$USER"
	set -l OUTPUT_FILE "/tmp/$USER/joshuto-cwd-$PID"
	env joshuto --output-file "$OUTPUT_FILE" $argv
	set -l exit_code $status
	switch "$exit_code"
        case 0 # regular exit
        case 101 # output contains current directory
			set -l JOSHUTO_CWD (cat "$OUTPUT_FILE")
			cd "$JOSHUTO_CWD" || return
        case 102 # output selected files
        case '*'
			echo "Exit code: $exit_code"
    end
end
