-- lua/utils.lua

-- This file provides utility functions for Neovim configuration, including functions to reload the configuration, check if a plugin is installed, and set key mappings.

-- Add any utility functions you need

-- Reload Neovim configuration
-- This function reloads the Neovim configuration by clearing the package cache
-- and re-executing the main configuration file.
function ReloadConfig()
  for name,_ in pairs(package.loaded) do
    if name:match('^cnull') then
      package.loaded[name] = nil
    end
  end
  dofile(vim.env.MYVIMRC)
end

-- Check if a plugin is installed
-- This function checks if a plugin is installed by verifying the existence
-- of its directory in the packer start directory.
function IsPluginInstalled(name)
  local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/' .. name
  return vim.fn.empty(install_path) == 0
end

-- Keymap helper function
-- This function helps in setting key mappings in a simpler way.
-- It takes the mode (e.g., 'n' for normal mode), the key combination (lhs),
-- the command or mapping (rhs), and optional settings (opts).
function Map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end
