-- luacheck: globals vim

-- https://aider.chat/docs/usage/watch.html
-- https://github.com/joshuavial/aider.nvim

Aider = require('aider')

Aider.setup({
  auto_manage_context = true,
  default_bindings = false,
  debug = false,
  vim = true,
  ignore_buffers = {'^term:', 'NeogitConsole', 'NvimTree_', 'neo-tree filesystem', '.git', 'fugitive:.*'},
})

-- > To edit files, you need to “add them to the chat”. Do this by naming them on the aider command line. Or, you can use the in-chat /add command to add files.
-- > Only add the files that need to be edited for your task. Don’t add a bunch of extra files. If you add too many files, the LLM can get overwhelmed and confused (and it costs more tokens). Aider will automatically pull in content from related files so that it can understand the rest of your code base.
-- (From https://aider.chat/docs/usage.html)
-- This plugin does this automatically for focused buffers (depending on config).

local aider_args = ''
aider_args = aider_args .. ' --watch-files' -- write in comment 'AI' / 'AI?' / 'AI!'
aider_args = aider_args .. ' --no-gitignore'
aider_args = aider_args .. ' --no-auto-commits'
aider_args = aider_args .. ' --model openrouter/deepseek/deepseek-chat-v3-0324:free'
-- aider_args = aider_args .. ' --model openrouter/google/gemini-2.0-flash-exp:free'
-- aider_args = aider_args .. ' --model openrouter/google/gemini-2.5-pro-exp-03-25'
-- aider_args = aider_args .. ' --model openrouter/anthropic/claude-3.7-sonnet'
-- aider_args = aider_args .. ' --model openrouter/openai/gpt-4o-mini'


-- vim.api.nvim_set_keymap('n', '<leader>aia', ':AiderOpen ' .. aider_args .. '<CR>', {noremap = true, silent = true})
vim.keymap.set('n', '<leader>aia', function()
    Aider.AiderOpen(aider_args, 'hsplit')
    move_buffer_to_new_tab(get_buffer_number_by_pattern('term.*aider'))
end, {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<leader>aim', ':AiderAddModifiedFiles<CR>', {noremap = true, silent = true})
