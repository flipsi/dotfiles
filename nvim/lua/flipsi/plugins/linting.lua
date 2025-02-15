local lint = require('lint')

-- install linters via Mason

lint.linters_by_ft = {
    bash = { "shellcheck", "bash" },
    fish = { "shellcheck", "fish" },
    -- java = { "semgrep", "sonarlint-language-server", "sonarqube", "spotbugs" },
    java = { "semgrep" },
    javascript = { "ast-grep", "eslint_d" },
    javascriptreact = { "ast-grep", "eslint_d" },
    go = { "gospel" },
    haskell = { "hlint" },
    html = { "htmllint" },
    latex = { "vale" },
    lua = { "ast_grep" },
    -- markdown = { "vale", "alex", "markdownlint", "markdownlint-cli2"},
    markdown = { "markdownlint" },
    python = { "pylint" },
    svelte = { "eslint_d" },
    typescript = { "ast-grep", "eslint_d" },
    typescriptreact = { "ast-grep", "eslint_d" },
}

lint.linters.markdownlint.args = {
    "--disable", "MD013"
}

vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
    callback = function()
        -- lint.try_lint()
        -- lint.try_lint("cspell") -- specific linter

        -- suppress errors
        local ok, result = pcall(lint.try_lint)
    end,
})

vim.keymap.set({ "n" }, "<leader>idl", function()
    lint.try_lint()
end, { desc = "Trigger linter" })

-- diagnostics mappings (to jump/toggle etc. can be found in lsp.lua)
