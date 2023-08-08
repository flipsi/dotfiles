-- One can either have init.lua (Lua) or init.vim (Vimscript), but not both
-- (see :help vimrc).

-- My approach is to use Neovim, but configure stuff in my vimrc if possible to
-- maintain compatibility with vim, e.g. for when using it one some remote
-- host.
vim.api.nvim_command('set runtimepath^=~/.vim')
vim.api.nvim_command('let &packpath = &runtimepath')
vim.cmd('source $HOME/.vimrc')

-- But some Neovim only stuff will end up here probably, because Neovim has
-- become my main editor in my dev setup.
