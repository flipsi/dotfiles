local lint = require('lint')

-- install linters via Mason

lint.linters_by_ft = {
    bash = { "shellcheck", "bash" },
    fish = { "shellcheck", "fish" },
    java = { "sonarlint-language-server", "sonarqube", "semgrep", "spotbugs" },
    javascript = { "ast-grep", "eslint_d" },
    javascriptreact = { "ast-grep", "eslint_d" },
    go = { "gospel" },
    haskell = { "hlint" },
    html = { "htmllint" },
    latex = { "vale" },
    lua = { "ast-grep" },
    markdown = { "vale", "alex", "markdownlint" },
    python = { "pylint" },
    svelte = { "eslint_d" },
    typescript = { "ast-grep", "eslint_d" },
    typescriptreact = { "ast-grep", "eslint_d" },
}

vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
    callback = function()
        lint.try_lint()
        -- lint.try_lint("cspell")
    end,
})

vim.keymap.set({ "n" }, "<leader>idl", function()
    lint.try_lint()
end, { desc = "Trigger linter" })

-- diagnostics mappings (to jump/toggle etc. can be found in lsp.lua)
