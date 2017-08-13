function fish_user_key_bindings
    bind \ei 'ranger; and clear; and fish_prompt'
    bind \es 'commandline ""; echo; ll; echo; git status --short ^/dev/null; fish_prompt'
    bind \ec 'history | head -n 1 | tr -d "\n" | xsel -b'
    bind \e. history-token-search-backward
    bind \e: history-token-search-forward
    bind \eh backward-char
    bind \el forward-char
end
