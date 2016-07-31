function fish_user_key_bindings
	bind \ei 'ranger; and clear; and fish_prompt'
    bind \es 'commandline ""; echo; ll; echo; git status ^/dev/null; fish_prompt'
    bind \ex 'pgrep i3; or startx i3'
	bind \e. history-token-search-backward
	bind \e: history-token-search-forward
	bind \eh backward-char
	bind \el forward-char
end
