" Vim syntax file

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn match offlineimapComment /#.*$/ contains=@Spell
syn match offlineimapGeneral /\[\(general\)\]/
syn match offlineimapAccount /\[\(Account\).*\]/
syn match offlineimapRepository /\[\(Repository\).*\]/

syn match offlineimapOption /\<\(ui\|maxsyncaccounts\|accounts\|pythonfile\|fsync\|socktimeout\|status_backend\|localrepository\|remoterepository\|autorefresh\|quick\|maxconnections\|type\|localfolders\|sslcacertfile\|cert_fingerprint\|remoteusereval\|remotepasseval\|realdelete\|remotehost\|remoteport\|ssl\|folderfilter\)\>/

syn match offlineimapNumber /\<\(\d\+$\)/
syn match offlineimapBool /\<\(true\|false\)\>/
syn match offlineimapActivate /\<\(yes\|no\)\>/

" Only except certain values for specific options
syn match offlineimapWrongOption /\<\(maxsyncaccounts\|socktimeout\|autorefresh\|quick\|maxconnections\|remoteport\)\s=\s\(\d\+$\)\@!.*$/
syn match offlineimapWrongOption /\<fsync\s=\s\(true$\|false$\)\@!.*$/
syn match offlineimapWrongOption /\<\(realdelete\|ssl\)\s=\s\(yes$\|no$\)\@!.*$/
syn match offlineimapWrongOption /\<status_backend\s=\s\(plain$\|sqlite$\)\@!.*$/
syn match offlineimapWrongOption /\<type\s=\s\(Maildir$\|Gmail$\|IMAP$\)\@!.*$/
syn match offlineimapWrongOption /\<ui\s=\s\(TTY.TTYUI$\|basic$\|blinkenlights$\|quiet\)\@!.*$/

syn match offlineimapWrongOptionValue /\S* \zs.*$/ contained containedin=offlineimapWrongOption

highlight default link offlineimapComment Comment
highlight default link offlineimapGeneral Function
highlight default link offlineimapAccount Function
highlight default link offlineimapRepository Function
highlight default link offlineimapOption Type
highlight default link offlineimapWrongOption offlineimapOption
highlight default link offlineimapWrongOptionValue Error
highlight default link offlineimapNumber Number
highlight default link offlineimapBool Constant
highlight default link offlineimapActivate Constant


let b:currEnt_syntax = "offlineimap"
