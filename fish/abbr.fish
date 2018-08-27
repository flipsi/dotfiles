abbr d      docker
abbr da     docker-compose start
abbr do     docker-compose stop
abbr dce    docker-compose exec
abbr dcl    docker-compose logs
abbr dcp    docker-compose pull
abbr dcu    docker-compose up
abbr fi     fzf_wrapper --find --ranger
abbr fl     fzf_wrapper --locate --ranger
abbr g      git
abbr ga     git add
abbr gaa    git add --all
abbr gas    git save
# abbr gap    git pop  # because of autocompletion, the following is better:
abbr gap    git rebase \(git rev-parse --abbrev-ref HEAD\) stash/
abbr gb     git branch
abbr gB     git branch --verbose --all
abbr gbd    git branch -d
abbr gbD    git branch -D
abbr gbm    git branch -m
abbr gc     git commit
abbr gca    git commit --amend
abbr gcl    git clone --recursive
abbr gd     git diff
abbr gda    git diff --cached
abbr gdc    git diff --cached
abbr ge     git checkout
abbr geb    git checkout -b
abbr gf     git fetch --prune
abbr gfm    git checkout --quiet --detach\; git fetch \(git remote \| head -n1\) master:master\; git checkout --quiet -
abbr gl     tig log
abbr glh    git --no-pager log -n 1
abbr gli    git --no-pager log -n 1 \| head -n 1 \| cut -d\" \" -f2 \| xsel --clipboard
abbr gm     git merge
abbr gmm    git merge master
abbr gp     git pull
abbr gpp    git pull
abbr gpu    git push
abbr gpuf   git push --force-with-lease
abbr gpuu   git push -u \(git remote \| head -n1\) \(git rev-parse --abbrev-ref HEAD\)
abbr gr     grep --with-filename --line-number --recursive --ignore-case --extended-regexp
abbr gra    git reset --abort
abbr grc    git reset --continue
abbr grh    git reset --hard
abbr grH    git reset HEAD~1
abbr grm    git rebase master
abbr gs     tig status
abbr gsa    git stash push
abbr gsi    git stash push --include-untracked
abbr gsp    git stash pop
abbr gst    git status
abbr gu     git submodule
abbr gup    git submodule update
abbr gus    git submodule status
abbr h      htop
abbr l      less
abbr ll     ls -lhF
abbr lll    ls -lhFa
abbr m      man
abbr ma     make apply
abbr mi     make init
abbr mip    make init plan
abbr mp     make plan
abbr mpa    make plan apply
abbr o      open
abbr p      pass
abbr pe     pass edit
abbr pg     pgrep
abbr pgp    pass git pull
abbr pgpu   pass git push
abbr pk     pkill
abbr rrm    rm -rf
abbr se     sudoedit
abbr s      systemctl status
abbr sa     systemctl start
abbr so     systemctl stop
abbr sr     systemctl restart
abbr t      trans :de
abbr te     trans de:en
abbr tf     trans de:fr
abbr u      unison
abbr v      vim
abbr x      xrandr
abbr xo     xrandr --output
abbr y      yaourt
abbr yi     yaourt -Qi
abbr yr     yaourt -R
abbr ys     yaourt -S
abbr ysi    yaourt -Si
abbr yu     yaourt -Syu
abbr yun    yaourt -Syu --noconfirm
abbr yua    yaourt -Syua
abbr yuan   yaourt -Syua --noconfirm
