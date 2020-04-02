function fish_user_key_bindings
    bind \cs 'fzf_command_chooser'
    bind \cr '__fzf_reverse_isearch'
    bind \e, history-token-search-backward
    bind \e. history-token-search-forward
    bind \ec 'history | head -n 1 | tr -d "\n" | xsel -b'
    bind \ei 'ranger; and clear; and fish_prompt'
    bind \el 'cd_interactively; and clear; and fish_prompt'
    bind \es 'commandline ""; ll; echo; git status --short 2>/dev/null; fish_prompt'
    bind \et 'commandline -i (echo -n (date +"%F-%H%M%S"))'
    bind \eu 'commandline ""; cd ..; clear; fish_prompt'
    bind \ew 'watch -c (history | head -n 1)'
end
