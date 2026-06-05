-- lua/plugins/config/overseer.lua
-- Project task runner and job manager.
--
-- Comfortable behaviour:
--   - running a file does NOT replace the code buffer
--   - running a file opens only the Overseer task list at the bottom
--   - task output is visible through the task list preview
--   - <leader>ot toggles the task list
--   - <leader>oc closes the task list

local ok, overseer = pcall(require, "overseer")
if not ok then
	return
end

overseer.setup({
	templates = {
		"builtin",
	},

	task_list = {
		direction = "bottom",
		min_height = 10,
		max_height = { 18, 0.35 },
		default_detail = 1,

		keymaps = {
			["?"] = "ShowHelp",
			["g?"] = "ShowHelp",
			["<CR>"] = "RunAction",
			["o"] = "Open",
			["p"] = "TogglePreview",
			["{"] = "PrevTask",
			["}"] = "NextTask",
			["<C-k>"] = "ScrollOutputUp",
			["<C-j>"] = "ScrollOutputDown",
			["dd"] = "Dispose",
			["q"] = "Close",
		},
	},

	form = {
		border = "rounded",
		win_opts = {
			winblend = 0,
		},
	},

	confirm = {
		border = "rounded",
		win_opts = {
			winblend = 0,
		},
	},

	task_win = {
		border = "rounded",
		win_opts = {
			winblend = 0,
		},
	},
})

local function show_task_list()
	vim.defer_fn(function()
		pcall(function()
			overseer.open({
				direction = "bottom",
				enter = false,
			})
		end)
	end, 100)
end

local function start_task(opts)
	local task = overseer.new_task({
		name = opts.name,
		cmd = opts.cmd,
		args = opts.args,
		cwd = opts.cwd or vim.fn.getcwd(),
		components = {
			"default",
		},
	})

	task:start()
	show_task_list()
end

vim.api.nvim_create_user_command("TaskRunPython", function()
	local file = vim.fn.expand("%:p")

	if file == "" or vim.bo.filetype ~= "python" then
		vim.notify("Current buffer is not a Python file", vim.log.levels.WARN)
		return
	end

	if vim.fn.executable("python3") == 0 then
		vim.notify("python3 executable was not found", vim.log.levels.ERROR)
		return
	end

	start_task({
		name = "python: " .. vim.fn.expand("%:t"),
		cmd = "python3",
		args = { file },
		cwd = vim.fn.expand("%:p:h"),
	})
end, { desc = "Run current Python file with Overseer" })

vim.api.nvim_create_user_command("TaskRunNode", function()
	local file = vim.fn.expand("%:p")
	local ft = vim.bo.filetype

	if file == "" or not vim.tbl_contains({ "javascript", "typescript" }, ft) then
		vim.notify("Current buffer is not a JavaScript/TypeScript file", vim.log.levels.WARN)
		return
	end

	if ft == "javascript" then
		if vim.fn.executable("node") == 0 then
			vim.notify("node executable was not found", vim.log.levels.ERROR)
			return
		end

		start_task({
			name = "node: " .. vim.fn.expand("%:t"),
			cmd = "node",
			args = { file },
			cwd = vim.fn.expand("%:p:h"),
		})

		return
	end

	if vim.fn.executable("npx") == 0 then
		vim.notify("TypeScript task needs npx/tsx. Install with: npm install -g tsx", vim.log.levels.WARN)
		return
	end

	start_task({
		name = "tsx: " .. vim.fn.expand("%:t"),
		cmd = "npx",
		args = { "tsx", file },
		cwd = vim.fn.expand("%:p:h"),
	})
end, { desc = "Run current JS/TS file with Overseer" })
