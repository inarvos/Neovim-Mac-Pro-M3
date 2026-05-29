-- lua/plugins/config/gitsigns.lua
-- Git signs, hunk navigation, blame, staging, and reset actions.

local ok, gitsigns = pcall(require, "gitsigns")
if not ok then
	return
end

gitsigns.setup({
	signs = {
		add = { text = "▎" },
		change = { text = "▎" },
		delete = { text = "" },
		topdelete = { text = "" },
		changedelete = { text = "▎" },
		untracked = { text = "▎" },
	},

	signcolumn = true,
	numhl = false,
	linehl = false,
	word_diff = false,

	watch_gitdir = {
		follow_files = true,
	},

	attach_to_untracked = true,
	current_line_blame = false,

	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "eol",
		delay = 700,
		ignore_whitespace = false,
	},

	current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",

	sign_priority = 6,
	update_debounce = 100,
	max_file_length = 40000,

	preview_config = {
		border = "rounded",
		style = "minimal",
		relative = "cursor",
		row = 0,
		col = 1,
	},

	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		local function map(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, {
				buffer = bufnr,
				noremap = true,
				silent = true,
				desc = desc,
			})
		end

		-- Hunk navigation.
		map("n", "]g", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]c", bang = true })
			else
				gs.nav_hunk("next")
			end
		end, "git: next hunk")

		map("n", "[g", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[c", bang = true })
			else
				gs.nav_hunk("prev")
			end
		end, "git: previous hunk")

		-- Hunk actions.
		map("n", "<leader>ga", gs.stage_hunk, "git: stage hunk")
		map("n", "<leader>gu", gs.undo_stage_hunk, "git: undo stage hunk")
		map("n", "<leader>gR", gs.reset_buffer, "git: reset buffer")
		map("n", "<leader>gp", gs.preview_hunk, "git: preview hunk")

		map("v", "<leader>ga", function()
			gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, "git: stage selected hunk")

		map("v", "<leader>gR", function()
			gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, "git: reset selected hunk")

		-- Blame and diff.
		map("n", "<leader>gb", function()
			gs.blame_line({ full = true })
		end, "git: blame line")

		map("n", "<leader>gB", gs.toggle_current_line_blame, "git: toggle blame")
		map("n", "<leader>gw", gs.toggle_word_diff, "git: toggle word diff")

		map("n", "<leader>g=", gs.diffthis, "git: diff this")
		map("n", "<leader>g~", function()
			gs.diffthis("~")
		end, "git: diff against previous revision")
	end,
})
