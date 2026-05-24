-- ~/.config/nvim/lua/config/options.lua
-- Core editor options.

local options = {
	general = {
		encoding = "utf-8",
		fileencoding = "utf-8",

		number = true,
		relativenumber = false,
		mouse = "a",

		virtualedit = "onemore",
		title = true,
		autoindent = true,
		smartindent = true,
		cursorline = true,
		hlsearch = true,
		backup = false,
		showcmd = true,
		cmdheight = 0,
		laststatus = 3,
		expandtab = true,
		inccommand = "split",
		ignorecase = true,
		smartcase = true,
		smarttab = true,
		breakindent = true,
		shiftwidth = 4,
		tabstop = 4,
		wrap = true,
		backspace = { "start", "eol", "indent" },
		splitright = true,
		splitbelow = true,
		clipboard = "unnamedplus",

		-- Allow cursor to reach the very top/bottom edges of the viewport.
		-- (Prevents early scrolling / "cursor stuck in middle" feel.)
		scrolloff = 0,
		sidescrolloff = 0,

		-- formatoptions is adjusted below to avoid overwriting defaults.
	},

	-- Completion/search UI behavior.
	search = {
		wildoptions = "pum",
	},

	ui = {
		termguicolors = true,
		background = "dark",
		signcolumn = "yes",
		winblend = 0,
		pumblend = 5,
	},

	backup = {
		backupskip = { "/tmp/*", "/private/tmp/*" },
	},
}

for _, opts in pairs(options) do
	for k, v in pairs(opts) do
		vim.opt[k] = v
	end
end

-- Additive option modifications (apply after the base options above).
vim.opt.path:append("**")

vim.opt.wildignore:append({
	"*/node_modules/*",
})

vim.opt.whichwrap:append("<>[]hl")

-- Ensure 'r' is enabled without clobbering other formatoptions defaults.
vim.opt.formatoptions:append("r")
