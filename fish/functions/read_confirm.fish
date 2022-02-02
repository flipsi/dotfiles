function read_confirm --description 'ask user for confirmation' --argument-names 'PROMPT'
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
