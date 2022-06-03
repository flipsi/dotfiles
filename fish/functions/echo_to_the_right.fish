function echo_to_the_right --description 'echo some string, but aligned to the right instead of the left'

    function string_length
        echo -n "$argv[1]" | wc -c | tr -d ' '
    end

    set -l STRING $argv[1]
    set -l STRING_LENGTH (string_length "$STRING")

    # Move to the end of the line. This will NOT wrap to the next line.
    echo -ne "\033["{$COLUMNS}"C"
    # Move back (length of output_str) columns.
    echo -ne "\033["{$STRING_LENGTH}"D"
    # Finally, print output.
    echo -e "$STRING"

end
