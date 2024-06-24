-- lua/lsp/servers/c_ls.lua

-- This file configures the C language server (clangd) for Neovim using the lspconfig plugin, including settings for capabilities, file watch, and diagnostics.

local lspconfig = require('lspconfig')

-- Setup Clangd language server
lspconfig.clangd.setup {
    cmd = {"clangd"},  -- Command to start the Clangd language server
    on_attach = require('settings.lsp').on_attach,  -- Function to run when the server attaches to a buffer
    capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),  -- Setup completion capabilities

    settings = {
        clangd = {
            fallbackFlags = { "-std=c11" },  -- Default flags if no compilation database is found
            compilationDatabasePath = "build",  -- Path to the compilation database (e.g., compile_commands.json)
            diagnostics = {
                onOpen = true,  -- Run diagnostics on file open
                onSave = true,  -- Run diagnostics on file save
                onChange = true  -- Run diagnostics on file change
            }
        }
    },

    filetypes = { "c", "cpp", "objc", "objcpp" },  -- Filetypes handled by clangd
    root_dir = function(fname)
        return lspconfig.util.root_pattern("compile_commands.json", ".git")(fname) or lspconfig.util.path.dirname(fname)
    end,
}
