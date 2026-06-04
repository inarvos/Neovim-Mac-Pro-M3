-- lua/plugins/config/render-markdown.lua
-- Better Markdown reading/writing experience inside Neovim.

local ok, render_markdown = pcall(require, "render-markdown")
if not ok then
	return
end

render_markdown.setup({
	enabled = true,

	-- Render Markdown in normal/command/terminal modes.
	-- Insert mode stays closer to raw Markdown, which is better while editing.
	render_modes = { "n", "c", "t" },

	file_types = { "markdown" },

	-- Avoid heavy rendering on very large README/docs files.
	max_file_size = 5.0,

	-- Enables completions for checkboxes/callouts through the normal LSP completion flow.
	completions = {
		lsp = {
			enabled = true,
		},
	},
})
