function echo_horizontal_line --description 'echo a horizontal line'

    set -l horizontal_line ""
    set -l columns (tput cols)

    for x in (seq $columns)
        set horizontal_line _$horizontal_line
    end

    echo $horizontal_line

end
