" this config is not used by Vimium directly
" but at least is under version control and can be copied

"""""""""""""""""""""""
" CUSTOM KEY MAPPINGS

map <a-j>   scrollPageDown
map <a-k>   scrollPageUp
map <c-f>   scrollFullPageDown
map <c-b>   scrollFullPageUp

map  o      Vomnibar.activate
map  t      Vomnibar.activateInNewTab

map <a-p>   previousTab
map <a-n>   nextTab
map g<up>   previousTab
map g<down> nextTab
map gp      togglePinTab

map !       moveTabToNewWindow
map d       removeTab
map qq      removeTab
map u       restoreTab

map <c-left> goBack
map <c-right> goForward

map l       LinkHints.activateModeToOpenInNewTab
map gl      LinkHints.activateModeToDownloadLink
" remember yf to copy link addresses

" global marks with lowercase letters, local marks with uppercase letters
map m       Marks.activateCreateMode swap
map '       Marks.activateGotoMode swap



"""""""""""""""""""""""
" REMOVE MAPPINGS


unmap <c-e>
