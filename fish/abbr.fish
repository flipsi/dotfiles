if test (echo $FISH_VERSION | cut -d . -f 1) -ge 3
    set args --add --global
else
    set args --add
end

abbr $args agl    ag -l
abbr $args bak    backup-file.sh
abbr $args ca     gcalcli
abbr $args cdi    cd_interactively
abbr $args cdi.   cd_interactively .
abbr $args cdir   cd_interactively /
abbr $args cf     cifuzz
abbr $args ck     ckit
abbr $args cku    ckit server up -d -r
abbr $args ckd    ckit server down
abbr $args d      docker
abbr $args dl     docker logs -n 60
abbr $args dlf    docker logs -n 60 -f
abbr $args dps    docker ps
abbr $args dr     docker run
abbr $args do     docker stop
abbr $args dc     docker-compose
abbr $args dca    docker-compose up -d
abbr $args dce    docker-compose exec
abbr $args dco    docker-compose stop
abbr $args dcl    docker-compose logs
abbr $args dclf   docker-compose logs -f
abbr $args dcp    docker-compose pull
abbr $args du     du -sh
abbr $args es     echo \$status
abbr $args fi     fzf_wrapper --find --joshuto
abbr $args fl     fzf_wrapper --locate --joshuto
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
abbr $args gcm    git commit -m
abbr $args gcmi   git commit -m \'Initial commit\'
abbr $args gcl    git clone --recursive
abbr $args gcp    git cherry-pick
abbr $args gcf    git clean -f -d
abbr $args gd     git diff
abbr $args gda    git diff --cached
abbr $args gdc    git diff --cached
abbr $args ge     git checkout
abbr $args ge-    git checkout -
abbr $args gem    git checkout \(git-main-or-master\)
abbr $args geb    git checkout -b
abbr $args gf     git fetch --prune
abbr $args gfm    git checkout --quiet --detach\; git fetch \(git remote \| head -n1\) \(git-main-or-master\):\(git-main-or-master\)\; git checkout --quiet -
abbr $args ghpr   gh pr view --web \|\| gh pr create --web
abbr $args gi     git init
abbr $args gla    glab
abbr $args glp    glab pipeline ci view
abbr $args glm    glab mr
abbr $args glml   glab mr list --assignee @me \&\& glab mr list --reviewer @me
abbr $args glmv   glab mr view --web
abbr $args glmc   glab mr create --web --fill
abbr $args gll    tig log
abbr $args gl     tig
abbr $args glh    git --no-pager log -n 1
abbr $args gli    git --no-pager log -n 1 \| head -n 1 \| cut -d\" \" -f2 \| xsel --clipboard
abbr $args gm     git merge
abbr $args gma    git merge --abort
abbr $args gmb    git merge-base \(git-current-branch-name\) \(git-main-or-master\)
abbr $args gmm    git merge \(git-main-or-master\)
abbr $args gmt    git mergetool
abbr $args gpl    git pull
abbr $args gps    git push
abbr $args gpf    git push --force-with-lease
abbr $args gpu    git push -u \(git remote \| head -n1\) \(git-current-branch-name\)
abbr $args gre    grep --with-filename --line-number --recursive --ignore-case --extended-regexp
abbr $args gri    git revise
abbr $args gr     git rebase
abbr $args grm    git rebase \(git-main-or-master\)
abbr $args gra    git rebase --abort
abbr $args grc    git rebase --continue
abbr $args gro    git rebase --onto \(git-main-or-master\) HEAD~1 # rebase last 1 commit in current branch on master (after original branch has been squashed/rebased)
abbr $args grh    git reset --hard
abbr $args grr    git reset --hard \(git remote \| head -n1\)/\(git-current-branch-name\)
abbr $args grH    git reset HEAD~1
abbr $args grl    git revert HEAD
abbr $args gs     tig status
abbr $args gta    git stash push --include-untracked
abbr $args gtp    git stash pop
abbr $args gst    git status
abbr $args gu     git submodule
abbr $args gup    git submodule update
abbr $args gus    git submodule status
abbr $args gw     git worktree
abbr $args gwa    git worktree add -b
abbr $args gwl    git worktree list
abbr $args gwr    git worktree remove
abbr $args h      bpytop \|\| htop
abbr $args kc     kubectl
abbr $args j      joshuto
abbr $args l      less
abbr $args ll     exa_or_ls -l
abbr $args lll    exa_or_ls -l -a
abbr $args lt     exa_or_tree -l
abbr $args m      man
abbr $args ma     make apply
abbr $args mi     make init
abbr $args mip    make init plan
abbr $args mkd    mkdir_cd
abbr $args mp     make plan
abbr $args mpa    make plan apply
abbr $args nv     nvlc
abbr $args ns     netctl status
abbr $args na     sudo netctl start
abbr $args no     sudo netctl stop
abbr $args nr     sudo netctl restart
abbr $args o      open
abbr $args p      pass
abbr $args pe     pass edit
abbr $args pg     pgrep
abbr $args pn     pass generate --no-symbols --clip
abbr $args pgpl   pass git pull
abbr $args pgps   pass git push
abbr $args pk     pkill
abbr $args r      ranger
abbr $args ra     radio start --random
abbr $args ro     radio stop
abbr $args rs     radio status
abbr $args rv     radio volume
abbr $args rrm    rm -rf
abbr $args s      systemctl status --no-pager
abbr $args sa     sudo systemctl start
abbr $args se     sudoedit
abbr $args sj     journalctl --no-pager -n15 -u
abbr $args so     sudo systemctl stop
abbr $args sr     sudo systemctl restart
abbr $args t      trans :de
abbr $args te     trans de:en
abbr $args tf     trans de:fr
abbr $args u      unison
abbr $args v      nvim
# abbr $args vs     vim --servername \(basename \(pwd\)\)
abbr $args vs     nvim --listen \(basename \(pwd\)\)
abbr $args x      xrandr
abbr $args xi     startx ~/.xinitrc
abbr $args xo     xrandr --output
abbr $args y      yay
abbr $args yc     yay -Yc
abbr $args yi     yay -Qi
abbr $args yr     yay -R
abbr $args ys     yay -S
abbr $args ysi    yay -Si
abbr $args yu     yay -Syu
abbr $args yy     yay -Syu --noconfirm \| tee os/yay-update-(date +%Y-%m-%d-%H-%M).log
abbr $args --set-cursor=URL yt  yt-dlp \'URL\'
abbr $args --set-cursor=URL yta yt-dlp --extract-audio --audio-quality 0 --audio-format best \'URL\'
