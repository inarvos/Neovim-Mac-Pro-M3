-- lua/settings/options.lua

-- This file sets various Neovim options to enhance the editing experience.

local options = {
    general = {
        title = true,             -- Show title of the file in the title bar
        autoindent = true,        -- Copy indent from current line when starting a new line
        smartindent = true,       -- Smart autoindenting when starting a new line
        cursorline = true,        -- Highlight the screen line of the cursor
        hlsearch = true,          -- Highlight all matches of search pattern
        backup = false,           -- Disable backup file creation
        showcmd = true,           -- Show (partial) command in the last line of the screen
        cmdheight = 1,            -- Number of screen lines to use for the command-line
        laststatus = 2,           -- Always display the status line
        expandtab = true,         -- Use spaces instead of tabs
        inccommand = 'split',     -- Show effects of command incrementally as you type
        ignorecase = true,        -- Ignore case in search patterns
        smartcase = true,         -- Override 'ignorecase' if search pattern contains uppercase letters
        smarttab = true,          -- Insert tabs on the start of a line according to 'shiftwidth'
        breakindent = true,       -- Preserve indentation of a virtual line
        shiftwidth = 4,           -- Number of spaces to use for each step of (auto)indent
        tabstop = 4,              -- Number of spaces that a <Tab> counts for
        wrap = true,              -- Wrap long lines
        backspace = { 'start', 'eol', 'indent' },  -- Allow backspacing over everything in insert mode
        splitright = false,       -- Vertical splits open to the left of the current window
        splitbelow = false,       -- Horizontal splits open above the current window
        clipboard = 'unnamedplus',  -- Use the system clipboard as the default register
        formatoptions = 'r',      -- Add asterisks in block comments
    },
    search = {
        path = { '**' },          -- Search down into subfolders
        wildignore = { '*/node_modules/*' },  -- Ignore node_modules directory when searching
    },
    ui = {
        termguicolors = true,     -- Enable 24-bit RGB colors
        background = 'dark',      -- Use dark background
        signcolumn = 'yes',       -- Always show the sign column
        winblend = 0,             -- Disable window transparency
        wildoptions = 'pum',      -- Display completion matches using a popup menu
        pumblend = 5,             -- Set popup menu transparency
    },
    backup = {
        backupskip = { '/tmp/*', '/private/tmp/*' } -- Don't make backup files for temporary files
    },
}

for group, opts in pairs(options) do
    for k, v in pairs(opts) do
        vim.opt[k] = v
    end
end

vim.opt.whichwrap:append("<>[]hl")  -- Allow movement keys to wrap to previous/next line when cursor is on the first/last character in the line
