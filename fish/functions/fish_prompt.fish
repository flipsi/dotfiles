function fish_prompt --description 'Prompt anzeigen'
	
	# Just calculate these once, to save a few cycles when displaying the prompt
	if not set -q __fish_prompt_hostname
		set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
	end

	if not set -q __fish_prompt_normal
		set -g __fish_prompt_normal (set_color normal)
	end

	switch $USER

	case root

		if not set -q __fish_prompt_cwd
			if set -q fish_color_cwd_root
				set -g __fish_prompt_cwd (set_color $fish_color_cwd_root)
			else
				set -g __fish_prompt_cwd (set_color $fish_color_cwd)
			end
		end

		echo -n -s "$USER" @ "$__fish_prompt_hostname" ' ' "$__fish_prompt_cwd" (prompt_pwd) "$__fish_prompt_normal" '# '

	case '*'


		# user
		set_color --bold '8ADE33'
		echo -n $USER'@'

		# host
		if test $__fish_prompt_hostname = 'asterix'
			set_color --bold '8ADE33'
		else
			set_color --bold 'F16161'
		end
		echo -n $__fish_prompt_hostname
		set_color '8ADE33'
		echo -n ':'

		# wd
		set wd (pwd)
		set_color --bold '629FCF'
		echo -n $wd

		# prompt
		set_color --bold normal
		echo -e -n -s '\n> '

	end
end
