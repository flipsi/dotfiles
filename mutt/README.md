mutt
====

mutt is an ncurses based, highly configurable mail reader application for the terminal.

My fundamental config is now based on [Mutt-wizard](https://github.com/LukeSmithxyz/mutt-wizard)
which makes setup much easier and utilizes [GNU pass](https://www.passwordstore.org) for password
management (which is great).

It uses a re-implementation of mutt called [neomutt](https://neomutt.org).

Also, it uses isync/mbsync to sync local copies of mailboxes which apparently has some advantages
over offlineimap.


I wrote a script called [mutt.sh](./mutt.sh) to wrap mutt with a isync mechanism.


## Troubleshooting

To make it work with Gmail, I had to [remove the flattening mechanism](https://github.com/LukeSmithxyz/mutt-wizard/issues/517#issuecomment-684506780).

