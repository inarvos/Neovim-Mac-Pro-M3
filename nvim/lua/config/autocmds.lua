-- ~/.config/nvim/lua/config/autocmds.lua

local augroup = vim.api.nvim_create_augroup("UserAutocmds", { clear = true })

-- Highlight yanked text for quick visual feedback.
vim.api.nvim_create_autocmd("TextYankPost", {
	group = augroup,
	desc = "Highlight yanked text",
	callback = function()
		vim.hl.on_yank({ higroup = "IncSearch", timeout = 200 })
	end,
})

-- Ensure paste mode is disabled after leaving Insert mode.
vim.api.nvim_create_autocmd("InsertLeave", {
	group = augroup,
	desc = "Disable paste on InsertLeave",
	callback = function()
		vim.opt.paste = false
	end,
})
