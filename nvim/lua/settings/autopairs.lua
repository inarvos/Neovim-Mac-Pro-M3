-- lua/settings/autopairs.lua

-- This file configures the nvim-autopairs plugin to automatically insert matching pairs (e.g., brackets, quotes) in Neovim, including integration with nvim-cmp for autocompletion.

-- Load and configure nvim-autopairs plugin
require('nvim-autopairs').setup {
    check_ts = true,  -- Enable treesitter integration for better syntax awareness
    ts_config = {
        lua = {'string'},  -- Do not add pairs within string nodes in Lua
        javascript = {'template_string'},  -- Do not add pairs within template strings in JavaScript
        java = false,     -- Disable treesitter checks for Java
    },
    disable_filetype = { "TelescopePrompt" , "vim" },  -- Disable autopairs in specified filetypes
}

-- Integration with nvim-cmp (autocompletion plugin)
local cmp_autopairs = require('nvim-autopairs.completion.cmp')
local cmp = require('cmp')
cmp.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done()
)
