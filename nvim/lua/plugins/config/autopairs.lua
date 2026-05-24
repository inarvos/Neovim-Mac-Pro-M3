-- lua/plugins/config/autopairs.lua
-- nvim-autopairs configuration.

local ok, npairs = pcall(require, "nvim-autopairs")
if not ok then
	return
end

npairs.setup({
	check_ts = true, -- Use Treesitter when available to improve pairing behavior.
	disable_filetype = { "TelescopePrompt", "vim" },
	fast_wrap = {
		map = "<M-e>",
		chars = { "{", "[", "(", '"', "'" },
		-- Use a long-bracket string here because the pattern contains ']]'.
		pattern = [=[[%'%"%>%]%)%}%,]]=],
		end_key = "$",
		keys = "qwertyuiopzxcvbnmasdfghjkl",
		check_comma = true,
		highlight = "Search",
		highlight_grey = "Comment",
	},
})
