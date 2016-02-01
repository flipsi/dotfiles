function fuck
	set -l exit_code $status
set -l fucked_up_command $history[1]
env TF_ALIAS=fuck PYTHONIOENCODING=utf-8 thefuck $fucked_up_command | read -l unfucked_command
if [ "$unfucked_command" != !! ]
eval $unfucked_command
if test $exit_code -ne 0
history --delete $fucked_up_command
history --merge ^/dev/null
return 0
end
end
end
