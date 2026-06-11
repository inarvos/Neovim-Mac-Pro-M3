-- ~/.config/nvim/lua/plugins/config/neotree.lua
-- File explorer configuration via neo-tree.nvim.

require("neo-tree").setup({
	open_files_do_not_replace_types = {
		"terminal",
		"Trouble",
		"qf",
		"edgy",
	},

	close_if_last_window = true,
	popup_border_style = "rounded",

	filesystem = {
		follow_current_file = { enabled = true },
		hijack_netrw_behavior = "open_default",
	},

	window = {
		position = "right",
		width = 25,

		mappings = {
			["<cr>"] = "open",
			["o"] = "open",
			["s"] = "open_split",
			["v"] = "open_vsplit",
			["t"] = "open_tabnew",
		},
	},
})
