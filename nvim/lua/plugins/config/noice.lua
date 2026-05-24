-- lua/plugins/config/noice.lua
-- UI enhancements for messages, cmdline, and LSP markdown rendering via noice.nvim.

local ok, noice = pcall(require, "noice")
if not ok then
	return
end

noice.setup({
	lsp = {
		override = {
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
			["cmp.entry.get_documentation"] = true,
		},
	},
	presets = {
		bottom_search = true,
		command_palette = true,
		long_message_to_split = true,
	},
})
