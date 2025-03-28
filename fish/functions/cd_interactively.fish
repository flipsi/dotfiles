function cd_interactively --description 'cd into a directoy interactively' --argument-names 'ROOT' --argument-names 'COMMAND'
    if test ! -d "$ROOT"
        set ROOT $HOME
    end
    set -l DIR (fd --type d . $ROOT | fzf)
    if test "$DIR" != ""
        cd $DIR
        if command -v "$COMMAND" >/dev/null
            "$COMMAND"
        end
    end
end
