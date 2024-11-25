-- One can either have init.lua (Lua) or init.vim (Vimscript), but not both (see :help vimrc).

-- My approach is to use Neovim, but configure most stuff in my vimrc if possible to
-- maintain compatibility with vim, e.g. for when using it one some remote host without Neovim.
vim.api.nvim_command('set runtimepath^=~/.vim')
vim.api.nvim_command('let &packpath = &runtimepath')
vim.cmd('source $HOME/.vimrc')

-- nice helper to create mappings
-- from https://kinbiko.com/posts/2021-08-23-rewriting-vimrc-in-lua/
local function map(kind, lhs, rhs, opts)
  vim.api.nvim_set_keymap(kind, lhs, rhs, opts)
end

local silentnoremap = {noremap = true, silent = true}


function _G.reload_config()
  local reload = require("plenary.reload").reload_module
  dofile(vim.env.MYVIMRC) -- init.lua
  reload("me", false)
  vim.notify("Neovim configuration reloaded!", vim.log.levels.INFO)
end

-- overwrite mapping for neovim only -- FIXME (after sourcing, vim function is called)
map('n', '<Leader>sv', '<Cmd>lua reload_config()<CR>', silentnoremap)
-- ... so I use a separate mapping for now
map('n', '<Leader>rv', '<Cmd>lua reload_config()<CR>', silentnoremap)
map('n', '<Leader>rV', ':luafile ~/.config/nvim/init.lua', silentnoremap)

-- I continue to use vim-plug as my plugin manager.
-- People have been using packer, but it has been deprecated by now.
-- lazy.nvim is the new shit, but migration has it's caveats, see:
-- https://dimtion.fr/blog/trying-out-lazy-nvim/

-- Plugins to install will still have to be added to vimrc, because `plug#begin()` can't be invoked twice (https://github.com/junegunn/vim-plug/issues/454#issuecomment-202878485).
-- If I want to configure plugins here in lua, I break my (anti-original-vim philosophy) of having this in one place. Whatever.
-- TODO: I may be able to move the plugin end call to here...


-- TODO: move subdirs of lua into `flipsi` subdir/namespace to avoid collisions!


require('plugins.lsp')
-- require('plugins.nvim-metals') -- I don't want what's in this file!
require('plugins.nvim-metals-minimal') -- I don't want what's in this file!

require('nvim-highlight-colors').setup({
  render = 'background',
  enable_tailwind = true
})

