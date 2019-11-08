if test (echo $FISH_VERSION | cut -d . -f 1) -ge 3
    set args --add --global
else
    set args --add
end

abbr $args ca     gcalcli
abbr $args cdi    cd_interactively
abbr $args cdi.   cd_interactively .
abbr $args cdir   cd_interactively /
abbr $args d      docker
abbr $args da     docker-compose up -d
abbr $args do     docker-compose stop
abbr $args dce    docker-compose exec
abbr $args dcl    docker-compose logs
abbr $args dclf   docker-compose logs -f
abbr $args dcp    docker-compose pull
abbr $args fi     fzf_wrapper --find --ranger
abbr $args fl     fzf_wrapper --locate --ranger
abbr $args g      git
abbr $args ga     git add
abbr $args gaa    git add --all
abbr $args gas    git save
# abbr $args gap    git pop  # because of autocompletion, the following is better:
abbr $args gap    git rebase \(git rev-parse --abbrev-ref HEAD\) stash/
abbr $args gb     git branch
abbr $args gB     git branch --verbose --all
abbr $args gbd    git branch -d
abbr $args gbD    git branch -D
abbr $args gbm    git branch -m
abbr $args gc     git commit
abbr $args gca    git commit --amend
abbr $args gcl    git clone --recursive
abbr $args gd     git diff
abbr $args gda    git diff --cached
abbr $args gdc    git diff --cached
abbr $args ge     git checkout
abbr $args geb    git checkout -b
abbr $args gf     git fetch --prune
abbr $args gfm    git checkout --quiet --detach\; git fetch \(git remote \| head -n1\) master:master\; git checkout --quiet -
abbr $args gl     tig
abbr $args glh    git --no-pager log -n 1
abbr $args gli    git --no-pager log -n 1 \| head -n 1 \| cut -d\" \" -f2 \| xsel --clipboard
abbr $args gm     git merge
abbr $args gmm    git merge master
abbr $args gp     git pull
abbr $args gpp    git pull
abbr $args gpu    git push
abbr $args gpuf   git push --force-with-lease
abbr $args gpuu   git push -u \(git remote \| head -n1\) \(git rev-parse --abbrev-ref HEAD\)
abbr $args gr     grep --with-filename --line-number --recursive --ignore-case --extended-regexp
abbr $args gra    git reset --abort
abbr $args grc    git reset --continue
abbr $args grh    git reset --hard
abbr $args grH    git reset HEAD~1
abbr $args grm    git rebase master
abbr $args gs     tig status
abbr $args gsa    git stash push
abbr $args gsi    git stash push --include-untracked
abbr $args gsp    git stash pop
abbr $args gst    git status
abbr $args gu     git submodule
abbr $args gup    git submodule update
abbr $args gus    git submodule status
abbr $args h      htop
abbr $args l      less
abbr $args ll     ls -lhF
abbr $args lll    ls -lhFa
abbr $args m      man
abbr $args ma     make apply
abbr $args mi     make init
abbr $args mip    make init plan
abbr $args mkd    mkdir
abbr $args mp     make plan
abbr $args mpa    make plan apply
abbr $args o      open
abbr $args p      pass
abbr $args pe     pass edit
abbr $args pg     pgrep
abbr $args pn     pass generate --no-symbols --clip
abbr $args pgp    pass git pull
abbr $args pgpu   pass git push
abbr $args pk     pkill
abbr $args rrm    rm -rf
abbr $args se     sudoedit
abbr $args r      ranger
abbr $args s      systemctl status
abbr $args sa     systemctl start
abbr $args so     systemctl stop
abbr $args sr     systemctl restart
abbr $args t      trans :de
abbr $args te     trans de:en
abbr $args tf     trans de:fr
abbr $args u      unison
abbr $args v      vim
abbr $args vs     vim --servername \(basename \(pwd\)\)
abbr $args x      xrandr
abbr $args xo     xrandr --output
abbr $args y      yay
abbr $args yc     yay -Yc
abbr $args yi     yay -Qi
abbr $args yr     yay -R
abbr $args ys     yay -S
abbr $args ysi    yay -Si
abbr $args yu     yay -Syu
abbr $args yuy    yay -Syu --noconfirm
