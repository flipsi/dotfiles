function cd_interactively --description 'cd into a directoy interactively' --argument-names 'ROOT'
    if test ! -d "$ROOT"
        set ROOT $HOME
    end
    set -l DIR (fd --type d . $ROOT | fzf)
    if test "$DIR" != ""
        cd $DIR
    end
end
