-- ~/.config/nvim/init.lua

-- Enable Neovim's Lua module loader cache (when available) to improve startup time.
pcall(vim.loader.enable)

-- Global leader keys. Set early so all mappings and plugins pick them up consistently.
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- normal terminal Neovim config continues below

-- Disable unused language providers to reduce startup checks.
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

-- Python provider.
-- Prefer a dedicated Neovim Python venv.
-- Fall back to your old pyenv nvim-env only if it exists.
-- If neither exists, disable the Python provider to stop broken pyenv healthcheck errors.
do
	local python_hosts = {
		vim.fn.stdpath("data") .. "/venv/bin/python",
		"/Users/inarvos/.pyenv/versions/nvim-env/bin/python",
	}

	local found_python_host = false

	for _, py in ipairs(python_hosts) do
		if vim.fn.executable(py) == 1 then
			vim.g.python3_host_prog = py
			found_python_host = true
			break
		end
	end

	if not found_python_host then
		vim.g.loaded_python3_provider = 0
	end
end

-- Core configuration (loaded before plugins).
require("config.options")
require("config.general")
require("config.keymaps")
require("config.autocmds")
require("config.commands")
require("config.neovide")

-- LSP user experience settings (keymaps, UI behavior, etc.).
require("lsp.ui")

-- Plugin manager and plugin configurations.
require("plugins")
