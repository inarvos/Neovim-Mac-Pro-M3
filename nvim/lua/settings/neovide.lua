-- ~/.config/nvim/lua/settings/neovide.lua

-- This file configures settings specific to the Neovide GUI for Neovim, including window size and position, transparency, cursor effects, and other Neovide-specific options.



-- vim.opt.linespace = 5 -- Controls spacing between lines, may also be negative (removes the meeting page)
-- vim.g.neovide_scale_factor = 1.0 --In addition to setting the font itself, this setting allows to change the scale without changing the whole font definition. 

-- Text Gamma and Contrast
-- vim.g.neovide_text_gamma = 0.0
-- vim.g.neovide_text_contrast = 0

-- Padding around the Neovide window (uncomment and adjust if needed)
vim.g.neovide_padding_top = 10
-- vim.g.neovide_padding_bottom = 1
-- vim.g.neovide_padding_right = 1
-- vim.g.neovide_padding_left = -1

-- Set the transparency level of the Neovide window (1.0 is fully opaque, 0.0 is fully transparent)
vim.g.neovide_transparency = 0.6

-- Setting g:neovide_window_blurred toggles the window blur state
vim.g.neovide_window_blurred = true
-- Floating Blur Ammount
vim.g.neovide_floating_blur_amount_x = 2.0
vim.g.neovide_floating_blur_amount_y = 2.0
-- Setting g:neovide_floating_blur_amount_x and g:neovide_floating_blur_amount_y controls the blur radius on the respective axis for floating windows.

-- Hiding the mouse when typing
vim.g.neovide_hide_mouse_when_typing = true

-- Set the background option when Neovide starts. Possible values: light, dark, auto
vim.g.neovide_theme = 'dark'

-- Enable fullscreen mode (uncomment to start Neovide in fullscreen)
-- vim.g.neovide_fullscreen = true

-- Remember the size and position of the Neovide window between sessions. Default value true for both
-- vim.g.neovide_remember_window_size = false
-- vim.g.neovide_remember_window_position = false

-- Set the window refresh rate (uncomment and adjust if your monitor supports higher refresh rates)
-- vim.g.neovide_refresh_rate = 144

-- Setting this to v:true enables the profiler, which shows a frametime graph in the upper left corner.
vim.g.neovide_profiler = false

-- Enables or disables antialiasing of the cursor quad. Disabling may fix some cursor visual issues.
vim.g.neovide_cursor_antialiasing = true

-- Enable Neovide cursor animation
vim.g.neovide_cursor_vfx_mode = "railgun"
-- Alternative cursor effects (uncomment one to use):
-- vim.g.neovide_cursor_vfx_mode = "sonicboom"
-- vim.g.neovide_cursor_vfx_mode = "torpedo"
-- vim.g.neovide_cursor_vfx_mode = "pixiedust"
-- vim.g.neovide_cursor_vfx_mode = "ripple"

-- Scale factor for the UI (useful for high-DPI displays)
vim.g.neovide_scale_factor = 1.0

-- Custom settings for a more personalized experience (uncomment and modify as needed)
-- vim.g.neovide_no_idle = true  -- Disable idle when window is not in focus (can save power)
-- vim.g.neovide_cursor_trail_length = 0.8  -- Length of the cursor trail (default is 0.8)
-- vim.g.neovide_cursor_antialiasing = true  -- Enable anti-aliasing for the cursor

-- Additional performance optimizations (uncomment if you experience performance issues)
-- vim.g.neovide_no_idle = true  -- Disable idle when window is not in focus (can save power)
-- vim.g.neovide_confirm_quit = true  -- Confirm before quitting Neovide

-- Command to open the current file in a new Neovide window
vim.api.nvim_create_user_command('OpenInNewWindow', function()
    local file_path = vim.fn.expand('%:p')
    vim.fn.system('neovide ' .. file_path)
end, {})

-- Colorscheme configuration
local status, _ = pcall(function() vim.cmd('colorscheme default') end)
if not status then
    print('Colorscheme not found!')
    return
end
