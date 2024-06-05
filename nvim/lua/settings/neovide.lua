-- ~/.config/nvim/lua/settings/neovide.lua

-- This file configures settings specific to the Neovide GUI for Neovim, including window size and position, transparency, cursor effects, and other Neovide-specific options.

-- Remember the size and position of the Neovide window between sessions
vim.g.neovide_remember_window_size = true
vim.g.neovide_remember_window_position = true

-- Set the transparency level of the Neovide window (1.0 is fully opaque, 0.0 is fully transparent)
vim.g.neovide_transparency = 0.97

-- Set the background color with transparency (uncomment and adjust if needed)
-- vim.g.neovide_background_color = "#0f1117" .. string.format("%x", math.floor(255 * vim.g.neovide_transparency))

-- Enable Neovide cursor animation
vim.g.neovide_cursor_vfx_mode = "railgun"
-- Alternative cursor effects (uncomment one to use):
-- vim.g.neovide_cursor_vfx_mode = "sonicboom"
-- vim.g.neovide_cursor_vfx_mode = "torpedo"
-- vim.g.neovide_cursor_vfx_mode = "pixiedust"
-- vim.g.neovide_cursor_vfx_mode = "ripple"

-- Set the window refresh rate (uncomment and adjust if your monitor supports higher refresh rates)
-- vim.g.neovide_refresh_rate = 144

-- Scale factor for the UI (useful for high-DPI displays)
vim.g.neovide_scale_factor = 1.0

-- Enable fullscreen mode (uncomment to start Neovide in fullscreen)
-- vim.g.neovide_fullscreen = true

-- Padding around the Neovide window (uncomment and adjust if needed)
-- vim.g.neovide_padding_top = 10
-- vim.g.neovide_padding_bottom = 10
-- vim.g.neovide_padding_right = 10
-- vim.g.neovide_padding_left = 10

-- Custom settings for a more personalized experience (uncomment and modify as needed)
-- vim.g.neovide_no_idle = true  -- Disable idle when window is not in focus (can save power)
-- vim.g.neovide_cursor_trail_length = 0.8  -- Length of the cursor trail (default is 0.8)
-- vim.g.neovide_cursor_antialiasing = true  -- Enable anti-aliasing for the cursor

-- Additional performance optimizations (uncomment if you experience performance issues)
-- vim.g.neovide_no_idle = true  -- Disable idle when window is not in focus (can save power)
-- vim.g.neovide_confirm_quit = true  -- Confirm before quitting Neovide

-- Tips:
-- 1. Adjust the transparency level to your liking.
-- 2. Try different cursor effects and choose the one you prefer.
-- 3. Uncomment the refresh rate line if you have a high-refresh-rate monitor.
-- 4. Use the padding settings if you want some space around the Neovide window.

-- Command to open the current file in a new Neovide window
vim.api.nvim_create_user_command('OpenInNewWindow', function()
  local file_path = vim.fn.expand('%:p')
  vim.fn.system('neovide ' .. file_path)
end, {})
