-- lua/plugins/config/ibl.lua
-- Indent guides via indent-blankline.nvim (ibl).

local ok, ibl = pcall(require, "ibl")
if not ok then
	return
end

ibl.setup({
	indent = { char = "▏" },
	scope = { enabled = true },
	exclude = {
		filetypes = {
			"help",
			"dashboard",
			"neo-tree",
			"oil",
			"terminal",
			"lazy",
			"mason",
		},
		buftypes = {
			"terminal",
			"nofile",
			"prompt",
			"quickfix",
		},
	},
})
