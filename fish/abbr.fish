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
abbr gb     git branch --verbose --all
abbr gbd    git branch -d
abbr gbD    git branch -D
abbr gbm    git branch -m
abbr gc     git commit
abbr gca    git commit --amend
abbr gd     git diff
abbr gda    git diff --cached
abbr gdc    git diff --cached
abbr ge     git checkout
abbr geb    git checkout -b
abbr gf     git fetch --prune
abbr gl     tig log
abbr glh    git --no-pager log -n 1
abbr gli    git --no-pager log -n 1 \| head -n 1 \| cut -d\" \" -f2 \| xsel --clipboard
abbr go     git clone --recursive
abbr gpp    git pull
abbr gpu    git push -u
abbr gpU    git push
abbr gr     grep --with-filename --line-number --recursive --ignore-case --extended-regexp
abbr gs     git status
abbr gsa    git stash save
abbr gsi    git stash save --include-untracked
abbr gsp    git stash pop
abbr gu     git submodule
abbr gup    git submodule update
abbr gus    git submodule status
abbr h      htop
abbr l      less
abbr ll     ls -lhF
abbr lll    ls -lhFa
abbr m      man
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
abbr t      translate-shell :de
abbr te     translate-shell de:en
abbr tf     translate-shell de:fr
abbr u      unison
abbr v      vim
abbr x      xrandr
abbr xo     xrandr --output
abbr y      yaourt
abbr yr     yaourt -R
abbr ys     yaourt -S
abbr yu     yaourt -Syu --noconfirm
abbr yua    yaourt -Syua --noconfirm
