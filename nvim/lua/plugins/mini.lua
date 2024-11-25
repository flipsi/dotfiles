
local mini_comment_config =
{
  -- Options which control module behavior
  options = {
    -- Function to compute custom 'commentstring' (optional)
    custom_commentstring = nil,

    -- Whether to ignore blank lines when commenting
    ignore_blank_line = true,

    -- Whether to recognize as comment only lines without indent
    start_of_line = false,

    -- Whether to force single space inner padding for comment parts
    pad_comment_parts = true,
  },

  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    -- Toggle comment (like `gcip` - comment inner paragraph) for both
    -- Normal and Visual modes
    comment = 'gc',

    -- Toggle comment on current line
    comment_line = 'gcc',

    -- Toggle comment on visual selection
    comment_visual = 'gc',

    -- Define 'comment' textobject (like `dgc` - delete whole comment block)
    -- Works also in Visual mode if mapping differs from `comment_visual`
    textobject = 'gc',
  },

  -- Hook functions to be executed at certain stage of commenting
  hooks = {
    -- Before successful commenting. Does nothing by default.
    pre = function() end,
    -- After successful commenting. Does nothing by default.
    post = function() end,
  },
}

-- require('mini.ai').setup() --replaces targets
-- require('mini.align').setup() -- replaces EasyAlign
require('mini.comment').setup(mini_comment_config)
-- require('mini.operators').setup() -- replaces exchange
-- require('mini.pairs').setup() -- replaces autopairs
-- require('mini.surround').setup() -- replaces vim-surround
-- require('mini.bracketed').setup() -- replaces vim-unimpaired
-- require('mini.files').setup()
-- require('mini.jump2d').setup() -- replaces easymotion, but I use sneak
-- require('mini.pick').setup()
-- require('mini.notify').setup()
-- require('mini.statusline').setup() -- replaces airline
