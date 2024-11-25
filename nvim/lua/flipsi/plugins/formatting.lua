local conform = require("conform")

-- install formatters via Mason

conform.setup({
    formatters_by_ft = {
        clojure = { "cljfmt" },
        css = { "prettier" },
        go = { "goimports", "gofumpt" },
        graphql = { "prettier" },
        html = { "prettier" },
        java = { "google-java-format", "ast-grep" },
        javascript = { "prettier" },
        javascriptreact = { "prettier" },
        json = { "prettier" },
        kotlin = { "ast-grep" },
        liquid = { "prettier" },
        lua = { "stylua" },
        markdown = { "prettier" },
        python = { "isort", "black" },
        php = { "pretty-php" },
        rust = { "ast-grep", lsp_format = "fallback" },
        -- scala = { "scalafmt" },
        svelte = { "prettier" },
        typescript = { "prettier" },
        typescriptreact = { "prettier" },
        yaml = { "prettier" },
    },
})

vim.keymap.set({ "n", "v" }, "<leader>af", function()
    conform.format({
        lsp_fallback = true,
        async = true,
        timeout_ms = 1000,
    })
end, { desc = "Format file or range (in visual mode)" })
