function exa_or_ls --description 'list directory contents'
    if command -qs exa
        exa --grid --git $argv
    else
        ls $argv
    end
end
