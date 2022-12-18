function git-main-or-master --description 'echo main if branch exists or master otherwise'
    if git rev-parse --verify main >/dev/null 2>&1
        echo 'main'
    else
        echo 'master'
    end
end
