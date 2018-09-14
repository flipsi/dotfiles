# this is a collection of useful commands that might get lost if not written down

curl wttr.in # weather report
date +%s # unix timestamp
git branch --merged | egrep "(feature|hotfix)" | xargs git branch -d # delete merged branches
git checkout --quiet --detach; git fetch (git remote | head -n1) master:master; git checkout --quiet -
