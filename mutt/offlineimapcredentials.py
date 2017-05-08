#! /usr/bin/env python2

# Get passwords from gpg encrypted files



from os import environ, path
from subprocess import check_output



###########################
# OPTION 1: OWN GPG FILES #
###########################

## Prepare files with passwords for each account:
##   vim ~/.mutt/credentials/ACCOUNT
## Encrypt them with GPG:
##   gpg -e -r 'Philipp Moers <soziflip@gmail.com>' ~/.mutt/credentials/ACCOUNT
## And get rid of the cleartext password files:
##   shred ~/.mutt/credentials/ACCOUNT; rm -f ~/.mutt/credentials/ACCOUNT


def get_password(account):
  account = path.basename(account)
  credentialfile = path.expanduser("~") + "/.mutt/credentials/%s.gpg" % account
  #  args = ["gpg", "--use-agent", "--quiet", "--batch", "-d", credentialfile]
  args = ["gpg", "--use-agent", "--quiet",  "-d", credentialfile]
  try:
    return check_output(args).strip()
  except CalledProcessError:
    return ""



##############################
# OPTION 2: PASSWORD STORAGE #
##############################

#  def get_password(account):
  #  account = path.basename(account)
  #  passPath = {
    #  'onpage.org': 'google/philipp.moers@onpage.org',
    #  'mail.de': 'mail.de/philipp.moers@mail.de',
    #  'gmail.com': 'google/soziflip',
    #  'web.de-pmoers': 'web.de/pmoers@web.de',
    #  'web.de-keinschweinehund': 'web.de/keinschweinehund@web.de',
  #  }.get(account)
  #  #  args = ["gpg", "--use-agent", "--quiet", "--batch", "-d", credentialfile]
  #  args = ["pass", passPath]
  #  try:
    #  return check_output(args).strip()
  #  except CalledProcessError:
    #  return ""
