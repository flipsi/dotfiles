---
-- LSP configuration
---
vim.opt.signcolumn = 'yes'

local lspconfig = require('lspconfig')

--
-- Manage installation of language servers with mason
--
-- Install with :LspInstall

-- List of available language servers:
-- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
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

-- Add cmp_nvim_lsp capabilities settings to lspconfig
lspconfig.util.default_config.capabilities = vim.tbl_deep_extend(
  'force',
  lspconfig.util.default_config.capabilities,
  require('cmp_nvim_lsp').default_capabilities()
)

-- Executes the callback function every time a language server is attached to a buffer.
vim.api.nvim_create_autocmd('LspAttach', {
  desc = 'LSP actions',
  callback = function(event)
    local opts = {buffer = event.buf}

    vim.keymap.set('n', '<leader>iq', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'K',          '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
    vim.keymap.set('n', 'gdd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gds', ':vsplit | lua vim.lsp.buf.definition()<cr>', opts)
    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'gr',         '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', '<leader>fu', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
    vim.keymap.set({'n', 'x'}, '<leader>rf', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
    vim.keymap.set({'n', 'x'}, '<leader>af', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
    vim.keymap.set({'n', 'x'}, '<leader>iaa', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)

    -- -- non-spec LSP features per LS, like "organize imports"
    -- note that for jdtls, organizing imports is a code action

    -- local clients = vim.lsp.get_active_clients() # deprecated
    local clients = vim.lsp.get_clients()

    if #clients == 0 then
      print("No active LSP clients.")
    else
      for _, client in pairs(clients) do
        -- print(vim.inspect(client))
        if (client.name == 'jdtls') then
          -- FIXME
          vim.keymap.set('n', '<leader>ioi',   '<cmd>lua require("lspconfig").jdtls.organize_imports()<cr>', opts)
          -- vim.keymap.set('n', '<leader>iaev' , '<cmd>lua jdtls.extract_variable()<cr>', opts)
          -- vim.keymap.set('n', '<leader>iaec',  '<cmd>lua jdtls.extract_constant()<cr>', opts)
          -- vim.keymap.set('v', "<leader>iaem", [[<ESC><CMD>lua jdtls.extract_method(true)<CR>]], { noremap=true, silent=true, buffer=event.buf, desc = "Extract method" })
        end
      end
    end

  end,
})


local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Setup language servers (should happen *exactly* once per LS):

local lua_settings = {
  Lua = {
    diagnostics = {
      globals = { 'vim' },
    }
  }
}

local pylsp_settings = {
  pylsp = {
      plugins = {
        pycodestyle = {
          ignore = {'E501'},
          maxLineLength = 100
        }
      }
    }
}

-- TODO: configure?
-- https://sookocheff.com/post/vim/neovim-java-ide/
local jdtls_settings = { }

require("lspconfig").bashls.setup { capabilities = capabilities }
require("lspconfig").clangd.setup { capabilities = capabilities }
require("lspconfig").cmake.setup { capabilities = capabilities }
require("lspconfig").cssls.setup { capabilities = capabilities }
require("lspconfig").dockerls.setup { capabilities = capabilities }
require("lspconfig").jdtls.setup { settings = jdtls_settings, capabilities = capabilities }
require("lspconfig").jsonls.setup { capabilities = capabilities }
require("lspconfig").lua_ls.setup { settings = lua_settings, capabilities = capabilities }
require("lspconfig").marksman.setup { capabilities = capabilities }
require("lspconfig").pylsp.setup { settings = pylsp_settings, capabilities = capabilities }
require('lspconfig').rust_analyzer.setup({})
require("lspconfig").yamlls.setup { capabilities = capabilities }



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
