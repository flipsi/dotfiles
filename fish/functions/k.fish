function k --description 'set my own keyboardlayout. (see keyboard.sh)'
	setxkbmap -layout de
	xmodmap ~/.XmodmapFlipFull
end
