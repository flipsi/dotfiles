function weather
	wego -forecast-api-key (pass darksky.net/soziflip+darksky@gmail.com | grep api-key | cut -d' ' -f2) -l "48.1442327,11.5748727"
end
