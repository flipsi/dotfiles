" this config is not used by Vimium directly
" but at least is under version control and can be copied

"""""""""""""""""""""""
" CUSTOM KEY MAPPINGS

map  o          Vomnibar.activate
map  t          Vomnibar.activateInNewTab

map <down>      scrollPageDown
map <up>        scrollPageUp
map <pageDown>  scrollFullPageDown
map <pageUp>    scrollFullPageUp

map <a-j>       scrollPageDown
map <a-k>       scrollPageUp
map <c-f>       scrollFullPageDown
map <c-b>       scrollFullPageUp

map zz          zoomReset

map g<up>       previousTab
map g<down>     nextTab
map <a-p>       previousTab
map <a-n>       nextTab
map <a-P>       moveTabLeft
map <a-N>       moveTabRight
map gp          togglePinTab
map !           moveTabToNewWindow
map d           removeTab
map qq          removeTab
map u           restoreTab
map <a-space>   visitPreviousTab

map <c-left>    goBack
map <c-right>   goForward

map l           LinkHints.activateModeToOpenInNewTab
map gl          LinkHints.activateModeToDownloadLink
" remember yf to copy link addresses
" remember yt to duplicate tab

" global marks with lowercase letters, local marks with uppercase letters
map m           Marks.activateCreateMode swap
map '           Marks.activateGotoMode swap



"""""""""""""""""""""""
" REMOVE MAPPINGS

unmap <c-e>
