-- lua/plugins/config/treesitter.lua
-- Tree-sitter configuration (nvim-treesitter main branch) and textobjects.

local ts_ok, ts = pcall(require, "nvim-treesitter")
if not ts_ok then
	return
end

-- Parsers to install via :TSInstallMyParsers.
local ensure_installed = {
	"lua",
	"vim",
	"vimdoc",
	"query",

	"markdown",
	"markdown_inline",
    "latex",

	"bash",
	"zsh",
	"fish",
	"json",
	"yaml",
	"regex",

	"html",
	"css",
	"javascript",
	"typescript",

	"python",
}

local treesitter_install_dir = vim.fn.stdpath("data") .. "/site"

ts.setup({
	install_dir = treesitter_install_dir,
})

vim.api.nvim_create_user_command("TSInstallMyParsers", function()
	ts.install(ensure_installed):wait(300000)
end, {
	desc = "Install Tree-sitter parsers from the configured list",
})

-- Enable Tree-sitter highlighting when a parser is available.
-- This deliberately skips plugin/UI buffers such as Noice, Neo-tree, Lazy, Mason, etc.
local group = vim.api.nvim_create_augroup("UserTreesitter", { clear = true })

local ignored_buftypes = {
	nofile = true,
	prompt = true,
	quickfix = true,
	terminal = true,
}

local ignored_filetypes = {
	noice = true,
	notify = true,
	["neo-tree"] = true,
	NvimTree = true,
	lazy = true,
	mason = true,
	qf = true,
	TelescopePrompt = true,
	TelescopeResults = true,
}

vim.api.nvim_create_autocmd("FileType", {
	group = group,
	desc = "Enable Tree-sitter highlighting when supported",
	callback = function(args)
		local buf = args.buf

		if not vim.api.nvim_buf_is_valid(buf) then
			return
		end

		local buftype = vim.bo[buf].buftype
		if ignored_buftypes[buftype] then
			return
		end

		local ft = vim.bo[buf].filetype
		if not ft or ft == "" or ignored_filetypes[ft] then
			return
		end

		local name = vim.api.nvim_buf_get_name(buf)
		if name ~= "" then
			local ok_stat, stat = pcall(vim.uv.fs_stat, name)
			if ok_stat and stat and stat.size and stat.size > 1024 * 1024 then
				return
			end
		end

		local ok_lang, lang = pcall(vim.treesitter.language.get_lang, ft)
		if not ok_lang or not lang then
			return
		end

		pcall(vim.treesitter.start, buf, lang)
	end,
})

-- nvim-treesitter-textobjects
local to_ok, to = pcall(require, "nvim-treesitter-textobjects")
if to_ok then
	to.setup({
		select = {
			lookahead = true,
			selection_modes = {
				["@parameter.outer"] = "v",
				["@function.outer"] = "V",
				["@class.outer"] = "",
			},
			include_surrounding_whitespace = false,
		},
		move = {
			set_jumps = true,
		},
	})

	local function select_textobj(query, group_name)
		return function()
			require("nvim-treesitter-textobjects.select").select_textobject(query, group_name)
		end
	end

	vim.keymap.set(
		{ "x", "o" },
		"af",
		select_textobj("@function.outer", "textobjects"),
		{ desc = "ts: function outer" }
	)
	vim.keymap.set(
		{ "x", "o" },
		"if",
		select_textobj("@function.inner", "textobjects"),
		{ desc = "ts: function inner" }
	)
	vim.keymap.set({ "x", "o" }, "ac", select_textobj("@class.outer", "textobjects"), { desc = "ts: class outer" })
	vim.keymap.set({ "x", "o" }, "ic", select_textobj("@class.inner", "textobjects"), { desc = "ts: class inner" })

	vim.keymap.set(
		{ "x", "o" },
		"aa",
		select_textobj("@parameter.outer", "textobjects"),
		{ desc = "ts: parameter outer" }
	)
	vim.keymap.set(
		{ "x", "o" },
		"ia",
		select_textobj("@parameter.inner", "textobjects"),
		{ desc = "ts: parameter inner" }
	)

	local function move_next_start(query, group_name)
		return function()
			require("nvim-treesitter-textobjects.move").goto_next_start(query, group_name)
		end
	end

	local function move_prev_start(query, group_name)
		return function()
			require("nvim-treesitter-textobjects.move").goto_previous_start(query, group_name)
		end
	end

	local function move_next_end(query, group_name)
		return function()
			require("nvim-treesitter-textobjects.move").goto_next_end(query, group_name)
		end
	end

	local function move_prev_end(query, group_name)
		return function()
			require("nvim-treesitter-textobjects.move").goto_previous_end(query, group_name)
		end
	end

	vim.keymap.set(
		{ "n", "x", "o" },
		"]m",
		move_next_start("@function.outer", "textobjects"),
		{ desc = "ts: next function start" }
	)
	vim.keymap.set(
		{ "n", "x", "o" },
		"[m",
		move_prev_start("@function.outer", "textobjects"),
		{ desc = "ts: prev function start" }
	)
	vim.keymap.set(
		{ "n", "x", "o" },
		"]M",
		move_next_end("@function.outer", "textobjects"),
		{ desc = "ts: next function end" }
	)
	vim.keymap.set(
		{ "n", "x", "o" },
		"[M",
		move_prev_end("@function.outer", "textobjects"),
		{ desc = "ts: prev function end" }
	)

	vim.keymap.set(
		{ "n", "x", "o" },
		"]]",
		move_next_start("@class.outer", "textobjects"),
		{ desc = "ts: next class start" }
	)
	vim.keymap.set(
		{ "n", "x", "o" },
		"[[",
		move_prev_start("@class.outer", "textobjects"),
		{ desc = "ts: prev class start" }
	)
	vim.keymap.set(
		{ "n", "x", "o" },
		"][",
		move_next_end("@class.outer", "textobjects"),
		{ desc = "ts: next class end" }
	)
	vim.keymap.set(
		{ "n", "x", "o" },
		"[]",
		move_prev_end("@class.outer", "textobjects"),
		{ desc = "ts: prev class end" }
	)

	vim.keymap.set("n", "<leader>sp", function()
		require("nvim-treesitter-textobjects.swap").swap_next("@parameter.inner")
	end, { desc = "ts: swap next parameter" })

	vim.keymap.set("n", "<leader>sP", function()
		require("nvim-treesitter-textobjects.swap").swap_previous("@parameter.inner")
	end, { desc = "ts: swap prev parameter" })

	local rep_ok, rep = pcall(require, "nvim-treesitter-textobjects.repeatable_move")
	if rep_ok then
		vim.keymap.set(
			{ "n", "x", "o" },
			";",
			rep.repeat_last_move_next,
			{ expr = true, desc = "ts: repeat move next" }
		)
		vim.keymap.set(
			{ "n", "x", "o" },
			",",
			rep.repeat_last_move_previous,
			{ expr = true, desc = "ts: repeat move prev" }
		)
	end
end
