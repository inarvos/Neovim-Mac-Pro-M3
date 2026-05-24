-- ~/.config/nvim/lua/config/neovide.lua
-- Neovide-specific configuration. Safe to load in terminal Neovim.

if not vim.g.neovide then
	return
end

-- Treat Option/Alt as Meta on macOS.
vim.g.neovide_input_macos_option_key_is_meta = true

-- UI padding.
vim.g.neovide_padding_top = 10

-- Transparency and blur.
vim.g.neovide_opacity = 0.6
vim.g.neovide_window_blurred = true
vim.g.neovide_floating_blur_amount_x = 2.0
vim.g.neovide_floating_blur_amount_y = 2.0

-- Cursor and visual effects.
vim.g.neovide_hide_mouse_when_typing = true
vim.g.neovide_cursor_antialiasing = true
vim.g.neovide_cursor_vfx_mode = "railgun"

-- Theme hint for Neovide.
vim.g.neovide_theme = "dark"

-- HiDPI scale factor.
vim.g.neovide_scale_factor = 1.0

-- Open the current file in a new Neovide window.
vim.api.nvim_create_user_command("OpenInNewWindow", function()
	local file_path = vim.fn.expand("%:p")
	vim.fn.system({ "neovide", file_path })
end, {})

-- Font (set only if not configured elsewhere).
-- if vim.opt.guifont:get() == "" then
-- 	vim.opt.guifont = "JetBrainsMono Nerd Font:h14"
-- end

local function set_font_size(size)
	-- guifont may be a string or a list depending on state/version.
	local font = vim.opt.guifont:get()

	if type(font) == "table" then
		font = font[1]
	end

	if type(font) ~= "string" or font == "" then
		font = "JetBrainsMono Nerd Font"
	end

	-- Remove any existing :hNN size suffix.
	font = font:gsub(":h%d+", "")

	vim.opt.guifont = font .. ":h" .. tostring(size)
end

set_font_size(20)

-- Cmd + / - / 0 zoom controls.
local function set_scale(delta)
	vim.g.neovide_scale_factor = math.max(0.5, (vim.g.neovide_scale_factor or 1.0) + delta)
end

vim.keymap.set("n", "<D-=>", function()
	set_scale(0.1)
end, { desc = "Neovide: zoom in" })

vim.keymap.set("n", "<D-->", function()
	set_scale(-0.1)
end, { desc = "Neovide: zoom out" })

vim.keymap.set("n", "<D-0>", function()
	vim.g.neovide_scale_factor = 1.0
end, { desc = "Neovide: reset zoom" })
