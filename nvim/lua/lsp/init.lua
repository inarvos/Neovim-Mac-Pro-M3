-- ~/.config/nvim/lua/lsp/init.lua
-- LSP configuration using Neovim 0.11+ APIs:
--   vim.lsp.config()
--   vim.lsp.enable()
--
-- Mason installs tools, but this file decides exactly which LSP servers run.

-- Add Mason's bin directory to PATH so servers installed by Mason are discoverable.
do
	local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"

	if vim.fn.isdirectory(mason_bin) == 1 and not vim.env.PATH:find(mason_bin, 1, true) then
		vim.env.PATH = mason_bin .. ":" .. vim.env.PATH
	end
end

local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

local capabilities = vim.lsp.protocol.make_client_capabilities()
if ok_cmp then
	capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

-- Prefer one position encoding across clients.
capabilities.general = capabilities.general or {}
capabilities.general.positionEncodings = { "utf-16" }

vim.lsp.config("*", {
	capabilities = capabilities,
})

----------------------------------------------------------------------
-- Server-specific configuration
----------------------------------------------------------------------

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				checkThirdParty = false,
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
			telemetry = {
				enable = false,
			},
			hint = {
				enable = true,
				semicolon = "Disable",
			},
			codeLens = {
				enable = true,
			},
		},
	},
})

vim.lsp.config("pyright", {
	settings = {
		python = {
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = "workspace",
			},
		},
	},
})

vim.lsp.config("ruff", {
	init_options = {
		settings = vim.empty_dict(),
	},
})

vim.lsp.config("ts_ls", {
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},
})

vim.lsp.config("eslint", {
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
		"svelte",
		"astro",
	},
})

local omnisharp = "/opt/homebrew/opt/omnisharp-mono/bin/omnisharp"

vim.lsp.config("omnisharp", {
	cmd = {
		omnisharp,
		"--languageserver",
		"--hostPID",
		tostring(vim.fn.getpid()),
	},
})

----------------------------------------------------------------------
-- Enable only selected servers
----------------------------------------------------------------------

local function have_exe(exe)
	if not exe or exe == "" then
		return false
	end

	if exe:find("/", 1, true) then
		return vim.fn.filereadable(exe) == 1
	end

	return vim.fn.executable(exe) == 1
end

local servers = {
	lua_ls = "lua-language-server",

	pyright = "pyright-langserver",
	ruff = "ruff",

	ts_ls = "typescript-language-server",
	eslint = "vscode-eslint-language-server",

	html = "vscode-html-language-server",
	cssls = "vscode-css-language-server",
	jsonls = "vscode-json-language-server",

	clangd = "clangd",
	jdtls = "jdtls",
	omnisharp = omnisharp,
}

local to_enable = {}

for server, exe in pairs(servers) do
	if have_exe(exe) then
		table.insert(to_enable, server)
	end
end

table.sort(to_enable)

vim.lsp.enable(to_enable)
