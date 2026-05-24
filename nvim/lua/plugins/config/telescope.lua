-- ~/.config/nvim/lua/plugins/config/telescope.lua
-- Finder and picker configuration via telescope.nvim.

local ok, telescope = pcall(require, "telescope")
if not ok then
	return
end

local actions_ok, actions = pcall(require, "telescope.actions")
if not actions_ok then
	return
end

local themes = require("telescope.themes")

telescope.setup({
	defaults = {
		path_display = { "smart" },
		mappings = {
			i = {
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
				["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
				["<C-x>"] = actions.select_horizontal,
				["<C-v>"] = actions.select_vertical,
				["<C-t>"] = actions.select_tab,
			},
			n = {
				["q"] = actions.close,
				["<C-x>"] = actions.select_horizontal,
				["<C-v>"] = actions.select_vertical,
				["<C-t>"] = actions.select_tab,
			},
		},
	},
	pickers = {
		find_files = {
			hidden = true,
		},
	},
	extensions = {
		["ui-select"] = themes.get_dropdown({}),
		project = {
			theme = "dropdown",
			order_by = "recent",
			search_by = { "title", "path" },
		},
	},
})

pcall(telescope.load_extension, "fzf")
pcall(telescope.load_extension, "ui-select")
pcall(telescope.load_extension, "project")
