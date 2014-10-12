function git-commit-all --description 'git add all and commit. also push if user wants it (prompt). argument is commit comment.'
	if not set -q $argv
		echo 'Please enter a commit comment!'
	else
		git add --all
		git commit -m $argv
		echo 'Also wanna git push?'
		read --local --prompt 'Huh?' confirm
		switch $confirm
		case Yes yes Y y Ja ja J j
			git push
		case No no N n Nein nein
			echo 'Pf, okay, then do it yourself.'
		end
	end
end
