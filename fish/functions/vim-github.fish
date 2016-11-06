function vim-github --description 'Start vim with my latest vimrc from github'
	bash -c "vim -u <(curl https://raw.githubusercontent.com/sflip/dotfiles/master/vim/vimrc) $argv"
end
