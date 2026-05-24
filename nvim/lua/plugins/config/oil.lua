-- ~/.config/nvim/lua/plugins/config/oil.lua
-- File explorer configuration via oil.nvim.

local oil = require("oil")

oil.setup({
	view_options = {
		show_hidden = false,
	},
	keymaps = {
		["H"] = "actions.toggle_hidden",
	},
})

vim.keymap.set("n", "-", "<CMD>Oil<CR>", {
	desc = "Oil: open parent directory",
	silent = true,
})

local oil_toggle_float = function()
	if vim.bo.filetype == "oil" then
		vim.cmd("close")
		return
	end

	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].filetype == "oil" then
			vim.api.nvim_set_current_win(win)
			vim.cmd("close")
			return
		end
	end

	vim.cmd("Oil --float")
end

vim.keymap.set("n", "<leader>o", oil_toggle_float, {
	desc = "Oil: toggle (float)",
	silent = true,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "oil",
	callback = function(args)
		vim.keymap.set("n", "t", function()
			require("oil").select({ tab = true })
		end, {
			buffer = args.buf,
			noremap = true,
			silent = true,
			nowait = true,
			desc = "Oil: open in new tab",
		})
	end,
})
