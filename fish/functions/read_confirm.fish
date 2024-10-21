function read_confirm --description 'ask user for confirmation' --argument-names 'PROMPT'
    # use like read_confirm && rm filename
    #       or read_confirm 'Are you sure? ' && rm filename
    if test -z "$PROMPT"
        set -x PROMPT 'Continue? [y/n] '
    end
    while true
        read -l -P $PROMPT confirm
        switch $confirm
            case Y y j J
                return 0
            case '' N n
                return 1
        end
    end
end
