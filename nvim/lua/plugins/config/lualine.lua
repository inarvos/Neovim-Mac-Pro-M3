-- lua/plugins/config/lualine.lua
-- Professional statusline configuration.

local ok, lualine = pcall(require, "lualine")
if not ok then
	return
end

local function is_wide()
	return vim.o.columns > 100
end

local function is_medium()
	return vim.o.columns > 80
end

local function lsp_clients()
	local clients = vim.lsp.get_clients({ bufnr = 0 })

	if #clients == 0 then
		return "no lsp"
	end

	local names = {}
	local seen = {}

	for _, client in ipairs(clients) do
		local name = client.name

		if name ~= "null-ls" and name ~= "copilot" then
			if not seen[name] then
				table.insert(names, name)
				seen[name] = true
			end
		end
	end

	if #names == 0 then
		return "no lsp"
	end

	return table.concat(names, ", ")
end

local function formatter_status()
	local bufnr = vim.api.nvim_get_current_buf()

	if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
		return "fmt off"
	end

	local ok_conform, conform = pcall(require, "conform")
	if not ok_conform then
		return "fmt ?"
	end

	local ok_formatters, formatters = pcall(conform.list_formatters, bufnr)
	if not ok_formatters or not formatters or vim.tbl_isempty(formatters) then
		return "fmt none"
	end

	local names = {}
	local seen = {}

	for _, formatter in ipairs(formatters) do
		if formatter.available and not seen[formatter.name] then
			table.insert(names, formatter.name)
			seen[formatter.name] = true
		end
	end

	if #names == 0 then
		return "fmt none"
	end

	return table.concat(names, ", ")
end

local diagnostics_symbols = {
	error = " ",
	warn = " ",
	info = " ",
	hint = "󰌵 ",
}

lualine.setup({
	options = {
		icons_enabled = true,
		theme = "auto",
		globalstatus = true,

		component_separators = {
			left = "",
			right = "",
		},

		section_separators = {
			left = "",
			right = "",
		},

		disabled_filetypes = {
			statusline = {
				"snacks_dashboard",
				"dashboard",
				"alpha",
				"starter",
				"neo-tree",
				"lazy",
				"mason",
			},
			winbar = {},
		},

		always_divide_middle = true,
	},

	sections = {
		lualine_a = {
			{
				"mode",
			},
		},

		lualine_b = {
			{
				"branch",
				icon = "",
				cond = is_medium,
			},
			{
				"diff",
				symbols = {
					added = " ",
					modified = " ",
					removed = " ",
				},
				cond = is_wide,
			},
			{
				"diagnostics",
				sources = { "nvim_diagnostic" },
				symbols = diagnostics_symbols,
				colored = true,
				update_in_insert = false,
				always_visible = false,
			},
		},

		lualine_c = {
			{
				"filename",
				path = 1,
				symbols = {
					modified = " ●",
					readonly = " ",
					unnamed = "[No Name]",
					newfile = "[New]",
				},
			},
		},

		lualine_x = {
			{
				formatter_status,
				icon = "󰉼",
				cond = is_wide,
			},
			{
				lsp_clients,
				icon = "",
				cond = is_medium,
			},
			{
				"encoding",
				cond = is_wide,
			},
			{
				"fileformat",
				symbols = {
					unix = "LF",
					dos = "CRLF",
					mac = "CR",
				},
				cond = is_wide,
			},
			{
				"filetype",
				colored = true,
				icon_only = false,
			},
		},

		lualine_y = {
			{
				"progress",
			},
		},

		lualine_z = {
			{
				"location",
			},
		},
	},

	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {
			{
				"filename",
				path = 1,
			},
		},
		lualine_x = {
			"location",
		},
		lualine_y = {},
		lualine_z = {},
	},

	tabline = {},
	winbar = {},
	inactive_winbar = {},
	extensions = {},
})
