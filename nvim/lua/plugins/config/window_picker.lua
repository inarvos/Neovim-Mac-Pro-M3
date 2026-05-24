-- lua/plugins/config/window_picker.lua
-- Window selection UI configuration via nvim-window-picker.

local ok, picker = pcall(require, "window-picker")
if not ok then
	return
end

picker.setup({
	hint = "statusline-winbar",
	selection_chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ",

	picker_config = {
		statusline_winbar_picker = {
			use_winbar = "always",
			selection_display = function(char, windowid)
				local buf = vim.api.nvim_win_get_buf(windowid)
				local name = vim.api.nvim_buf_get_name(buf)
				local tail = (name ~= "" and vim.fn.fnamemodify(name, ":t")) or "[No Name]"
				return "%= " .. char .. "  " .. tail .. " %="
			end,
		},
	},

	filter_rules = {
		include_current_win = false,
		autoselect_one = true,

		bo = {
			filetype = {
				"neo-tree",
				"neo-tree-popup",
				"oil",
				"lazy",
				"mason",
				"TelescopePrompt",
				"TelescopeResults",
				"notify",
			},
			buftype = { "terminal", "nofile", "quickfix", "prompt" },
		},
	},
})
