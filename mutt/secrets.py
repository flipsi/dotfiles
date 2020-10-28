#! /usr/bin/env python

# Get credentials/secrets from gpg encrypted files

import argparse
import re
import os
from subprocess import call, check_call, check_output

encoding = "utf-8"


secrets_file = os.path.expanduser("~") + "/.config/mutt/secrets.gpg"

## One file for all in muttrc syntax (can additionally be sourced from mutt directly), like:
"""
# This file contains credentials for my email accounts and is meant to be encrypted with GnuPG

set my_00_email         = "philipp.moers@mail.com"
set my_00_name          = "Philipp Moers"
set my_00_username      = "philipp.moers@mail.com"
set my_00_password      = "top secret"

set my_01_email         = "soziflip@gmail.com"
set my_01_name          = "Philipp Moers"
set my_01_client_id     = "top secret"
set my_01_client_secret = "top secret"
set my_01_refresh_token = "top secret"

# [...]

# vim:ft=muttrc
"""





## One files per accountname (~/.mutt/credentials/<ACCOUNTNAME>)
def get_password_from_gpg_encrypted_file(accountname):
  accountname = os.path.basename(accountname)
  secrets_file = os.path.expanduser("~") + "/.mutt/credentials/%s.gpg" % accountname
  #  cli = ["gpg", "--use-agent", "--quiet", "--batch", "-d", secrets_file]
  cli = ["gpg", "--use-agent", "--quiet",  "-d", secrets_file]
  try:
    return check_output(cli).strip()
  except CalledProcessError:
    return ""



# if accountname given, returns dict with 'email', 'name' etc. as keys
# otherwise returns dict of dicts with accountname as keys
def get_secrets_from_gpg_encrypted_muttrc(accountname=False):
  global secrets_file
  account_indexes = {
    '00': 'philipp.moers@mail.de',
    '01': 'soziflip@gmail.com',
    '09': 'p.moers@ryte.com',
  }
  def parse_muttrc(muttrc):
    pattern = re.compile('^set my_(\d\d)_(\w*)\s*=\s*"(.*)"')
    dictionary = {}
    for line in muttrc:
      match = pattern.search(line)
      if match:
        index = match.group(1)
        key = match.group(2)
        value = match.group(3)
        acc_name = account_indexes.get(index)
        if acc_name is None:
            continue
        else:
          dictionary[acc_name] = dictionary.get(acc_name) or {}
          dictionary[acc_name][key] = value
    return dictionary

  cli = ["gpg", "--use-agent", "--quiet",  "-d", secrets_file]
  try:
    muttrc = check_output(cli).decode(encoding).splitlines()
    dictionary = parse_muttrc(muttrc)
    if accountname:
        return dictionary.get(accountname)
    else:
        return dictionary
  except CalledProcessError:
    return ""


def generate_oauth_access_token(user, client_id, client_secret, refresh_token):
  this_script_dir = os.path.dirname(os.path.realpath(__file__))
  oauth2_script = os.path.join(this_script_dir, 'oauth2.py')
  cli = [
    'python2',
    oauth2_script,
    f'--user={user}',
    f'--client_id={client_id}',
    f'--client_secret={client_secret}',
    f'--refresh_token={refresh_token}',
    '--generate_oauth2_token',
  ]
  """
  Access Token: ya29.a0AfH6SMBP8D4l5-bMZ2CoY6-tdiXVS6l1uGI4N_dpwYtUnLu43vtHnImaBj4gMnDByTBlSqoSTOUim8mkqAtwqAtQ2QjqqfqUMkc90phJoBzSFfgaaEZCIld4tYkyobYGGDsa5pu9XVVX8_-Fdgs9AdIDAOL7oP3gGTZR
  Access Token Expiration Seconds: 3599
  """
  try:
    output = check_output(cli).decode(encoding).splitlines()
    pattern = re.compile('^Access Token: (.*)')
    for line in output:
      match = pattern.search(output[0])
      if match:
        return match.group(1)
  except CalledProcessError:
    return ""



def get_password_from_password_store(accountname):
  accountname = os.path.basename(accountname)
  pass_path = {
    'gmail.com': 'google/soziflip',
    'mail.de': 'mail.de/philipp.moers@mail.de',
    'onpage.org': 'google/philipp.moers@onpage.org',
    'web.de-keinschweinehund': 'web.de/keinschweinehund@web.de',
    'web.de-pmoers': 'web.de/pmoers@web.de',
  }.get(accountname)
  cli = ["pass", pass_path]
  try:
    return check_output(cli).strip()
  except CalledProcessError:
    return ""



def edit_secrets_file(secrets_file):
  gpg_recipient = 'Philipp Moers <soziflip@gmail.com>'
  check_call(['touch', secrets_file])
  temporary_file = check_output(['mktemp', '--dry-run']).decode(encoding).splitlines()[0]
  check_call(['gpg', '--output', temporary_file, '--decrypt', secrets_file])
  check_call(['chmod', '600', temporary_file])
  editor = os.environ.get('EDITOR') or 'nano'
  check_call([editor, temporary_file])
  check_call(['gpg', '--yes', '--output', secrets_file, '--recipient', gpg_recipient, '--encrypt', temporary_file])
  call(['shred', temporary_file])
  check_call(['rm', temporary_file])



def get_secret(accountname, oauth=False):
  secrets = get_secrets_from_gpg_encrypted_muttrc(accountname)
  if oauth:
    client_id = secrets['client_id']
    client_secret = secrets['client_secret']
    refresh_token = secrets['refresh_token']
    return generate_oauth_access_token(accountname, client_id, client_secret, refresh_token)
  else:
    return secrets["password"]



def main():
  global secrets_file

  parser=argparse.ArgumentParser(description="Get credentials for email services")
  parser.add_argument("--mode", help="One of [get_secret, edit_secrets_file]. Defaults to get_secret")
  parser.add_argument("--account", help="name of the account for get_secret mode")
  parser.add_argument("--oauth", action="store_true", help="Generate OAuth2 access token")


  args = parser.parse_args()
  mode = args.mode or 'get_secret'
  if mode == "get_secret":
    if not args.account:
      print("missing argument --account")
      os._exit(1)
    else:
      credential = get_secret(args.account, args.oauth)
      print(credential)
  elif mode == 'edit_secrets_file':
    edit_secrets_file(secrets_file)
  else:
      print(f"mode {args.mode} not implemented")
      os._exit(1)


if __name__ == '__main__':
  main()
