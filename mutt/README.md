mutt
====

mutt is an ncurses based, highly configurable mail reader application for the terminal.

My fundamental config is now based on [Mutt-wizard](https://github.com/LukeSmithxyz/mutt-wizard)
which makes setup much easier and utilizes [GNU pass](https://www.passwordstore.org) for password
management. While pass is great, I want my email credentials to be separated as an additional
security layer. This is why there is a [secrets.py](./secrets.py) script that handles GPG encrypted
files.

The generated config is just a good starting point for a config, other accounts can be added and
adjustments be made manually. If I use mutt-wizard again, I have to undo commits in the password
store git directory:
```
cd ~/.password-store
git reset HEAD~1
git reset --hard
```

Mutt-wizard uses a re-implementation of mutt called [neomutt](https://neomutt.org).

Also, it uses isync (mbsync) to sync local copies of mailboxes which apparently has some advantages
over offlineimap.

I wrote a script called [mail.sh](./mail.sh) to wrap mutt with a mail sync mechanism with isync.


## Setup

Install required dependencies:
```
yay -S mutt-wizard neomutt isync msmtp pass python2 cyrus-sasl-xoauth2
```
Create mail store:
```
MAILDIR=~/.local/share/mail
mkdir $MAILDIR/$EMAIL_ADDRESS
```

### Setup Gmail Account

In Gmail, I do not want to have to enable LSA (Less Secure Apps) so that one can authenticate with
my plain text Google password from any application. Instead, I configure isync and msmtp to use
OAuth.

For this to work, I have to create a project with the [Google API Console](https://console.developers.google.com/)
(my own "mutt" Google App) for every Google account I want to access:
1. Open the ‘Select a project’ drop down menu at the top left of the page, this will open a pop-up window.
1. In the top right of the window select ‘NEW PROJECT’. This will take you to the project creation page.
1. You can leave the default name if you choose but I recommend giving it a descriptive name, then select ‘CREATE’. It might take a few seconds but you should get a notification telling you the project has been created.
1. Now, on the left menu bar, select ‘OAuth consent screen’. This will take you to another page with a ‘User Type’ option. Choose ‘External’ and then ‘CREATE’.
1. You will now be on a new page with a few more options. You only need to fill in the application name and then click the save button at the bottom of the page.
1. Next, go back the menu on the left and select ‘Credentials’. This will take you to the credentials page where you can select ‘CREATE CREDENTIALS’ at the top. Choose ‘OAuth client ID’.
1. On the next page choose ‘Desktop app’ and give it a name. Once you select ‘CREATE’ you will be presented with your Client_id and Client_secret.

The Client ID, Client Secret are then used by the oauth2.py script to generate a Refresh Token:
`python2 ./oauth2.py --user=$EMAIL --client_id=$CLIENT_ID --client_secret=$CLIENT_SECRET --generate_oauth2_token`

Those three are stored in a GPG encrypted file. Use `mutt-secrets.py --mode edit_secrets_file`.
On every sync or send mail, they are used to generate an access token with the oauth2.py script.

### Setup mutt on another host

* Install config with the install script of this repo
* Install dependencies (see above)
* Copy GPG key `CA1DD30B080E5D7FADCE04ECFC218BA7F39AC976` to the host
* Copy encrypted credentials file `mutt/mutt/secrets.gpg` to the host


## Gmail peculiarities

* Gmail stores/archives every email (even when deleted) in a special *All Mail* folder, which I probably don't want to sync.
* If an email is deleted in mutt and deletion is synced back to Gmail, it will still be archived.
  For this to work, the according option in [Gmail IMAP settings](https://mail.google.com/mail/u/0/?tab=cm#settings/fwdandpop) has to be set (found via [this answer](https://superuser.com/a/1542298/431697)).


## Resources

https://nixvsevil.com/posts/mutt-gmail-oauth-gnupg/

http://blog.onodera.asia/2020/06/how-to-use-google-g-suite-oauth2-with.html



## Troubleshooting

To make it work with Gmail, I had to [remove the flattening mechanism](https://github.com/LukeSmithxyz/mutt-wizard/issues/517#issuecomment-684506780).

To fix the following isync error:
```
> mbsync soziflip@gmail.com
C: 0/1  B: 0/0  M: +0/0 *0/0 #0/0  S: +0/0 *0/0 #0/0
IMAP error: selected SASL mechanism(s) not available;
   selected: XOAUTH2
   available: SCRAM-SHA-1 SCRAM-SHA-256 DIGEST-MD5 EXTERNAL NTLM CRAM-MD5 PLAIN LOGIN ANONYMOUS
C: 1/1  B: 0/0  M: +0/0 *0/0 #0/0  S: +0/0 *0/0 #0/0
```
I had to install the `cyrus-sasl-xoauth2` package.
