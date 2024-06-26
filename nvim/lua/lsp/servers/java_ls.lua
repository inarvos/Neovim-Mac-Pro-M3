-- lua/lsp/servers/java_ls.lua

-- This file configures the Java language server (jdtls) for Neovim using the lspconfig plugin.

local lspconfig = require('lspconfig')

-- Path to the jdtls installation
local jdtls_path = '/opt/homebrew/Cellar/jdtls/1.36.0'  -- Adjust this to your actual path

-- Setup jdtls language server
lspconfig.jdtls.setup {
    cmd = {
        'java',
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xms1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
        '-jar', vim.fn.glob(jdtls_path .. '/libexec/plugins/org.eclipse.equinox.launcher_*.jar'),
        '-configuration', jdtls_path .. '/libexec/config_mac',  -- Adjust config_mac if necessary
        '-data', vim.fn.expand('~/.cache/jdtls/workspace/')  -- Path to the workspace
    },
    on_attach = require('settings.lsp').on_attach,  -- Function to run when the server attaches to a buffer
    capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),  -- Setup completion capabilities
    root_dir = function(fname)
        return lspconfig.util.root_pattern('.project', '.git', 'pom.xml', 'build.gradle')(fname) or lspconfig.util.path.dirname(fname)
    end,
    settings = {
        java = {
            signatureHelp = { enabled = true },
            contentProvider = { preferred = 'fernflower' },
        }
    },
    init_options = {
        bundles = {}
    },
}
