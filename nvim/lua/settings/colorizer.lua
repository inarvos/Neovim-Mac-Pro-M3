-- lua/settings/colorizer.lua

-- This file configures the nvim-colorizer plugin to highlight color codes in various formats within Neovim, and enables the plugin for common web development file types.

-- Load and configure nvim-colorizer plugin
require'colorizer'.setup(
    {'*';},  -- Enable colorizer for all file types by default
    {
        RGB      = true;         -- Highlight #RGB hex codes
        RRGGBB   = true;         -- Highlight #RRGGBB hex codes
        names    = true;         -- Highlight named colors (e.g., Blue, blue)
        RRGGBBAA = true;         -- Highlight #RRGGBBAA hex codes
        rgb_fn   = true;         -- Highlight CSS rgb() and rgba() functions
        hsl_fn   = true;         -- Highlight CSS hsl() and hsla() functions
        css      = true;         -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
        css_fn   = true;         -- Enable all CSS functions: rgb_fn, hsl_fn
        mode     = 'background'; -- Display colors in the background
    }
)

-- Enable colorizer for specific file types
vim.cmd 'autocmd FileType css,scss,javascript,html,typescript lua require"colorizer".attach_to_buffer()'
