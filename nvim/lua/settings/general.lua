-- lua/settings/general.lua

-- This file configures various general settings for Neovim.

-- Set default font for GUI clients like Neovide
if vim.fn.has('gui_running') == 1 then
    vim.o.guifont = 'Inarvos Nerd Font:h28'
end

-- Set script encoding to UTF-8
vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'        -- Set default encoding to UTF-8
vim.opt.fileencoding = 'utf-8'    -- Set file encoding to UTF-8

-- Enable line numbers and relative line numbers
vim.wo.number = true              -- Show line numbers
vim.wo.relativenumber = false     -- Show relative line numbers

vim.o.mouse = 'a'                 -- Enable mouse support in all modes

-- Undercurl settings for terminal
vim.cmd([[let &t_Cs = "\e[4:3m"]])  -- Enable undercurl
-- vim.cmd([[let &t_Ce = "\e[4:0m"]])  -- Disable undercurl

-- Enable syntax highlighting
vim.cmd('syntax on')
-- Enable spell checking globally
-- vim.opt.spell = true

-- Turn off paste mode when leaving insert mode
vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = '*',
    command = "set nopaste"
})

-- Highlight yanked text for 200ms using the "Visual" highlight group
vim.cmd [[
    augroup highlight_yank
        autocmd!
        au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=100})
    augroup END
]]

-- New OS window (Neovide) command
vim.cmd('command! NewWindow execute "!open -na Neovide"')

-- Colorscheme configuration
local status, _ = pcall(function() vim.cmd('colorscheme default') end)
if not status then
    print('Colorscheme not found!')
    return
end
