function fzf_command_chooser
  cat ~/.config/fish/commands*.fish | sed -E '/^#|^\s+$/d' | fzf +s --tiebreak=index --toggle-sort=ctrl-r $FZF_DEFAULT_OPTS $FZF_REVERSE_ISEARCH_OPTS -q (commandline) | read -z select
  if not test -z $select
	commandline -rb (builtin string trim "$select")
	commandline -f repaint
  end
end

