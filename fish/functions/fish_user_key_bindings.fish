function fish_user_key_bindings
	
	#bind \ea beginning-of-line
	#bind \ee end-of-line
	#bind \el forward-char
	#bind \eh backward-char
	#bind \ew forward-word
	#bind \eb backward-word
	# token search - great thing
	bind \e. history-token-search-backward
	bind \e: history-token-search-forward
	# NEO movements in QWERTZ (better with xmodmap)
	#bind € history-search-backward
	#bind đ forward-char
	#bind ð history-search-forward
	#bind ſ backward-char
	#bind ł backward-delete-char
	#bind ¶ delete-char
	#bind æ beginning-of-line
	#bind ŋ end-of-line
end
