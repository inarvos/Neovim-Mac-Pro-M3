-- ~/.config/nvim/lua/config/commands.lua

-- Open Neovide as a separate application instance (macOS).
vim.api.nvim_create_user_command("NewWindow", function()
	vim.fn.system({ "open", "-na", "Neovide" })
end, { desc = "Open Neovide as a new app instance (macOS)" })

-- Compatibility command.
-- In your current setup, :LspInfo is not available, so make it point to the
-- modern built-in LSP health view.
vim.api.nvim_create_user_command("LspInfo", function()
	vim.cmd("checkhealth vim.lsp")
end, { desc = "Show LSP status using :checkhealth vim.lsp" })

vim.api.nvim_create_user_command("LspHealth", function()
	vim.cmd("checkhealth vim.lsp")
end, { desc = "Show LSP health" })

vim.api.nvim_create_user_command("LspLog", function()
	vim.cmd.edit(vim.lsp.get_log_path())
end, { desc = "Open LSP log file" })
