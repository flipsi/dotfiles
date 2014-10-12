function lock_and_suspend --description 'lock computer and go to sleep'
	gnome-screensaver-command --lock
and sudo pm-suspend
end
