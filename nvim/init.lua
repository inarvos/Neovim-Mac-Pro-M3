-- This init.lua loads core settings, LSP configurations, and completion settings, and includes specific settings for Neovide if it’s being used.

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
