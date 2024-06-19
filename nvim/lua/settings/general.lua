-- lua/settings/general.lua

-- This file sets up general settings for Neovim, including GUI-specific settings, leader key configuration, autocommands for paste mode and highlighting, and colorscheme configuration.

-- Set default font for GUI clients like Neovide
if vim.fn.has('gui_running') == 1 then
    vim.o.guifont = 'Inarvos Nerd Font:h28'
end

-- Add more general settings here

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
