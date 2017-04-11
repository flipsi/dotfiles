#! /usr/bin/env python2


# Get passwords from gpg encrypted files

# Prepare files with passwords for each account:
#   vim ~/.mutt/credentials/ACCOUNT
# Encrypt them with GPG:
#   gpg -e -r 'Philipp Moers <philipp.moers@mail.de>' ~/.mutt/credentials/ACCOUNT
# And get rid of the cleartext password files:
#   shred ~/.mutt/credentials/ACCOUNT; rm -f ~/.mutt/credentials/ACCOUNT



from os import environ, path
from subprocess import check_output

def get_password(account):
  account = path.basename(account)
  credentialfile = path.expanduser("~") + "/.mutt/credentials/%s.gpg" % account
  args = ["gpg", "--use-agent", "--quiet", "--batch", "-d", credentialfile]
  try:
    return check_output(args).strip()
  except CalledProcessError:
    return ""
