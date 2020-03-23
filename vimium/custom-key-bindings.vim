" this config is not really used directly
" but at least is under version control and can be copied

map <a-j> scrollPageDown
map <a-k> scrollPageUp
map <c-f> scrollFullPageDown
map <c-b> scrollFullPageUp

map <a-p> previousTab
map <a-n> nextTab

map d     removeTab
map qq    removeTab
map u     restoreTab

map l     LinkHints.activateModeToOpenInNewTab
map gl    LinkHints.activateModeToDownloadLink

" global marks with lowercase letters, local marks with uppercase letters
map m     Marks.activateCreateMode swap
map '     Marks.activateGotoMode swap

map ö     enterFindMode
