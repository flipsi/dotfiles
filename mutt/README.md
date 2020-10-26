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

I wrote a script called [mutt.sh](./mutt.sh) to wrap mutt with a mail sync mechanism with isync.


## Setup

Install required dependencies:
```
yay -S neomutt isync msmtp pass python2 cyrus-sasl-xoauth2
```

### Setup Gmail Account

In Gmail, I do not want to have to enable LSA (Less Secure Apps) so that one can authenticate with
my plain text Google password from any application. Instead, I configure isync and msmtp to use
OAuth.
For this to work, I have to create a project with the [Google API Console](https://console.developers.google.com/)
(my own "mutt" Google App) for every Google account I want to access. The Client ID, Client Secret
are then used by the oauth2.py script to generate a Refresh Token. Those three are stored in a GPG
encrypted file. On every sync or send mail, they are used to generate an access token with the
oauth2.py script.

### Setup mutt on another host

* Install config with the install script of this repo
* Install dependencies (see above)
* Copy GPG key `CA1DD30B080E5D7FADCE04ECFC218BA7F39AC976` to the host
* Copy encrypted credentials file `mutt/mutt/secrets.gpg` to the host


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
