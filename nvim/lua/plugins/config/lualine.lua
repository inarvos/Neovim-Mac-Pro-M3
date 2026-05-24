-- lua/plugins/config/lualine.lua
-- Statusline configuration via lualine.nvim.

local ok, lualine = pcall(require, "lualine")
if not ok then
	return
end

lualine.setup({
	options = {
		icons_enabled = true,
		theme = "auto",
		section_separators = "",
		component_separators = "",
		globalstatus = true,
	},
})
