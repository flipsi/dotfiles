function fish_user_key_bindings
    bind \cr '__fzf_reverse_isearch'
    bind \e. history-token-search-backward
    bind \e: history-token-search-forward
    bind \ec 'history | head -n 1 | tr -d "\n" | xsel -b'
    bind \eh backward-char
    bind \ei 'ranger; and clear; and fish_prompt'
    bind \el forward-char
    bind \es 'commandline ""; echo; ll; echo; git status --short ^/dev/null; fish_prompt'
    bind \et 'commandline -i (echo -n (date +"%F-%H%M"))'
    bind \ew 'watch -c (history | head -n 1)'
end
