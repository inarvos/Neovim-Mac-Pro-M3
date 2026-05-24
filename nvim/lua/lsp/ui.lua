-- ~/.config/nvim/lua/lsp/ui.lua
-- Buffer-local LSP UX: keymaps, hover/diagnostic behavior, and formatting helpers.

local M = {}

local augroup = vim.api.nvim_create_augroup("UserLspUi", { clear = true })

local function buf_map(bufnr, mode, lhs, rhs, desc)
	vim.keymap.set(mode, lhs, rhs, {
		noremap = true,
		silent = true,
		buffer = bufnr,
		desc = desc,
	})
end

local function setup_buffer_keymaps(bufnr)
	-- Apply once per buffer.
	if vim.b[bufnr].user_lsp_ui_attached then
		return
	end
	vim.b[bufnr].user_lsp_ui_attached = true

	-- Enable omni completion via LSP.
	vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

	-- Navigation
	buf_map(bufnr, "n", "<leader>gD", vim.lsp.buf.declaration, "lsp: declaration")
	buf_map(bufnr, "n", "<leader>gd", vim.lsp.buf.definition, "lsp: definition")
	buf_map(bufnr, "n", "<leader>gi", vim.lsp.buf.implementation, "lsp: implementation")
	buf_map(bufnr, "n", "<C-k>", vim.lsp.buf.signature_help, "lsp: signature help")

	-- Hover
	buf_map(bufnr, "n", "K", function()
		vim.b[bufnr].lsp_hover = true
		vim.lsp.buf.hover()
	end, "lsp: hover")

	-- Workspace folders
	buf_map(bufnr, "n", "<leader>wa", vim.lsp.buf.add_workspace_folder, "lsp: add workspace")
	buf_map(bufnr, "n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, "lsp: remove workspace")
	buf_map(bufnr, "n", "<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "lsp: list workspaces")

	-- Refactoring and references
	buf_map(bufnr, "n", "<leader>D", vim.lsp.buf.type_definition, "lsp: type definition")
	buf_map(bufnr, "n", "<leader>rn", vim.lsp.buf.rename, "lsp: rename")
	buf_map(bufnr, "n", "<leader>gr", vim.lsp.buf.references, "lsp: references")

	-- Diagnostics
	buf_map(bufnr, "n", "<leader>e", function()
		vim.diagnostic.open_float(nil, { focusable = false })
	end, "diag: float")

	buf_map(bufnr, "n", "<leader>qd", vim.diagnostic.setloclist, "diag: loclist")

	-- Manual formatting. Format-on-save is handled by conform.lua.
	buf_map(bufnr, "n", "<leader>fr", function()
		local ok_conform, conform = pcall(require, "conform")
		if ok_conform then
			conform.format({
				bufnr = bufnr,
				async = true,
				timeout_ms = 3000,
				lsp_format = "fallback",
			})
		else
			vim.lsp.buf.format({ async = true })
		end
	end, "format")

	-- Clear hover state on movement or after leaving Insert mode.
	vim.api.nvim_create_autocmd({ "CursorMoved", "InsertLeave" }, {
		group = augroup,
		buffer = bufnr,
		callback = function()
			vim.b[bufnr].lsp_hover = false
		end,
	})

	-- Show diagnostics in a float on CursorHold unless hover is active.
	vim.api.nvim_create_autocmd("CursorHold", {
		group = augroup,
		buffer = bufnr,
		callback = function()
			if not vim.b[bufnr].lsp_hover then
				vim.diagnostic.open_float(nil, { focusable = false })
			end
		end,
	})
end

-- Compatibility hook for configs that still call on_attach explicitly.
M.on_attach = function(_, bufnr)
	setup_buffer_keymaps(bufnr)
end

-- Primary attachment path: apply UX when an LSP client attaches.
vim.api.nvim_create_autocmd("LspAttach", {
	group = augroup,
	callback = function(args)
		setup_buffer_keymaps(args.buf)
	end,
})

vim.opt.updatetime = 300

return M
