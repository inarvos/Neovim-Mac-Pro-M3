-- lua/settings/options.lua

-- This file sets various Neovim options for better editing experience, including encoding settings, line numbers, indentation, search behavior, clipboard integration, and more.

-- Set script encoding to UTF-8
vim.scriptencoding = 'utf-8'
vim.opt.encoding = 'utf-8'        -- Set default encoding to UTF-8
vim.opt.fileencoding = 'utf-8'    -- Set file encoding to UTF-8

-- Enable line numbers and relative line numbers
vim.wo.number = true              -- Show line numbers
vim.wo.relativenumber = false     -- Show relative line numbers

-- Set general editor options
vim.opt.title = true              -- Show title of the file in the title bar
vim.opt.autoindent = true         -- Copy indent from current line when starting a new line
vim.opt.smartindent = true        -- Smart autoindenting when starting a new line
vim.opt.cursorline = true         -- Highlight the screen line of the cursor
vim.opt.hlsearch = true           -- Highlight all matches of search pattern
vim.opt.backup = false            -- Disable backup file creation
vim.opt.showcmd = true            -- Show (partial) command in the last line of the screen
vim.opt.cmdheight = 1             -- Number of screen lines to use for the command-line
vim.opt.laststatus = 2            -- Always display the status line
vim.opt.expandtab = true          -- Use spaces instead of tabs
vim.opt.backupskip = { '/tmp/*', '/private/tmp/*' }  -- Don't make backup files for temporary files
vim.opt.inccommand = 'split'      -- Show effects of command incrementally as you type
vim.opt.ignorecase = true         -- Ignore case in search patterns
vim.opt.smartcase = true          -- Override 'ignorecase' if search pattern contains uppercase letters
vim.opt.smarttab = true           -- Insert tabs on the start of a line according to 'shiftwidth'
vim.opt.breakindent = true        -- Preserve indentation of a virtual line
vim.opt.shiftwidth = 4            -- Number of spaces to use for each step of (auto)indent
vim.opt.tabstop = 4               -- Number of spaces that a <Tab> counts for
vim.opt.wrap = true               -- Wrap long lines
vim.opt.whichwrap:append "<>[]hl" -- Allow movement keys to wrap to previous/next line when cursor is on the first/last character in the line
vim.opt.backspace = { 'start', 'eol', 'indent' }  -- Allow backspacing over everything in insert mode
vim.opt.path:append { '**' }      -- Search down into subfolders
vim.opt.wildignore:append { '*/node_modules/*' }  -- Ignore node_modules directory when searching
vim.opt.splitright = false        -- Vertical splits open to the left of the current window
vim.opt.splitbelow = false        -- Horizontal splits open above the current window
vim.opt.clipboard:append("unnamedplus")  -- Use the system clipboard as the default register
vim.o.mouse = 'a'                 -- Enable mouse support in all modes

-- Undercurl settings for terminal
vim.cmd([[let &t_Cs = "\e[4:3m"]])  -- Enable undercurl
-- vim.cmd([[let &t_Ce = "\e[4:0m"]])  -- Disable undercurl

-- Enable syntax highlighting
vim.cmd('syntax on')

-- Add asterisks in block comments
vim.opt.formatoptions:append { 'r' }

-- Enable true color support
vim.opt.termguicolors = true       -- Enable 24-bit RGB colors
vim.opt.background = 'dark'        -- Use dark background
vim.opt.signcolumn = 'yes'         -- Always show the sign column
vim.opt.winblend = 0               -- Disable window transparency
vim.opt.wildoptions = 'pum'        -- Display completion matches using a popup menu
vim.opt.pumblend = 5               -- Set popup menu transparency

-- Function to add options
local Type = {GLOBAL_OPTION = "o", WINDOW_OPTION = "wo", BUFFER_OPTION = "bo"}
local add_options = function(option_type, options)
  if type(options) ~= "table" then
    error 'options should be a type of "table"'
    return
  end
  local vim_option = vim[option_type]
  for key, value in pairs(options) do
    vim_option[key] = value
  end
end

-- Add global options using the function
local Option = {}
Option.g = function(options)
  add_options(Type.GLOBAL_OPTION, options)
end

Option.g {
  virtualedit = "onemore",  -- Allow cursor to move one character past the end of the line
}
