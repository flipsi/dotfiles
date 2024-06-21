#! /usr/bin/env python

# Get credentials/secrets from gpg encrypted files

import argparse
import re
import os
import json
from subprocess import run, CalledProcessError

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
    result = run(cli, capture_output=True)
    return result.stdout.strip()
  except CalledProcessError:
    return ""



# if accountname given, returns dict with 'email', 'name' etc. as keys
# otherwise returns dict of dicts with accountname as keys
def get_secrets_from_gpg_encrypted_muttrc(accountname=False):
  global secrets_file
  account_indexes = {
    '00': 'philipp.moers@mail.de',
    '01': 'soziflip@gmail.com',
    '02': 'mail@philippmoers.de',
    '03': 'valentina@philippmoers.de',
  }
  def parse_muttrc(muttrc):
    pattern = re.compile('^set my_(\\d\\d)_(\\w*)\\s*=\\s*"(.*)"')
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
    result = run(cli, capture_output=True)
    muttrc = result.stdout.decode(encoding).splitlines()
    dictionary = parse_muttrc(muttrc)
    if accountname:
        return dictionary.get(accountname)
    else:
        return dictionary
  except CalledProcessError:
    return ""


def get_or_fetch_oauth_access_token(accountname):
  this_script_dir = os.path.dirname(os.path.realpath(__file__))
  oauth2_script = os.path.join(this_script_dir, 'curl_google_oauth', 'bearer-refresh.pl')
  datadir = os.path.join(os.path.expanduser('~/.local/share/mail_auth/'), accountname)
  token_path = os.path.join(datadir, 'token.json')
  try:
    run([oauth2_script, '--quiet', '--datadir', datadir])
    with open(token_path, 'r') as token_file:
      dict = json.load(token_file)
      return dict["access_token"]
  except (CalledProcessError, IOError, JSONDecodeError):
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
    result = run(cli, capture_output=True)
    return result.stdout.strip()
  except CalledProcessError:
    return ""



def edit_secrets_file(secrets_file):
  gpg_recipient = 'Philipp Moers <soziflip@gmail.com>'
  run(['touch', secrets_file], check=True)
  result = run(['mktemp', '--dry-run'], capture_output=True)
  temporary_file = result.stdout.decode(encoding).splitlines()[0]
  run(['gpg', '--output', temporary_file, '--decrypt', secrets_file], check=True)
  run(['chmod', '600', temporary_file], check=True)
  editor = os.environ.get('EDITOR') or 'nano'
  run([editor, temporary_file], check=True)
  run(['gpg', '--yes', '--output', secrets_file, '--recipient', gpg_recipient, '--encrypt', temporary_file], check=True)
  run(['shred', temporary_file])
  run(['rm', temporary_file], check=True)



def get_secret(accountname, oauth=False):
  secrets = get_secrets_from_gpg_encrypted_muttrc(accountname)
  if secrets is None:
    raise Exception(f"Secret for {accountname} not found!")
  if oauth:
    return get_or_fetch_oauth_access_token(accountname)
  else:
    return secrets["password"]



def main():
  global secrets_file

  parser=argparse.ArgumentParser(description="Get credentials for email services")
  parser.add_argument("--mode", help="One of [get, edit]. Defaults to get")
  parser.add_argument("--account", help="name of the account for get mode")
  parser.add_argument("--oauth", action="store_true", help="Generate OAuth2 access token")


  args = parser.parse_args()
  mode = args.mode or 'get'
  if mode == "get":
    if not args.account:
      print("missing argument --account")
      os._exit(1)
    else:
      credential = get_secret(args.account, args.oauth)
      print(credential)
  elif mode == 'edit':
    edit_secrets_file(secrets_file)
  else:
      print(f"mode {args.mode} not implemented")
      os._exit(1)


if __name__ == '__main__':
  main()
