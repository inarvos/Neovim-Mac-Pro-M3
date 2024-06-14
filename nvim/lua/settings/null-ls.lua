-- ~/.config/nvim/lua/settings/null-ls.lua

-- This file configures the null-ls plugin to provide additional formatting and diagnostics capabilities in Neovim, integrating tools like Prettier and ESLint.

local null_ls = require("null-ls")

-- Register builtins for formatting and diagnostics
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

-- Setup null-ls
null_ls.setup({
    sources = {
        -- Configure Prettier for formatting
        formatting.prettier.with({
            extra_args = { "--single-quote", "--jsx-single-quote" } -- Additional arguments for Prettier
        }),
        -- Configure ESLint for diagnostics
        diagnostics.eslint.with({
            command = "eslint", -- Command to run ESLint
        }),
    },
    on_attach = function(client)
        -- Automatically format on save if the server supports document formatting
        if client.server_capabilities.document_formatting then
            vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.format()")
        end
    end,
})
