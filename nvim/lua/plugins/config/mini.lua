-- ~/.config/nvim/lua/plugins/config/mini.lua
-- mini.nvim modules configuration.

local MiniFiles = require("mini.files")

MiniFiles.setup({
	windows = {
		preview = true,
		width_focus = 30,
		width_preview = 40,
	},
	options = {
		permanent_delete = false,
		use_as_default_explorer = false,
	},
	mappings = {
		go_in = "<cr>",
		go_in_plus = "l",
		go_out = "-",
		go_out_plus = "h",
		reset = "<bs>",
		reveal_cwd = "@",
		show_help = "g?",
		synchronize = "=",
		trim_left = "<",
		trim_right = ">",
	},
})

-- mini.surround mappings are namespaced to avoid conflicts with core mappings.
local ok, surround = pcall(require, "mini.surround")
if ok then
	surround.setup({
		mappings = {
			add = "gsa",
			delete = "gsd",
			find = "gsf",
			find_left = "gsF",
			highlight = "gsh",
			replace = "gsr",
			update_n_lines = "gsn",

			suffix_last = "",
			suffix_next = "",
		},
	})
end

vim.keymap.set("n", "<leader>m", function()
	MiniFiles.open()
end, { desc = "mini.files" })

vim.api.nvim_create_autocmd("User", {
	pattern = "MiniFilesBufferCreate",
	callback = function(args)
		local buf_id = args.data.buf_id

		-- Default to hiding dotfiles when opening mini.files.
		vim.b[buf_id].minifiles_show_dotfiles = false

		-- Toggle dotfiles visibility.
		vim.keymap.set("n", "H", function()
			local show = vim.b[buf_id].minifiles_show_dotfiles
			vim.b[buf_id].minifiles_show_dotfiles = not show

			require("mini.files").refresh({
				content = {
					filter = function(entry)
						if vim.b[buf_id].minifiles_show_dotfiles then
							return true
						end
						return entry.name:sub(1, 1) ~= "."
					end,
				},
			})
		end, { buffer = buf_id, desc = "mini.files: toggle dotfiles" })
	end,
})
