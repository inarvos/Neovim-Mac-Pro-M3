-- lua/lsp/servers/python_ls.lua

-- This file configures the Python language server (Pyright) for Neovim using the lspconfig plugin, including settings for type checking, search paths, and type inference.

local lspconfig = require('lspconfig')

-- Setup Pyright language server
lspconfig.pyright.setup {
    -- cmd = {"pyright-langserver"},  -- Command to start the Pyright language server (optional, usually auto-detected)
    on_attach = require('settings.lsp').on_attach,  -- Function to run when the server attaches to a buffer
    settings = {
        python = {
            analysis = {
                typeCheckingMode = "strict",  -- Set type checking mode to strict
                autoSearchPaths = true,  -- Automatically search for Python paths
                useLibraryCodeForTypes = true  -- Use library code for type inference
            }
        }
    }
}
