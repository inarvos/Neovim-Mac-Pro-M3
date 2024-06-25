-- lua/lsp/servers/csharp_ls.lua

-- This file configures the C# language server (OmniSharp) for Neovim using the lspconfig plugin.

local lspconfig = require('lspconfig')

-- Setup OmniSharp language server
lspconfig.omnisharp.setup {
    cmd = { "dotnet", "/usr/local/bin/omnisharp-osx-arm64-net6.0/OmniSharp.dll", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },  -- Use dotnet to run OmniSharp
    on_attach = require('settings.lsp').on_attach,  -- Function to run when the server attaches to a buffer
    capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),  -- Setup completion capabilities

    settings = {
        omnisharp = {
            useModernNet = true,  -- Use .NET Core instead of Mono
            organizeImportsOnFormat = true,  -- Automatically organize imports on format
            enableRoslynAnalyzers = true,  -- Enable Roslyn analyzers
            enableEditorConfigSupport = true,  -- Enable support for .editorconfig
            analyzeOpenDocumentsOnly = true  -- Analyze only open documents
        }
    },

    filetypes = { "cs", "vb" },  -- Filetypes handled by OmniSharp
    root_dir = function(fname)
        return lspconfig.util.root_pattern("*.sln", "*.csproj")(fname) or lspconfig.util.path.dirname(fname)
    end,
}
