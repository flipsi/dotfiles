set realname  = "Philipp Moers"
set from      = "soziflip@gmail.com"

#set folder    = "$my_muttdir/mail"
set mbox_type = Maildir
set spoolfile = "=gmail.com/INBOX"
set mbox      = "=gmail.com/INBOX"
set record    = ""  # gmail saves sent mail anyway
set postponed = "=gmail.com/Drafts/"
set trash     = "=gmail.com/Trash/"

set sendmail  = "/usr/bin/msmtp -a gmail.com"




# vim:syntax=muttrc
