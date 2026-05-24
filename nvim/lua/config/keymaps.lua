-- ~/.config/nvim/lua/config/keymaps.lua
-- Custom key mappings.

local keymap = vim.keymap
local opts = { noremap = true, silent = true }

----------------------------------------------------------------------
-- Basics
----------------------------------------------------------------------

-- Jump to the middle of the line.
keymap.set("", "m", "gM")

-- Insert '#' via Option+3 in terminals where this mapping is needed.
keymap.set({ "n", "i", "c", "t" }, "<opt>3", "#")

-- Delete without yanking (prevents register/clipboard pollution).
keymap.set("v", "d", '"_d', { noremap = true, silent = true })
keymap.set("n", "dd", '"_dd', { noremap = true, silent = true })
keymap.set({ "n", "x" }, "D", '"_D', { noremap = true, silent = true })
vim.keymap.set({ "n", "x" }, "x", '"_x', { noremap = true, silent = true })
vim.keymap.set({ "n", "x" }, "X", '"_X', { noremap = true, silent = true })

-- Quit / quit all.
keymap.set("n", "q", ":q<cr>", opts)
keymap.set("n", "<leader>qa", ":qa<cr>", opts)

-- Save.
keymap.set("n", "w", ":w<cr>", opts)

-- Clear search highlight.
keymap.set("n", "<leader>nh", ":nohl<cr>", opts)

----------------------------------------------------------------------
-- Clipboard (Cmd+V / Cmd+A)
----------------------------------------------------------------------

keymap.set("n", "<D-v>", '"+p', opts)
keymap.set("v", "<D-v>", '"+p', opts)
keymap.set("i", "<D-v>", "<C-r>+", opts)
keymap.set("c", "<D-v>", "<C-r>+", opts)

-- Select all.
keymap.set("n", "<D-a>", "gg<S-v>G$", opts)

----------------------------------------------------------------------
-- Terminal
----------------------------------------------------------------------

-- Open a terminal buffer.
keymap.set("n", "<leader>tr", ":terminal<cr>", opts)

-- Exit terminal mode.
keymap.set("t", "<ESC>", [[<C-\><C-n>]], { noremap = true })

----------------------------------------------------------------------
-- Window management (splits)
----------------------------------------------------------------------

keymap.set("n", "ss", ":split<cr>", opts)
keymap.set("n", "sv", ":vsplit<cr>", opts)
keymap.set("n", "se", "<C-w>=", opts)
keymap.set("n", "sq", ":close<cr>", opts)

-- Move between splits.
keymap.set("n", "<leader><up>", "<C-w><up>", opts)
keymap.set("n", "<leader><down>", "<C-w><down>", opts)
keymap.set("n", "<leader><left>", "<C-w><left>", opts)
keymap.set("n", "<leader><right>", "<C-w><right>", opts)

-- Neovide: detach the current file into a new OS window.
keymap.set(
	"n",
	"<leader>ww",
	":let current_file = expand('%:p')<cr>:w<cr>:q!<cr>:execute '!neovide ' . shellescape(current_file) . ' &'<cr>",
	opts
)

-- Neovide: open a new OS window.
keymap.set("n", "<leader>wo", ":NewWindow<cr>", opts)

----------------------------------------------------------------------
-- Tabs
----------------------------------------------------------------------

keymap.set("n", "<leader>te", ":tabedit<cr>", opts)
keymap.set("n", "<leader>to", ":tabnew<cr>", opts)
keymap.set("n", "<leader>tq", ":tabclose<cr>", opts)
keymap.set("n", "<leader>tn", ":tabn<cr>", opts)
keymap.set("n", "<tab>", ":tabn<cr>", opts)
keymap.set("n", "<S-tab>", ":tabp<cr>", opts)
keymap.set("n", "<leader>tp", ":tabp<cr>", opts)

----------------------------------------------------------------------
-- Plugin keybinds
----------------------------------------------------------------------

-- File explorer.
keymap.set("n", "<leader>nt", ":Neotree toggle<cr>", opts)

-- Telescope.
keymap.set("n", "<leader>ff", ":Telescope find_files<cr>", opts)
keymap.set("n", "<leader>fs", ":Telescope live_grep<cr>", opts)
keymap.set("n", "<leader>fc", ":Telescope grep_string<cr>", opts)
keymap.set("n", "<leader>fb", ":Telescope buffers<cr>", opts)
keymap.set("n", "<leader>fh", ":Telescope help_tags<cr>", opts)
keymap.set("n", "<leader>fp", ":Telescope project<cr>", opts)

----------------------------------------------------------------------
-- Functions
----------------------------------------------------------------------

function _G.delete_current_word()
	local current_col = vim.fn.col(".")
	local line = vim.fn.getline(".")
	local line_len = #line
	local start_col, end_col

	local before = line:sub(1, current_col - 1):find("%w+$")
	if before then
		start_col = before
	else
		start_col = current_col
	end

	local after = line:sub(current_col):find("%W")
	if after then
		end_col = current_col + after - 2
	else
		end_col = line_len
	end

	if end_col > line_len then
		end_col = line_len
	end

	vim.api.nvim_buf_set_text(0, vim.fn.line(".") - 1, start_col - 1, vim.fn.line(".") - 1, end_col, { "" })
end

-- Delete the word under the cursor.
keymap.set("n", "<leader>dw", ":lua delete_current_word()<cr>", opts)

-- Keep selection when indenting in Visual mode.
keymap.set("v", "<", "<gv", opts)
keymap.set("v", ">", ">gv", opts)
