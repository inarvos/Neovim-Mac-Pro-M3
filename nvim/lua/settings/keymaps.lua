-- lua/settings/keymaps.lua

-- This file sets up custom key mappings for Neovim to improve productivity and navigation, including leader key configuration, window management, terminal handling, and plugin-specific keybindings.

-- Set leader key to space
vim.g.mapleader = " "

-- For conciseness
local keymap = vim.keymap

-- Navigation to line ends
-- Go to line ending: $, beginning: 0, first character: _
-- Go to line middle
keymap.set('', 'm', 'gM')

-- Next word navigation: W
-- Comments: 'gcc' and 'gc' in visual mode

-- Use hash
keymap.set('', '<opt>3', '#')

-- Delete single character without copying into register
keymap.set('n', 'x', '"_x')

-- Quit Neovim
keymap.set('n', 'q', ':q<cr>')
keymap.set('n', '<leader>qa', ':qa<cr>')

-- Save
keymap.set('n', 'w', ':w<cr>')

-- Key mappings for clipboard operations
local opts = { noremap = true, silent = true }

-- Map Cmd+v to paste the text from system clipboard
keymap.set('n', '<D-v>', '"+p', opts)
keymap.set('v', '<D-v>', '"+p', opts)
keymap.set('i', '<D-v>', '<C-r>+', opts)
keymap.set('c', '<D-v>', '<C-R>+', opts)

-- Open terminal
keymap.set("n", "<leader>tr", ":terminal<Return>")
-- Exit insert mode in terminal
keymap.set('t', '<ESC>', [[<C-\><C-n>]], { noremap = true })

-- Clear search highlights
keymap.set("n", "<leader>nh", ":nohl<cr>")

-- Increment/decrement numbers
keymap.set('n', '+', '<C-a>')
keymap.set('n', '-', '<C-x>')

-- Always delete the whole word using a custom function
keymap.set('n', '<leader>dw', ':lua delete_current_word()<CR>')

-- Select all text
keymap.set('n', '<D-a>', 'gg<S-v>G$')

-- Window management (split screen)
keymap.set('n', 'ss', ':split<Return>') -- Split window horizontally
keymap.set('n', 'sv', ':vsplit<Return><C-w>w') -- Split window vertically
keymap.set("n", "se", "<C-w>=") -- Make split windows equal width & height
keymap.set("n", "sq", ":close<CR>") -- Close current split window
keymap.set('n', '<leader>', '<C-w>w') -- Move between windows
-- Detach current file into a new Neovide OS window
keymap.set('n', '<leader>ww', ":let current_file = expand('%:p')<CR>:w<CR>:q!<CR>:execute '!neovide ' . shellescape(current_file) . ' &'<CR>", { noremap = true, silent = true })
-- New OS window (Neovide):
keymap.set('n', '<leader>wo', ':NewWindow<CR>', { noremap = true, silent = true })

-- Move between windows using leader key and arrow keys
keymap.set('', '<leader><up>', '<C-w><up>')
keymap.set('', '<leader><down>', '<C-w><down>')
keymap.set('', '<leader><left>', '<C-w><left>')
keymap.set('', '<leader><right>', '<C-w><right>')

-- Tabs management
keymap.set('n', 'te', ':tabedit<Return>') -- Edit new tab
keymap.set("n", "to", ":tabnew<CR>") -- Open new tab
keymap.set("n", "tc", ":tabclose<CR>") -- Close current tab
keymap.set("n", "tq", ":tabclose<CR>") -- Close current tab
keymap.set("n", "tn", ":tabn<CR>") -- Go to next tab
keymap.set("n", "<tab>", ":tabn<CR>") -- Go to next tab
keymap.set("n", "tp", ":tabp<CR>") -- Go to previous tab

----------------------
-- Plugin Keybinds
----------------------

-- nvim-tree
keymap.set("n", "<leader>nt", ":NvimTreeToggle<CR>") -- Toggle file explorer
keymap.set("n", "<leader>ne", ":NeoTreeFocusToggle<CR>") -- Toggle Neotree file explorer

-- telescope
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>") -- Find files within current working directory
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>") -- Find string in current working directory as you type
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>") -- Find string under cursor in current working directory
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>") -- List open buffers in current Neovim instance
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>") -- List available help tags

----------------------
-- Functions
----------------------

-- Function to delete the current word under the cursor
function _G.delete_current_word()
    local current_col = vim.fn.col('.')
    local line = vim.fn.getline('.')
    local line_len = #line
    local start_col, end_col

    -- Find the start and end of the word under the cursor
    local before = line:sub(1, current_col - 1):find('%w+$')
    if before then
        start_col = before
    else
        start_col = current_col
    end

    local after = line:sub(current_col):find('%W')
    if after then
        end_col = current_col + after - 2
    else
        end_col = line_len
    end

    -- Ensure end_col is within the line length
    if end_col > line_len then
        end_col = line_len
    end

    -- Delete the word
    vim.api.nvim_buf_set_text(0, vim.fn.line('.') - 1, start_col - 1, vim.fn.line('.') - 1, end_col, {""})

end
