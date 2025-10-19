-- https://neovimcraft.com/plugin/akinsho/git-conflict.nvim/index.html
--
-- -- packer.nvim
-- use {'akinsho/git-conflict.nvim', tag = "*", config = function()
--   require('git-conflict').setup()
-- end}


local gitconflict = require('git-conflict')

-- This plugin offers default buffer local mappings inside conflicted files. This is primarily because applying these mappings only to relevant buffers is impossible through global mappings. A user can however disable these by setting default_mappings = false anyway and create global mappings as shown below. The default mappings are:

-- co — choose ours
-- ct — choose theirs
-- cb — choose both
-- c0 — choose none
-- ]x — move to previous conflict
-- [x — move to next conflict

gitconflict.setup {
  default_mappings = {
    ours = 'o',
    theirs = 't',
    none = '0',
    both = 'b',
    next = 'n',
    prev = 'p',
  },
  highlights = {
    incoming  = 'DiffAdd',
    current  = 'DiffText',
  },
}
