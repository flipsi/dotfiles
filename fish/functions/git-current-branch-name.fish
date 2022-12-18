function git-current-branch-name --description 'echo current branch name'
  git rev-parse --abbrev-ref HEAD
end
