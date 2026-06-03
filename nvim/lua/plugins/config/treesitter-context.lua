-- lua/plugins/config/treesitter-context.lua
-- Sticky code context at the top of the window.

local ok, context = pcall(require, "treesitter-context")
if not ok then
	return
end

context.setup({
	enable = true,
	multiwindow = false,
	max_lines = 3,
	min_window_height = 20,
	line_numbers = true,
	multiline_threshold = 3,
	trim_scope = "outer",
	mode = "cursor",
	separator = nil,
	zindex = 20,
})

vim.api.nvim_create_user_command("ContextToggle", function()
	context.toggle()
end, { desc = "Toggle Tree-sitter context" })
