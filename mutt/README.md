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
yay -S mutt-wizard neomutt msmtp isync pass notmuch notmuch-mutt cyrus-sasl-xoauth2 goobook elinks
```
Create mail store:
```
MAILDIR=~/.local/share/mail
mkdir $MAILDIR/$EMAIL_ADDRESS
```
### Setup Regular Account

1. To add credentials, use `mutt-secrets.py --mode edit`
1. Try syncing mailboxes with `mbsync $EMAIL_ADDRESS`
1. Copy-paste and edit mutt account files


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

Now, use the git submodule [curl_google_oauth](https://github.com/jay/curl_google_oauth).
The Client ID, Client Secret are used by the curl_google_oauth script to generate a Refresh Token:
```
$ export ACCOUNT=EMAIL_ADDRESS
$ export DATADIR="~/.local/share/mail_auth/$ACCOUNT"
$ mkdir -p $DATADIR
$ chmod 700 $DATADIR
$ cd $DATADIR

$ cat > credential.txt << EOF
client_id = REMOVED.apps.googleusercontent.com
client_secret = REMOVED
scope = https://mail.google.com/
EOF

$ ./mutt/curl_google_oauth/bearer-new.pl --datadir $DATADIR
opening browser url https://accounts.google.com/o/oauth2/v2/auth?client_id=REMOVED.apps.googleusercontent.com&redirect_uri=http%3A%2F%2Flocalhost%3A7777&scope=https%3A%2F%2Fmail.google.com%2F&response_type=code&access_type=offline

(if open fails then copy url from auth-url.txt and paste into browser)

waiting for google to send authorization code to localhost:7777
received authorization code
requesting token data
received token data
updating bearer.cfg and token.json
token data written to bearer.cfg and token.json

$ rm credential.txt
```
The access and refresh token are stored in the datadir permanently.
The refresh token is used to update the access token if necessary on every usage.


### Setup mutt on another host

* Install config with the install script of this repo
* Install dependencies (see above)
* Copy encrypted credentials file `dotfiles/mutt/mutt/secrets.gpg` (gitignored) to the host via secure channel
* Copy GPG key `CA1DD30B080E5D7FADCE04ECFC218BA7F39AC976` to the host
```
# on other host
gpg --export --armor CA1DD30B080E5D7FADCE04ECFC218BA7F39AC976 > tmp/gpg.public.key
gpg --export-secret-keys --armor CA1DD30B080E5D7FADCE04ECFC218BA7F39AC976 --output tmp/gpg.sec.plain
# copy to new host via secure channel and delete files!
# on new host
gpg --import tmp/gpg.sec.plain
gpg --edit-key CA1DD30B080E5D7FADCE04ECFC218BA7F39AC976 trust quit
```


## Gmail peculiarities

* [Gmail doesn't use folders, but labels instead](https://blogs-on-gmail.blogspot.com/2019/02/howgmailstores.html).
* Gmail implicitly archives every email (even when deleted) with the special *All Mail* label.
* If an email is deleted in mutt and deletion is synced back to Gmail, it will still be archived.
  For this to work, the according option in [Gmail IMAP settings](https://mail.google.com/mail/u/0/?tab=cm#settings/fwdandpop) has to be set (found via [this answer](https://superuser.com/a/1542298/431697)).
* [Gmail automatically saves sent emails](https://linuxconfig.org/how-to-install-configure-and-use-mutt-with-a-gmail-account-on-linux) - by adding the '[Gmail]Sent Mail' label.
  So to avoid duplicates, mutt should be configured to not save a copy of sent mails.


## Resources

https://nixvsevil.com/posts/mutt-gmail-oauth-gnupg/

http://blog.onodera.asia/2020/06/how-to-use-google-g-suite-oauth2-with.html



## Troubleshooting

To make it work with Gmail, I had to [remove the flattening mechanism](https://github.com/LukeSmithxyz/mutt-wizard/issues/517#issuecomment-684506780).

To fix the initial isync error:
```
> mbsync mail@philippmoers.de
C: 0/6  B: 0/6  F: +0/0 *0/0 #0/0  N: +0/0 *0/0 #0/0
Maildir error: cannot open store '/home/flipsi/.local/share/mail/mail@philippmoers.de/'
C: 6/6  B: 0/6  F: +0/0 *0/0 #0/0  N: +0/0 *0/0 #0/0
```
I had to `mkdir /home/flipsi/.local/share/mail/mail@philippmoers.de`.


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
