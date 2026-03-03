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

local function get_credential_from_pass(key, line)
  local h = io.popen(
    "pass " .. key ..
    " | grep " .. string.format("%q", line) ..
    " | head -n1 | cut -d ' ' -f 2 | tr -d '\\n'"
    )
  if not h then return nil end
  local v = h:read("*a")
  h:close()
  return v ~= "" and v or nil
end

-- > To edit files, you need to “add them to the chat”. Do this by naming them on the aider command line. Or, you can use the in-chat /add command to add files.
-- > Only add the files that need to be edited for your task. Don’t add a bunch of extra files. If you add too many files, the LLM can get overwhelmed and confused (and it costs more tokens). Aider will automatically pull in content from related files so that it can understand the rest of your code base.
-- (From https://aider.chat/docs/usage.html)
-- This plugin does this automatically for focused buffers (depending on config).

-- Run 'aider --list-models openrouter/' for a recent list of models (which may be outdated according to a Github issue)
-- So better look at https://openrouter.ai/models/?q=free

local function setup_aider_args()
  local aider_args = ''
  aider_args = aider_args .. ' --watch-files' -- write in comment 'AI' / 'AI?' / 'AI!'
  aider_args = aider_args .. ' --no-gitignore'
  aider_args = aider_args .. ' --no-auto-commits'
  aider_args = aider_args .. ' --set-env OPENROUTER_API_KEY=' .. get_credential_from_pass('openrouter.ai/pmoers@web.de', '^api-key') -- setting (universal) env variables in fish somehow doesn't work.
  aider_args = aider_args .. ' --set-env OPENAI_API_KEY=' .. get_credential_from_pass('openai/gmail', '^api-key') -- setting (universal) env variables in fish somehow doesn't work.
  aider_args = aider_args .. ' --set-env GEMINI_API_KEY=' .. get_credential_from_pass('gemini/soziflip', '^api-key') -- setting (universal) env variables in fish somehow doesn't work.
  -- aider_args = aider_args .. ' --model openrouter/openai/gpt-oss-20b:free'
  -- aider_args = aider_args .. ' --model openrouter/openai/gpt-4o-mini'
  -- aider_args = aider_args .. ' --model openrouter/deepseek/deepseek-chat-v3-0324:free'
  -- aider_args = aider_args .. ' --model openrouter/deepseek/deepseek-chat-v3-0324:free'
  -- aider_args = aider_args .. ' --model openrouter/deepseek/deepseek-r1-0528:free'
  -- aider_args = aider_args .. ' --model openrouter/google/gemini-2.0-flash-exp:free'
  -- aider_args = aider_args .. ' --model openrouter/google/gemini-2.5-pro-exp-03-25'
  -- aider_args = aider_args .. ' --model openrouter/google/gemini-2.5-pro-exp-03-25'
  -- aider_args = aider_args .. ' --model openrouter/anthropic/claude-3.7-sonnet'
  -- aider_args = aider_args .. ' --model openai/o1-mini'
  -- aider_args = aider_args .. ' --model openai/o3-mini'
  aider_args = aider_args .. ' --model openai/o4-mini'
  -- aider_args = aider_args .. ' --model gemini'
  -- aider_args = aider_args .. ' --model gemini/gemini-3.1-pro-preview'
  -- aider_args = aider_args .. ' --model gemini/gemini-2.5-pro'
  -- aider_args = aider_args .. ' --model gemini-exp'
  return aider_args
end

-- vim.api.nvim_set_keymap('n', '<leader>aia', ':AiderOpen ' .. aider_args .. '<CR>', {noremap = true, silent = true})
vim.keymap.set('n', '<leader>aia', function()
  local aider_args = setup_aider_args()
  Aider.AiderOpen(aider_args, 'hsplit')
  move_buffer_to_new_tab(get_buffer_number_by_pattern('term.*aider'))
end, {noremap = true, silent = true})

vim.api.nvim_set_keymap('n', '<leader>aim', ':AiderAddModifiedFiles<CR>', {noremap = true, silent = true})
