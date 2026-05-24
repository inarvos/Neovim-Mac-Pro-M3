-- lua/plugins/config/mason.lua
-- External tool management via Mason (LSP servers, formatters, linters).

local ok_mason, mason = pcall(require, "mason")
if not ok_mason then
	return
end

mason.setup({
	ui = { border = "rounded" },
})

local function filter_valid_servers(servers)
	local ok_map, server_map = pcall(require, "mason-lspconfig.mappings.server")
	if not ok_map or not server_map or not server_map.lspconfig_to_package then
		return servers
	end

	local out = {}
	for _, name in ipairs(servers) do
		if server_map.lspconfig_to_package[name] ~= nil then
			table.insert(out, name)
		end
	end
	return out
end

local function pick_ts_server()
	local ok_map, server_map = pcall(require, "mason-lspconfig.mappings.server")
	if not ok_map or not server_map or not server_map.lspconfig_to_package then
		return "ts_ls"
	end

	if server_map.lspconfig_to_package["ts_ls"] ~= nil then
		return "ts_ls"
	end

	if server_map.lspconfig_to_package["tsserver"] ~= nil then
		return "tsserver"
	end

	return nil
end

local ts_server = pick_ts_server()

local lsp_servers = {
	"lua_ls",
	"pyright",
	"clangd",
	"omnisharp",
	"jdtls",
	"eslint",
	"html",
	"cssls",
	"jsonls",
}

if ts_server then
	table.insert(lsp_servers, ts_server)
end

lsp_servers = filter_valid_servers(lsp_servers)

pcall(function()
	local mlsp = require("mason-lspconfig")
	mlsp.setup({
		ensure_installed = lsp_servers,
		automatic_installation = true,
	})
end)

pcall(function()
	local mti = require("mason-tool-installer")
	mti.setup({
		ensure_installed = {
			"stylua",
			"black",
			"ruff",
			"prettier",
			"prettierd",
			"shfmt",
		},
		auto_update = false,
		run_on_start = false,
		start_delay = 3000,
		debounce_hours = 24,
	})
end)
