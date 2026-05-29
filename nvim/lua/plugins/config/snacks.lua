-- lua/plugins/config/snacks.lua
-- Modern UI/helper modules via snacks.nvim.

return {
	bigfile = {
		enabled = true,
		size = 1.5 * 1024 * 1024,
		line_length = 1000,
	},

	quickfile = {
		enabled = true,
	},

	input = {
		enabled = true,
	},

	lazygit = {
		enabled = true,
		configure = true,
		config = {
			os = { editPreset = "nvim-remote" },
			gui = {
				nerdFontsVersion = "3",
			},
		},
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

       Mac Pro M3 • lazy.nvim • LSP • formatting • Git
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
					icon = " ",
					key = "G",
					desc = "LazyGit",
					action = ":lua Snacks.lazygit()",
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
