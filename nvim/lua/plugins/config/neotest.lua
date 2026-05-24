-- ~/.config/nvim/lua/plugins/config/neotest.lua
-- Test runner integration via neotest.

local neotest = require("neotest")

neotest.setup({
	adapters = {
		require("neotest-python")({
			runner = "pytest",

			-- Use the configured Neovim Python host when available.
			python = function()
				return vim.g.python3_host_prog or "python3"
			end,

			-- Identify common test file layouts and naming conventions.
			is_test_file = function(file_path)
				if file_path:match("/tests?/") then
					return true
				end
				local name = vim.fn.fnamemodify(file_path, ":t")
				return name:match("^test_.*%.py$") or name:match(".*_test%.py$")
			end,

			pytest_discover_instances = true,
		}),
	},
})
