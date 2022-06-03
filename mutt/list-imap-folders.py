import email, imaplib, getpass

# This lists IMAP mailbox folders (Gmail labels).
# For this to work in Gmail, less secure access methods have to be allowed.

host = "imap.gmail.com"

username = input("Type email address: ")
password = getpass.getpass(prompt="Type password: ")

mail = imaplib.IMAP4_SSL(host)
mail.login(username, password)

mailboxes = mail.list()

for mailbox in mailboxes:
  print(mailbox)

# Result:
#  [
#    b'(\\HasNoChildren) "/" "INBOX"',
#    b'(\\HasNoChildren) "/" "Sent-Mail-old"',
#    b'(\\HasChildren \\Noselect) "/" "[Gmail]"',
#    b'(\\All \\HasNoChildren) "/" "[Gmail]/Alle Nachrichten"',
#    b'(\\Drafts \\HasNoChildren) "/" "[Gmail]/Entw&APw-rfe"',
#    b'(\\HasNoChildren \\Sent) "/" "[Gmail]/Gesendet"',
#    b'(\\Flagged \\HasNoChildren)"/" "[Gmail]/Markiert"',
#    b'(\\HasNoChildren \\Trash) "/" "[Gmail]/Papierkorb"',
#    b'(\\HasNoChildren) "/" "[Gmail]/Sent-Mail-old"',
#    b'(\\HasNoChildren \\Junk) "/" "[Gmail]/Spam"',
#    b'(\\HasNoChildren \\Important) "/" "[Gmail]/Wichtig"'
#  ]
