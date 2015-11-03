function fish_user_key_bindings
    bind -M insert \cl 'clear; fish_prompt'
    bind           \cl 'clear; fish_prompt'
    bind           \ei ranger
	bind -M insert \ei ranger
    bind           \es 'git status; fish_prompt'
    bind -M insert \es 'git status; fish_prompt'
	bind -M insert \e. history-token-search-backward
	bind -M insert \e: history-token-search-forward
	bind -M insert \eh backward-char
	bind -M insert \el forward-char
end
