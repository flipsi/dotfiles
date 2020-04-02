function weather --description 'show weather forecast'

	set	default_location 'munich'

	set location $argv[1]
	if test -z $location
		set location $default_location
	end

	curl wttr.in/$location

end
