#!/bin/bash

# Author: "Philipp Moers" <soziflip@gmail.com>

repo_url='https://github.com/sflip/dotfiles'


function print_help_msg() {
    cat <<-EOF
sflip's dotfiles - installation script
This script installs my configuration on remote hosts (ssh).
It git clones ${repo_url} to ~/dotfiles and runs the 'install.sh' script, or git pulls.
The list of remote hosts is read from ~/.ssh/known_hosts.
~/.ssh/config should be configured correctly for logins and such.

Usage: install-remote.sh

    OPTIONS:
    -h       | --help             Don't do anything, just print this help message.
    -d       | --dry-run          Don't do anything, just print what would happen.
    -r=regex | --regex=pattern    All hosts must match <pattern>.
    -b=host  | --blacklist=host   Skip <host>. Can be provided multiple times.
    -o=host  | --only=host        Only run on <host>. Overwrites --regex and --blacklist.
    -c=rev   | --checkout=rev     Checkout a specific revision (branch or commit).
    -i       | --install          Also run './install.sh --all' after pull, not only after clone.
                                  Should be done to update symlinks.

EOF
}


for i in "$@"
do
  case $i in
    -h|--help)
      print_help_msg;
      exit 0
      shift
      ;;
    -d|--dry-run)
      dry_run=true
      shift
      ;;
    -r=*|--regex=*)
      host_regex="${i#*=}"
      shift
      ;;
    -b=*|--blacklist=*)
      blacklist+=("${i#*=}")
      shift
      ;;
    -o=*|--only=*)
      only_host=("${i#*=}")
      shift
      ;;
    -c=*|--checkout=*)
      checkout_revision="${i#*=}"
      shift
      ;;
    -i|--install)
      run_install_script=true
      shift
      ;;
    *)
      echo unknown option!
      ;;
  esac
done




# abort if not not one of those users
users='(philipp.moers|sflip)$'

# log verbose output to some temporary file (in addition to stdout)
logfile=$(mktemp -p /tmp dotfiles-install-remote-XXXX.log)




if [[ -z ${host_regex} ]]; then
    host_regex='.*'
fi

blacklist_regex='(somehostthatprobablyneverexiststobuildthisshittyregexmanthisissonerdyidie'
for x in "${blacklist[@]}"; do :
    blacklist_regex+="|${x}"
done
blacklist_regex+=')'

if [[ -z ${only_host} ]]; then
    hosts=($(\
        cat ~/.ssh/known_hosts \
        | cut -d ' ' -f1 \
        | sed 's/,.*//' \
        | grep -E    "${host_regex}" \
        | grep -E -v "${blacklist_regex}"
    ))
else
    hosts=(${only_host})
fi




function processHost() {
    local host="$1"
    echo -e '\n' >> ${logfile}
    echo -n "Processing ${host} ... " | tee --append ${logfile} ; echo >> ${logfile}
    if  true \
        && nc -z "${host}" 22 2>/dev/null \
        && $(ssh -o PasswordAuthentication=no ${host} exit 2>/dev/null) \
    ; then
        if  true \
            && $(ssh ${host} 'which git >/dev/null') \
            && echo $(ssh ${host} whoami) | grep -E ${users} >/dev/null \
        ; then
            if ssh ${host} 'test -d dotfiles'; then
                echo -n 'Updating ... ' | tee --append ${logfile} ; echo >> ${logfile}
                if [[ ${dry_run} != true ]]; then
                    updateDotfiles ${host}
                fi
            else
                echo -n 'Installing ... ' | tee --append ${logfile} ; echo >> ${logfile}
                if [[ ${dry_run} != true ]]; then
                    installDotfiles ${host}
                fi
            fi
        else
            echo -n 'No git installed or strange user or something. ' | tee --append ${logfile} ; echo >> ${logfile}
        fi
    else
        echo -n 'Seems down or not reachable via ssh without password. ' | tee --append ${logfile} ; echo >> ${logfile}
    fi
    echo 'Done.' | tee --append ${logfile} ; echo >> ${logfile}
}


function installDotfiles() {
    local host="$1"
    ssh ${host} "git clone ${repo_url} dotfiles" >> ${logfile} 2>&1
    if [[ -n ${checkout_revision} ]]; then
        ssh ${host} "cd dotfiles; git checkout ${checkout_revision}" >> ${logfile} 2>&1
    fi
    ssh ${host} "dotfiles/install.sh --all" >> ${logfile} 2>&1
}

function updateDotfiles() {
    local host="$1"
    # check git version, because git pull will fail with 'push.default = simple' before 1.7.11
    if [[ $(echo $(ssh ${host} git --version | sed 's/.* \(.\..\).*/\1/') '< 1.8' | bc) -eq 1 ]]; then
        echo -n '(old git) '
        # ssh ${host} 'cd dotfiles; git pull -c push.default=current' >> ${logfile} 2>&1 # does not work :(
        # ssh ${host} git config --global push.default current # cannot pull because of conflicts :(
        ssh ${host} 'if [[ -L ~/.gitconfig ]]; then rm ~/.gitconfig; cd dotfiles; git checkout -- git/gitconfig; cp git/gitconfig ~/.gitconfig; git config --global push.default current; fi ' >> ${logfile} 2>&1
        ssh ${host} 'cd dotfiles; git pull' >> ${logfile} 2>&1
    else
        ssh ${host} 'cd dotfiles; git stash save remote-update' >> ${logfile} 2>&1
        ssh ${host} 'cd dotfiles; git pull' >> ${logfile} 2>&1
        ssh ${host} 'cd dotfiles; git stash pop remote-update' | tee --append ${logfile} ; echo >> ${logfile} 2>&1
    fi
    if [[ -n ${checkout_revision} ]]; then
        ssh ${host} "cd dotfiles; git checkout ${checkout_revision}" >> ${logfile} 2>&1
    fi
    if [[ ${run_install_script} = true ]]; then
        ssh ${host} "dotfiles/install.sh --all" >> ${logfile} 2>&1
    fi
}



if [[ ${dry_run} = true ]]; then
    echo "Doing a dry run (just check for hosts and existing dotfiles)."
fi
for host in "${hosts[@]}"; do
    processHost "${host}"
done

echo log written to ${logfile}
