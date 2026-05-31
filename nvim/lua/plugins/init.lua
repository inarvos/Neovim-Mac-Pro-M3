-- lua/plugins/init.lua
-- Plugin management via lazy.nvim.

-- Bootstrap lazy.nvim if it is not installed.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

	-- UI helpers
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			plugins = {
				presets = {
					operators = false,
				},
			},
		},
	},

	-- Icons
	{
		"nvim-tree/nvim-web-devicons",
		lazy = false,
	},

	-- Notifications
	{
		"rcarriga/nvim-notify",
		event = "VeryLazy",
		config = function()
			require("plugins.config.notify")
		end,
	},

	-- Modern dashboard and small UI helpers
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		keys = {
			{
				"<leader>hd",
				function()
					Snacks.dashboard.open()
				end,
				desc = "home: dashboard",
			},
			{
				"<leader>gg",
				function()
					Snacks.lazygit()
				end,
				desc = "git: lazygit",
			},
			{
				"<leader>gl",
				function()
					Snacks.lazygit.log()
				end,
				desc = "git: lazygit log",
			},
			{
				"<leader>gL",
				function()
					Snacks.lazygit.log_file()
				end,
				desc = "git: lazygit file log",
			},
		},
		opts = function()
			return require("plugins.config.snacks")
		end,
	},

	-- UI for messages/cmdline/popupmenu
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		config = function()
			require("plugins.config.noice")
		end,
	},

	-- Theme
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			vim.cmd.colorscheme("catppuccin")
		end,
	},

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		init = function()
			local treesitter_install_dir = vim.fn.fnamemodify(vim.fn.stdpath("data") .. "/site", ":p")

			if not vim.tbl_contains(vim.opt.runtimepath:get(), treesitter_install_dir) then
				vim.opt.runtimepath:prepend(treesitter_install_dir)
			end
		end,
		config = function()
			require("plugins.config.treesitter")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},

	-- Indent guides
	{
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("plugins.config.ibl")
		end,
	},

	-- Lua development for Neovim config
	{
		"folke/lazydev.nvim",
		ft = "lua",
		cmd = "LazyDev",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				{ path = "lazy.nvim", words = { "lazy" } },
				{ path = "snacks.nvim", words = { "Snacks" } },
			},
		},
	},

	-- LSP tooling
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"williamboman/mason.nvim",
				build = ":MasonUpdate",
				config = function()
					require("plugins.config.mason")
				end,
			},
			{ "mason-org/mason-lspconfig.nvim" },
			{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
		},
		config = function()
			require("lsp")
		end,
	},

	-- Formatting
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = {
			"ConformInfo",
			"Format",
			"FormatDisable",
			"FormatEnable",
			"FormatToggle",
		},
		keys = {
			{
				"<leader>F",
				function()
					require("conform").format({
						bufnr = vim.api.nvim_get_current_buf(),
						timeout_ms = 3000,
						async = false,
						quiet = false,
						lsp_format = "fallback",
					})
				end,
				mode = { "n", "v" },
				desc = "Format current buffer",
			},
		},
		config = function()
			require("plugins.config.conform")
		end,
	},

	-- Completion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
		},
		config = function()
			require("plugins.config.cmp")
		end,
	},

	-- Auto-pairs
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("plugins.config.autopairs")
		end,
	},

	-- Commenting
	{
		"numToStr/Comment.nvim",
		event = "VeryLazy",
		dependencies = { "folke/which-key.nvim" },
		config = function()
			require("Comment").setup({
				mappings = {
					basic = true,
					extra = false,
					extended = false,
				},
			})

			-- Remove prefix mappings that conflict with which-key group detection.
			pcall(vim.keymap.del, "n", "gb")
			pcall(vim.keymap.del, "x", "gb")

			-- Register groups for documentation only.
			pcall(function()
				require("lazy").load({ plugins = { "which-key.nvim" } })
				local wk = require("which-key")
				wk.add({
					{ "gc", group = "comment linewise" },
					{ "gb", group = "comment blockwise" },
				})
			end)
		end,
	},

	-- Statusline
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("plugins.config.lualine")
		end,
	},

	-- Fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			"nvim-telescope/telescope-ui-select.nvim",
			"nvim-telescope/telescope-project.nvim",
		},
		config = function()
			require("plugins.config.telescope")
		end,
	},

	-- File explorers
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		cmd = "Neotree",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("plugins.config.neotree")
		end,
	},
	{
		"nvim-mini/mini.nvim",
		version = "*",
		config = function()
			require("plugins.config.mini")
		end,
	},
	{
		"stevearc/oil.nvim",
		lazy = false,
		dependencies = { { "nvim-mini/mini.icons", opts = {} } },
		config = function()
			require("plugins.config.oil")
		end,
	},
	{
		"s1n7ax/nvim-window-picker",
		version = "2.*",
		config = function()
			require("plugins.config.window_picker")
		end,
	},

	-- Git integration
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("plugins.config.gitsigns")
		end,
	},

	{
		"sindrets/diffview.nvim",
		cmd = {
			"DiffviewOpen",
			"DiffviewClose",
			"DiffviewFileHistory",
			"DiffviewFocusFiles",
			"DiffviewToggleFiles",
			"DiffviewRefresh",
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		keys = {
			{ "<leader>gv", "<cmd>DiffviewOpen<cr>", desc = "git: diff view" },
			{ "<leader>gV", "<cmd>DiffviewClose<cr>", desc = "git: close diff view" },
			{ "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "git: current file history" },
			{ "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "git: repository history" },
		},
		opts = {
			enhanced_diff_hl = true,
			view = {
				default = {
					layout = "diff2_horizontal",
					disable_diagnostics = true,
				},
				file_history = {
					layout = "diff2_horizontal",
					disable_diagnostics = true,
				},
			},
		},
	},

	-- Diagnostics and lists UI
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		opts = {},
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "diagnostics (trouble)" },
			{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "buffer diagnostics (trouble)" },
			{ "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "symbols (trouble)" },
			{ "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "loclist (trouble)" },
			{ "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "qflist (trouble)" },
		},
	},

	-- Jump navigation
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"<leader>gs",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "flash jump",
			},
			{
				"<leader>gS",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "flash treesitter",
			},
		},
	},

	-- Session persistence
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = {},
		keys = {
			{
				"<leader>qs",
				function()
					require("persistence").load()
				end,
				desc = "restore session",
			},
			{
				"<leader>qS",
				function()
					require("persistence").select()
				end,
				desc = "select session",
			},
			{
				"<leader>ql",
				function()
					require("persistence").load({ last = true })
				end,
				desc = "restore last session",
			},
			{
				"<leader>qd",
				function()
					require("persistence").stop()
				end,
				desc = "disable session saving",
			},
		},
	},

	-- Neotest (Python)
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-neotest/neotest-python",
		},
		config = function()
			require("plugins.config.neotest")
		end,
		keys = {
			{
				"<leader>ttt",
				function()
					local nt = require("neotest")
					nt.summary.toggle()
				end,
				desc = "tests: summary",
			},
			{
				"<leader>ttr",
				function()
					local nt = require("neotest")
					nt.run.run()
				end,
				desc = "tests: run nearest",
			},
			{
				"<leader>ttR",
				function()
					local nt = require("neotest")
					nt.run.run(vim.fn.expand("%"))
				end,
				desc = "tests: run file",
			},
			{
				"<leader>tts",
				function()
					local nt = require("neotest")
					nt.run.stop()
				end,
				desc = "tests: stop",
			},
			{
				"<leader>tto",
				function()
					local nt = require("neotest")
					nt.output.open({ enter = true, auto_close = true })
				end,
				desc = "tests: output",
			},
			{
				"<leader>ttO",
				function()
					local nt = require("neotest")
					nt.output_panel.toggle()
				end,
				desc = "tests: output panel",
			},
		},
	},
}, {
	rocks = { enabled = false },
})
