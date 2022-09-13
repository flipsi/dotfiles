function count_files --description 'count files in given or current directory'
    # TODO: add option to not count hidden files
    # TODO: add option to not count directories
    # TODO: add option to recurse in directories
    # (TODO: learn about `argparse`)
    # set -l options 'r/regularfiles'
    # argparse -n count_files $options -- $argv
    # or return

    if not set -q argv[1]
        set DIR .
    else
        set DIR $argv[1]
    end

    ls -1 "$DIR" | wc -l
end

