-- lua/lsp/servers/lua_ls.lua

-- This file configures the Lua language server (lua_ls) for Neovim using the lspconfig plugin, including settings for runtime, diagnostics, workspace, and telemetry.

local lspconfig = require('lspconfig')

-- Setup Lua language server
lspconfig.lua_ls.setup {
    cmd = {"lua-language-server"},  -- Command to start the Lua language server
    on_attach = require('settings.lsp').on_attach,  -- Function to run when the server attaches to a buffer
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',  -- Use LuaJIT as the runtime
                path = vim.split(package.path, ';'),  -- Setup Lua runtime path
            },
            diagnostics = {
                globals = {'vim'},  -- Recognize the 'vim' global variable
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),  -- Make the server aware of Neovim runtime files
                checkThirdParty = false  -- Disable third-party checks
            },
            telemetry = {
                enable = false,  -- Disable telemetry
            },
        },
    },
}
