# Branch Is The New Stash

Idea: Use branches instead of stashes

Inspired by: [this blog post](https://codingkilledthecat.wordpress.com/2012/04/27/git-stash-pop-considered-harmful/)


## Benefits

- better handling of merge conflicts
- better naming and description in commit messages
- stash is saved the context where it was created
- 'chains of stashes' are possible
- flexibility: you can rebase/cherry-pick/merge/...
- flexibility: stash only certain dirty changes, not all
- push to and pull from remotes
- no stack semantic (not appropriate for me)
- it's harder to forget about branches that about stashes
- you don't need to learn the stashing concept and syntax, and you are probably
  familiar with the branching concept

## HOW TO

- instead of `git stash save $NAME`:
  use `git add $FILE && git checkout -b stash/$NAME && git commit && git checkout -`

- instead of `git stash pop <stash with $NAME>`
  use `git rebase $(git rev-parse --abbrev-ref HEAD) stash/$NAME`

- instead of `git stash apply <stash with $NAME>`
  use `git checkout -b stash/$NAME/2 && git cherry-pick stash/$NAME`
