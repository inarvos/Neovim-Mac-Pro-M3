-- lua/lsp/servers/cpp_ls.lua

-- This file configures the C++ language server (clangd) for Neovim using the lspconfig plugin.

local lspconfig = require('lspconfig')

-- Setup clangd language server
lspconfig.clangd.setup {
    cmd = { "clangd" },  -- Use clangd as the language server
    on_attach = require('settings.lsp').on_attach,  -- Function to run when the server attaches to a buffer
    capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),  -- Setup completion capabilities

    settings = {
        clangd = {
            fallbackFlags = { "-std=c++17" },  -- Default compilation flags
            compilationDatabasePath = "build",  -- Path to the compilation database
        }
    },

    filetypes = { "cpp", "objcpp" },  -- Filetypes handled by clangd
    root_dir = function(fname)
        return lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git")(fname) or lspconfig.util.path.dirname(fname)
    end,
}
