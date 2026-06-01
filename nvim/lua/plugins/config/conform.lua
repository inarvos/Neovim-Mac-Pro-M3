-- lua/plugins/config/conform.lua
-- Code formatting via conform.nvim.
--
-- Main behavior:
--   - typed :w formats before saving
--   - normal-mode w saves without formatting
--   - :Format remains available as an explicit manual formatter
--   - <leader>F is configured in the lazy.nvim plugin spec
--   - safe fallback to LSP formatting when no external formatter exists

local ok, conform = pcall(require, "conform")
if not ok then
	return
end

local disabled_filetypes = {
	["oil"] = true,
	["neo-tree"] = true,
	["lazy"] = true,
	["mason"] = true,
	["TelescopePrompt"] = true,
	["Trouble"] = true,
	["noice"] = true,
	["notify"] = true,
	["help"] = true,
}

local disabled_buftypes = {
	["nofile"] = true,
	["prompt"] = true,
	["quickfix"] = true,
	["terminal"] = true,
}

local function can_format(bufnr)
	-- Used by the normal-mode "w" mapping:
	-- save once without formatting, while typed :w still formats normally.
	if vim.b[bufnr].skip_format_on_save_once then
		return false
	end

	if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
		return false
	end

	if not vim.api.nvim_buf_is_valid(bufnr) then
		return false
	end

	if not vim.bo[bufnr].modifiable or vim.bo[bufnr].readonly then
		return false
	end

	local buftype = vim.bo[bufnr].buftype
	if disabled_buftypes[buftype] then
		return false
	end

	local filetype = vim.bo[bufnr].filetype
	if disabled_filetypes[filetype] then
		return false
	end

	local filename = vim.api.nvim_buf_get_name(bufnr)
	if filename == "" then
		return false
	end

	-- Avoid freezing Neovim on very large files.
	local ok_stat, stat = pcall(vim.uv.fs_stat, filename)
	if ok_stat and stat and stat.size and stat.size > 1024 * 1024 then
		return false
	end

	return true
end

local default_format_opts = {
	timeout_ms = 3000,
	async = false,
	quiet = false,
	lsp_format = "fallback",
}

local prettier = { "prettierd", "prettier", stop_after_first = true }

conform.setup({
	log_level = vim.log.levels.ERROR,
	notify_on_error = true,
	notify_no_formatters = false,

	default_format_opts = default_format_opts,

	formatters_by_ft = {
		lua = { "stylua" },

		python = function(bufnr)
			if conform.get_formatter_info("ruff_format", bufnr).available then
				return { "ruff_format" }
			end
			return { "black" }
		end,

		javascript = prettier,
		javascriptreact = prettier,
		typescript = prettier,
		typescriptreact = prettier,

		html = prettier,
		css = prettier,
		scss = prettier,
		json = prettier,
		jsonc = prettier,
		yaml = prettier,
		markdown = prettier,

		sh = { "shfmt" },
		bash = { "shfmt" },
		zsh = { "shfmt" },

		-- For filetypes without a dedicated formatter.
		["_"] = { "trim_whitespace", "trim_newlines" },
	},

	format_on_save = function(bufnr)
		if not can_format(bufnr) then
			return
		end

		return default_format_opts
	end,

	formatters = {
		shfmt = {
			append_args = { "-i", "4", "-ci" },
		},
	},
})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

vim.api.nvim_create_user_command("Format", function()
	conform.format({
		bufnr = vim.api.nvim_get_current_buf(),
		timeout_ms = 3000,
		async = false,
		quiet = false,
		lsp_format = "fallback",
	})
end, { desc = "Format current buffer" })

vim.api.nvim_create_user_command("FormatDisable", function(args)
	if args.bang then
		vim.b.disable_autoformat = true
		vim.notify("Autoformat disabled for this buffer", vim.log.levels.INFO)
	else
		vim.g.disable_autoformat = true
		vim.notify("Autoformat disabled globally", vim.log.levels.INFO)
	end
end, {
	bang = true,
	desc = "Disable autoformat. Use ! for buffer only",
})

vim.api.nvim_create_user_command("FormatEnable", function(args)
	if args.bang then
		vim.b.disable_autoformat = false
		vim.notify("Autoformat enabled for this buffer", vim.log.levels.INFO)
	else
		vim.g.disable_autoformat = false
		vim.notify("Autoformat enabled globally", vim.log.levels.INFO)
	end
end, {
	bang = true,
	desc = "Enable autoformat. Use ! for buffer only",
})

vim.api.nvim_create_user_command("FormatToggle", function()
	vim.g.disable_autoformat = not vim.g.disable_autoformat
	vim.notify(
		"Autoformat " .. (vim.g.disable_autoformat and "disabled" or "enabled") .. " globally",
		vim.log.levels.INFO
	)
end, { desc = "Toggle global autoformat" })
