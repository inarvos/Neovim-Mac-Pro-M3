-- This init.lua file sets up Python and Ruby interpreters for Neovim, loads core settings, plugins, LSP configurations, and completion settings, and includes specific settings for Neovide if it’s being used.

-- Set the Python 3 interpreter for Neovim
vim.g.python3_host_prog = '~/.pyenv/versions/3.12.3/bin/python3'

-- Setup Ruby:
--vim.g.ruby_host_prog = '~/.rbenv/shims/neovim-ruby-host'
vim.g.ruby_host_prog = '~/.rbenv/versions/3.3.1/bin/neovim-ruby-host'
--vim.g.loaded_ruby_provider = 0

-- Load core settings
require('settings.options')
require('settings.keymaps')
require('settings.general')
require('settings.null-ls')
require('settings.colorizer')
require('settings.autopairs')

-- Source Neovide settings if running in Neovide
if vim.fn.exists('g:neovide') == 1 then
    require('settings.neovide')
    require('settings.gitsigns')
end

-- Load plugins
require('plugins')

-- Load LSP settings
require('lsp')

-- Load completion settings
require('completion.nvim-cmp')

-- Load snippets
--require('snippets.luasnip')
