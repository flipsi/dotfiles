function exa_or_tree --description 'list directory contents in tree-like format'
    if command -qs exa
        exa --tree --git $argv
    else
        tree $argv
    end
end
