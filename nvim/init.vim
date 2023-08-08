" One can either have init.lua (Lua) or init.vim (Vimscript), but not both
" (see :help vimrc).

" I use init.lua now.
" So this file is not used anymore, it's just here for reference.

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
