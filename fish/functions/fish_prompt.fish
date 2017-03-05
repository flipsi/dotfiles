
# Fish git prompt
set __fish_git_prompt_showdirtystate 'yes'
set __fish_git_prompt_showstashstate 'no' # does not work?
set __fish_git_prompt_showupstream 'yes'
set __fish_git_prompt_color_branch yellow
set __fish_git_prompt_char_dirtystate '⚡'
set __fish_git_prompt_char_stagedstate '→'
set __fish_git_prompt_char_stashstate '' # '↩' # workaround for showstashstate
set __fish_git_prompt_char_upstream_ahead '↑'
set __fish_git_prompt_char_upstream_behind '↓'

# some colors
set __fish_my_color_gray_dark       '#4C4C4C'
set __fish_my_color_gray_middle     '#636363'
set __fish_my_color_gray_bright     '#878787'
set __fish_my_color_red             '#FF8787'
set __fish_my_color_green           '#8ADE33'
set __fish_my_color_blue            '#629FCF'

# accent colors
set __fish_my_color_accent          '#00AFAF'
set __fish_my_color_accent_dark     '#005F5F'



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
		set_color --bold $__fish_my_color_accent_dark
		echo -n $USER'@'

		# host
        set_color --bold $__fish_my_color_accent_dark
		echo -n $__fish_prompt_hostname
		set_color $__fish_my_color_accent_dark
		echo -n ' '

		# working directory
		set wd (pwd)
        if set -q RANGER_LEVEL
            set_color --bold $__fish_my_color_gray_bright
        else
            set_color --italics $__fish_my_color_gray_dark
        end
		echo -n $wd

		# git
		set_color --bold normal
		__fish_git_prompt

		# prompt (on newline)
		set_color --bold normal
		echo -e -n -s '\n> '

	end
end
