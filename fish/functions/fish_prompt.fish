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

		if not set -q __fish_prompt_cwd
			set -g __fish_prompt_cwd (set_color $fish_color_cwd)
		end

		set wd (pwd)

		set color_key yellow
		set color_value red
		set something_different no

		echo -e -n "\n "

		# only show information when it differs from default
		if test $__fish_prompt_hostname != "asterix"
			set something_different yes
			set_color $color_key
			echo -n "host: "
			set_color $color_value
			echo -n $__fish_prompt_hostname " "
		end
		if test $USER != "sflip"
			set something_different yes
			set_color $color_key
			echo -n "user: "
			set_color $color_value
			echo -n $USER " "
		end
		if test $wd != "/home/sflip"
			set something_different yes
			set_color $color_key
			echo -n "directory: "
			set_color $color_value
			echo -n $wd " "
		end

		if test $something_different = "yes"
			echo -e -n "\n\n "
		end
		set_color normal
		echo -e -n -s '> '

	end
end
