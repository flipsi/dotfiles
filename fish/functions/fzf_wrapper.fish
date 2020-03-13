function fzf_wrapper --description 'wrapper for fzf to find files and directories'

    function __fzf_wrapper_help
echo 'fzf_wrapper - wrapper for fzf to find files and directories

SYNOPSIS
    fzf_wrapper [MODE] [ACTION] [PATTERN]

DESCRIPTION
    fzf allows it to quickly and fuzzily search stdin.
    This wrapper is just the way i personally use it to find files and directories.
    PATTERN is mandatory for locate mode, while optional for find mode.
    If ACTION is omitted, it will be prompted interactively.

OPTIONS
    MODE can be one of:
    -l, --locate : use the locate database (default)
    -i, --find   : search live in the current working directory
    ACTION can be one of:
    -n, --none   : just print filename to stdout
    -c, --copy   : copy filepath to clipboard and primary selection
    -o, --open   : open with default application
    -e, --edit   : edit with editor ($EDITOR)
    -r, --ranger : select file with ranger file manager

AUTHOR
    Philipp Moers <soziflip@gmail.com>
    '
    end


    set -l default_mode locate
    set -l mode $default_mode
    set -l action interactive
    set -l pattern


    function __fzf_wrapper_prompt
echo 'Choose action: [c]opy filepath
               [o]pen with default application
               [e]dit with editor
               [r]anger file manager
'
    end

    function __fzf_wrapper_interactive_action_prompt
        read -n 1 -p __fzf_wrapper_prompt -l input
        switch $input
            case c
                echo copy
            case o
                echo open
            case e
                echo edit
            case r
                echo ranger
            case '*'
                echo none
        end
    end

    # process arguments
    while set -q argv[1]
        switch $argv[1]
            case '-h' '--help' '-help'
                __fzf_wrapper_help
                return 0
            case '-l' '--locate'
                set mode locate
            case '-i' '--find'
                set mode find
            case '-n' '--none'
                set action none
            case '-c' '--copy'
                set action copy
            case '-o' '--open'
                set action open
            case '-e' '--edit'
                set action edit
            case '-r' '--ranger'
                set action ranger
            case '*'
                set pattern $pattern $argv[1]
        end
        set -e argv[1]
    end

    # execute fzf to choose file
    set -l file
    if test $mode = "find"
        # fzf -q $pattern
        if command -v ag >/dev/null 2>&1
            ag -l --silent -g "$pattern" | fzf | read file
            # ag -l --silent -g "$pattern" | sed -e 's:/[^/]*$::' | uniq | fzf --cycle | read file
        else
            find -L -name '.git' -prune -o -path "*$pattern*" -print | fzf --cycle | read file
        end
    else # locate mode
        if test -z $pattern
            echo "Error: Please provide a pattern!"; echo
            __fzf_wrapper_help
            return 1
        else
            locate -i $pattern | fzf --cycle | read file
        end
    end

    # print selected file
    and echo $file
    or return 1

    # and execute action
    if test $action = interactive
        set action (__fzf_wrapper_interactive_action_prompt)
    end
    if test $action != none
        switch $action
            case copy
                echo -n $file | xsel -i --primary
                echo -n $file | xsel -i --clipboard
            case open
                xdg-open "$file"
            case edit
                if set -q EDITOR; set EDITOR vim; end
                eval $EDITOR \"$file\"
            case ranger
                ranger --selectfile=$file
        end
    end

end
