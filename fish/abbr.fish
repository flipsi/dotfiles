abbr --add --global ca     gcalcli
abbr --add --global cdi    cd_interactively
abbr --add --global cdi.   cd_interactively .
abbr --add --global cdir   cd_interactively /
abbr --add --global d      docker
abbr --add --global da     docker-compose up -d
abbr --add --global do     docker-compose stop
abbr --add --global dce    docker-compose exec
abbr --add --global dcl    docker-compose logs
abbr --add --global dclf   docker-compose logs -f
abbr --add --global dcp    docker-compose pull
abbr --add --global fi     fzf_wrapper --find --ranger
abbr --add --global fl     fzf_wrapper --locate --ranger
abbr --add --global g      git
abbr --add --global ga     git add
abbr --add --global gaa    git add --all
abbr --add --global gas    git save
# abbr --add --global gap    git pop  # because of autocompletion, the following is better:
abbr --add --global gap    git rebase \(git rev-parse --abbrev-ref HEAD\) stash/
abbr --add --global gb     git branch
abbr --add --global gB     git branch --verbose --all
abbr --add --global gbd    git branch -d
abbr --add --global gbD    git branch -D
abbr --add --global gbm    git branch -m
abbr --add --global gc     git commit
abbr --add --global gca    git commit --amend
abbr --add --global gcl    git clone --recursive
abbr --add --global gd     git diff
abbr --add --global gda    git diff --cached
abbr --add --global gdc    git diff --cached
abbr --add --global ge     git checkout
abbr --add --global geb    git checkout -b
abbr --add --global gf     git fetch --prune
abbr --add --global gfm    git checkout --quiet --detach\; git fetch \(git remote \| head -n1\) master:master\; git checkout --quiet -
abbr --add --global gl     tig
abbr --add --global glh    git --no-pager log -n 1
abbr --add --global gli    git --no-pager log -n 1 \| head -n 1 \| cut -d\" \" -f2 \| xsel --clipboard
abbr --add --global gm     git merge
abbr --add --global gmm    git merge master
abbr --add --global gp     git pull
abbr --add --global gpp    git pull
abbr --add --global gpu    git push
abbr --add --global gpuf   git push --force-with-lease
abbr --add --global gpuu   git push -u \(git remote \| head -n1\) \(git rev-parse --abbrev-ref HEAD\)
abbr --add --global gr     grep --with-filename --line-number --recursive --ignore-case --extended-regexp
abbr --add --global gra    git reset --abort
abbr --add --global grc    git reset --continue
abbr --add --global grh    git reset --hard
abbr --add --global grH    git reset HEAD~1
abbr --add --global grm    git rebase master
abbr --add --global gs     tig status
abbr --add --global gsa    git stash push
abbr --add --global gsi    git stash push --include-untracked
abbr --add --global gsp    git stash pop
abbr --add --global gst    git status
abbr --add --global gu     git submodule
abbr --add --global gup    git submodule update
abbr --add --global gus    git submodule status
abbr --add --global h      htop
abbr --add --global l      less
abbr --add --global ll     ls -lhF
abbr --add --global lll    ls -lhFa
abbr --add --global m      man
abbr --add --global ma     make apply
abbr --add --global mi     make init
abbr --add --global mip    make init plan
abbr --add --global mkd    mkdir
abbr --add --global mp     make plan
abbr --add --global mpa    make plan apply
abbr --add --global o      open
abbr --add --global p      pass
abbr --add --global pe     pass edit
abbr --add --global pg     pgrep
abbr --add --global pgp    pass git pull
abbr --add --global pgpu   pass git push
abbr --add --global pk     pkill
abbr --add --global rrm    rm -rf
abbr --add --global se     sudoedit
abbr --add --global r      ranger
abbr --add --global s      systemctl status
abbr --add --global sa     systemctl start
abbr --add --global so     systemctl stop
abbr --add --global sr     systemctl restart
abbr --add --global t      trans :de
abbr --add --global te     trans de:en
abbr --add --global tf     trans de:fr
abbr --add --global u      unison
abbr --add --global v      vim
abbr --add --global vs     vim --servername \(basename \(pwd\)\)
abbr --add --global x      xrandr
abbr --add --global xo     xrandr --output
abbr --add --global y      yay
abbr --add --global yc     yay -Yc
abbr --add --global yi     yay -Qi
abbr --add --global yr     yay -R
abbr --add --global ys     yay -S
abbr --add --global ysi    yay -Si
abbr --add --global yu     yay -Syu
abbr --add --global yun    yay -Syu --noconfirm
