#!/bin/zsh
##
## Script: ~/.mutt/sendmail_wrapper.zsh
##
## Source: http://wiki.mutt.org/?ConfigTricks/CheckAttach
##
## muttrc should most probably contain this line:
## set sendmail = "~/.mutt/sendmail_wrapper.zsh /usr/bin/sendmail -oem -oi"

## Attachment keywords that the message body will be searched for:
KEYWORDS='attach|anhang|anhaenge|anhänge|angehaengt|angehangen|anbei|angehängt'
ERRORMESSAGE="Attachment missing!? (Use \"X-attached: none\" to override) Send mail anyway? "

## Check that sendmail or other program is supplied as first argument.
if [ ! -x "$1" ]
then
    echo "Usage: $0 </path/to/mailprog> <args> ..."
    echo "e.g.: $0 /usr/sbin/sendmail -oem -oi"
    exit 2
fi

## Save msg in file to re-use it for multiple tests.
TMPFILE=`mktemp -t mutt_checkattach.XXXXXX` || exit 2
cat > "$TMPFILE"

## Define test for multipart message.
function multipart {
    grep -q '^Content-Type: multipart' "$TMPFILE"
}

## Define test for keyword search.
function word-attach {
    grep -v '^>' "$TMPFILE" | grep -E -i -q "$KEYWORDS"
}

## Header override.
function header-override {
    grep -i -E "^X-attached: none$" "$TMPFILE"
}

function interactive-ask {
  # disable globbing
  set -f
  # try to get stdin/stdout/stderr from parent process
  PID_cur=$$
  TTY_cur=$(ps h -o tty -p ${PID_cur})
  while ! tty > /dev/null
  do
    PID_cur=$(cut -f4 -d' ' /proc/${PID_cur}/stat)
    TTY_cur=$(ps h -o tty -p ${PID_cur})
    TTY_use="/dev/${TTY_cur}"
    if [ -e ${TTY_use} ]
    then
      exec 0</dev/${TTY_cur} 1> /dev/${TTY_cur} 2>/dev/null
    fi
  done
  # reset terminal settings to current state when exit
  saved_tty_settings=$(stty -g)
  trap '
  printf "\r"; tput ed; tput rc
  printf "/" >&3
  stty "$saved_tty_settings"
  exit
  ' INT TERM

  # put the terminal in cooked mode. Set eof to <return> so that pressing
  # <return> doesn't move the cursor to the next line. Disable <Ctrl-Z>
  stty icanon echo -ctlecho crterase eof '^M' intr '^G' susp ''

  set $(stty size) # retrieve the size of the screen
  tput sc          # save cursor position
  tput cup "$1" 0  # go to last line of the screen
  tput ed          # clear and write prompt
  tput sgr0

  # print message
  printf ${ERRORMESSAGE}

  # read from the terminal. We can't use "read" because, there won't be
  # any NL in the input as <return> is eof.
  answer=$(dd count=1 2>/dev/null)

  # fix the terminal
  printf '\r'; tput ed; tput rc
  stty "${saved_tty_settings}"

  # apply return code
  if [ "${answer}" = "y" ]
  then
    return 0
  else
    return 1
  fi  
}

## FINAL DECISION:
if multipart || ! word-attach || header-override || interactive-ask; then
    "$@" < "$TMPFILE"
    EXIT_STATUS=$?
else
  EXIT_STATUS=1
fi

## Delete the temporary file.
rm -f "$TMPFILE"

## That's all folks.
exit $EXIT_STATUS
