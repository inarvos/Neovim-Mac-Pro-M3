-- lua/plugins/config/notify.lua
-- Notification backend configuration via nvim-notify.

local ok, notify = pcall(require, "notify")
if not ok then
	return
end

notify.setup({
	stages = "fade_in_slide_out",
	timeout = 2000,
	max_height = function()
		return math.floor(vim.o.lines * 0.75)
	end,
	max_width = function()
		return math.floor(vim.o.columns * 0.5)
	end,
})

vim.notify = notify
