-- lua/lsp/servers/python_ls.lua

-- This file configures the Python language server (pylsp) for Neovim using the lspconfig plugin.

-- Set the Python 3 interpreter for Neovim
vim.g.python3_host_prog = '~/.pyenv/versions/3.12.4/bin/python3'
-- vim.g.python3_host_prog = '~/.pyenv/versions/brew_python3/bin/python3'
-- Homebrew requires everything to be installed in virtual environment

local lspconfig = require('lspconfig')

-- Setup Python language server (pylsp)
-- Ensure you have installed pylsp using Homebrew: brew install python-lsp-server
lspconfig.pylsp.setup {
    cmd = { "pylsp" },  -- Command to start pylsp
    on_attach = require('settings.lsp').on_attach,  -- Function to run when the server attaches to a buffer
    capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities()),  -- Setup completion capabilities

    settings = {
        pylsp = {
            plugins = {
                pycodestyle = {
                    enabled = true,
                    ignore = {'W391'},  -- Example: ignore trailing whitespace warning
                    maxLineLength = 88
                },
                pyflakes = {
                    enabled = true
                },
                pylint = {
                    enabled = false  -- You can enable pylint if you prefer
                },
                yapf = {
                    enabled = true
                },
                pyls_isort = {
                    enabled = true
                },
                mccabe = {
                    enabled = true
                },
                rope_completion = {
                    enabled = true
                }
            }
        }
    },

    filetypes = { "python" },  -- Filetypes handled by pylsp
    root_dir = function(fname)
        return lspconfig.util.root_pattern(".git", "setup.py", "setup.cfg", "pyproject.toml", "requirements.txt")(fname) or lspconfig.util.path.dirname(fname)
    end,
}
