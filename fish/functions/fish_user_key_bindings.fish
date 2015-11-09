function fish_user_key_bindings
	bind \ei ranger
    bind \es 'commandline ""; echo; ll; echo; git status ^/dev/null; fish_prompt'
	bind \e. history-token-search-backward
	bind \e: history-token-search-forward
	bind \eh backward-char
	bind \el forward-char
end
