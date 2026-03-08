---
-- LSP configuration (Neovim 0.11 native)
---
vim.opt.signcolumn = 'yes'


--
-- Manage installation of language servers with mason (optional but fine)
--
local ensure_installed = {
  'bashls',
  'cssls',
  -- 'clangd',
  'clojure_lsp',
  -- 'cmake',
  -- 'docker_compose_language_service',
  -- 'dockerls',
  'html',
  'jsonls',
  'jdtls', -- Java
  'gopls', -- golang
  'kotlin_language_server',
  -- 'marksman', -- markdown
  -- 'metals', -- Scala -- not available because https://github.com/williamboman/mason.nvim/issues/369#issuecomment-1427541293
  'pylsp', -- Python
  'lua_ls',
  -- 'lua-language-server'
  -- 'rust_analyzer'
  -- 'yamlls'
}

-- :help lspconfig-server-configurations
--
local mason_opts = {
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
    border = "rounded",
  },
}

require('mason').setup(mason_opts)
require('mason-lspconfig').setup({
    ensure_installed,
    handlers = {
      function(server_name)
        require('lspconfig')[server_name].setup({})
        require'lspconfig'.bashls.setup{}
      end,

      -- custom config per language server
      --
      -- rename `example_server` to name of LS
      -- example_server = function()
      --   require('lspconfig').example_server.setup({
      --       ---
      --       -- in here you can add your own
      --       -- custom configuration
      --       ---
      --     })
      -- end,
    },
})

-- Setup language servers (should happen *exactly* once per LS):

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Native server configs (these names must match Neovim's built-in server names)
vim.lsp.config('bashls',   { capabilities = capabilities })
vim.lsp.config('cssls',    { capabilities = capabilities })
vim.lsp.config('html',     { capabilities = capabilities })
vim.lsp.config('jsonls',   { capabilities = capabilities })
vim.lsp.config('gopls',    { capabilities = capabilities })
vim.lsp.config('clojure_lsp', { capabilities = capabilities })
vim.lsp.config('kotlin_language_server', { capabilities = capabilities })

local lombok_jar = vim.fn.expand("~/.local/share/nvim/mason/share/jdtls/lombok.jar") -- adjust to your path

vim.lsp.config('jdtls', {
  capabilities = capabilities,
  cmd = {
    'jdtls',
    '--jvm-arg=-javaagent:' .. lombok_jar,
  },
  settings = {
    java = {
      configuration = {
        annotationProcessing = { enabled = true },
      },
    },
  },
})

-- Groovy
-- TODO: fix import, see https://www.reddit.com/r/groovy/comments/1eruc6o/comment/lyo20xh/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
vim.lsp.config('groovyls', {
    capabilities = capabilities,
    filetypes = { "groovy" },
    -- cmd = { "groovy-language-server" }, -- installed via AUR in this case
    cmd = { "java", "-jar", "/usr/share/java/groovy-language-server/groovy-language-server-all.jar" },
    root_markers = { ".git" }
})

local lua_settings = {
  Lua = {
    diagnostics = { globals = { 'vim' } },
  },
}

vim.lsp.config('lua_ls', {
  capabilities = capabilities,
  settings = lua_settings,
})

local pylsp_settings = {
  pylsp = {
    plugins = {
      pycodestyle = {
        ignore = { 'E501' },
        maxLineLength = 100,
      },
    },
  },
}

vim.lsp.config('pylsp', {
  capabilities = capabilities,
  settings = pylsp_settings,
})

-- Enable servers (do this once)
for _, server in ipairs(ensure_installed) do
  vim.lsp.enable(server)
end

-- Keymaps on attach (your existing ones are fine)
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = { buffer = event.buf }

    vim.keymap.set('n', '<leader>iq', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gdd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gds', function() vim.cmd('vsplit'); vim.lsp.buf.definition() end, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>fu', vim.lsp.buf.references, opts)
    vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, opts)
    vim.keymap.set({ 'n', 'x' }, '<leader>rf', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'x' }, '<leader>af', function() vim.lsp.buf.format({ async = true }) end, opts)
    vim.keymap.set({ 'n', 'x' }, '<leader>iaa', vim.lsp.buf.code_action, opts)

    -- Organize imports (generic LSP way; works if server supports it)
    vim.keymap.set('n', '<leader>ioi', function()
      vim.lsp.buf.code_action({
        apply = true,
        context = { only = { "source.organizeImports" } },
      })
    end, opts)

  end,
})




---
-- Autocompletion setup
---
local cmp = require('cmp')

cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
    {name = 'ultisnips'},
    {name = 'buffer', option = {
        -- make umlauts etc. part of keywords in terms of completion tokens
        keyword_pattern = [[\k\+]],
        -- complete words from all buffers
        get_bufnrs = function()
          return vim.api.nvim_list_bufs()
        end
    }},
  },
  snippet = {
    expand = function(args)
      -- You need Neovim v0.10 to use vim.snippet
      vim.snippet.expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({}),
  formatting = {
    format = require("nvim-highlight-colors").format
  }
})
