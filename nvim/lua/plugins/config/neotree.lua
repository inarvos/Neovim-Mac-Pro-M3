-- ~/.config/nvim/lua/plugins/config/neotree.lua
-- File explorer configuration via neo-tree.nvim.

require("neo-tree").setup({
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
			["<cr>"] = "open_with_window_picker",
			["o"] = "open",
			["s"] = "open_split",
			["v"] = "open_vsplit",
			["t"] = "open_tabnew",
		},
	},
})
