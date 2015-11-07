function fish_user_key_bindings
	bind \ei ranger
    bind \es 'commandline ""; echo; ll; if test -e .git; echo; git status; end; fish_prompt'
	bind \e. history-token-search-backward
	bind \e: history-token-search-forward
	bind \eh backward-char
	bind \el forward-char
end
