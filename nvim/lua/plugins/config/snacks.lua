-- lua/plugins/config/snacks.lua
-- Modern UI/helper modules via snacks.nvim.
--
-- Enabled in this stage:
--   dashboard  - startup screen
--   bigfile    - safer editing for very large files
--   quickfile  - faster startup when opening a file directly
--   input      - improved vim.ui.input
--
-- Intentionally NOT enabled yet:
--   picker, explorer, notifier, lazygit, indent, scroll, terminal, image.
-- These will be considered in later upgrade stages.

return {
	bigfile = {
		enabled = true,
		size = 1.5 * 1024 * 1024, -- 1.5 MB
		line_length = 1000,
	},

	quickfile = {
		enabled = true,
	},

	input = {
		enabled = true,
	},

	dashboard = {
		enabled = true,
		width = 64,

		preset = {
			header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝

       Mac Pro M3 • lazy.nvim • LSP • formatting
]],

			keys = {
				{
					icon = " ",
					key = "f",
					desc = "Find file",
					action = ":Telescope find_files",
				},
				{
					icon = " ",
					key = "g",
					desc = "Live grep",
					action = ":Telescope live_grep",
				},
				{
					icon = " ",
					key = "r",
					desc = "Recent files",
					action = ":Telescope oldfiles",
				},
				{
					icon = " ",
					key = "c",
					desc = "Open config",
					action = ":lua Snacks.dashboard.pick('files', { cwd = vim.fn.stdpath('config') })",
				},
				{
					icon = "󰒲 ",
					key = "l",
					desc = "Lazy plugins",
					action = ":Lazy",
				},
				{
					icon = "󰏖 ",
					key = "m",
					desc = "Mason tools",
					action = ":Mason",
				},
				{
					icon = " ",
					key = "h",
					desc = "Health check",
					action = ":checkhealth",
				},
				{
					icon = " ",
					key = "q",
					desc = "Quit",
					action = ":qa",
				},
			},
		},

		sections = {
			{ section = "header" },
			{ section = "keys", gap = 1, padding = 1 },
			{
				icon = " ",
				title = "Recent Files",
				section = "recent_files",
				indent = 2,
				padding = { 1, 1 },
			},
			{
				icon = " ",
				title = "Projects",
				section = "projects",
				indent = 2,
				padding = { 1, 1 },
			},
			{ section = "startup" },
		},
	},
}
