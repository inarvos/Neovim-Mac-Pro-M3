-- ~/.config/nvim/lua/plugins/config/cmp.lua
-- Completion configuration (nvim-cmp + LuaSnip).

local cmp_ok, cmp = pcall(require, "cmp")
if not cmp_ok then
	return
end

local luasnip_ok, luasnip = pcall(require, "luasnip")
if luasnip_ok then
	pcall(function()
		require("luasnip.loaders.from_vscode").lazy_load()
	end)
end

vim.opt.completeopt = { "menu", "menuone", "noselect" }

local function has_words_before()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	if col == 0 then
		return false
	end
	local text = vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
	return text:sub(col, col):match("%s") == nil
end

cmp.setup({
	snippet = {
		expand = function(args)
			if luasnip_ok then
				luasnip.lsp_expand(args.body)
			end
		end,
	},

	mapping = cmp.mapping.preset.insert({
		["<C-b>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),

		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip_ok and luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip_ok and luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),

	sources = cmp.config.sources({
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "path" },
	}, {
		{ name = "buffer" },
	}),

	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},

	experimental = {
		ghost_text = true,
	},
})

-- Cmdline completion (requires the relevant source plugins).
if pcall(require, "cmp_cmdline") then
	cmp.setup.cmdline({ "/", "?" }, {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = "buffer" },
		},
	})

	cmp.setup.cmdline(":", {
		completion = { autocomplete = false },
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = "path" },
		}, {
			{ name = "cmdline" },
		}),
	})
end

-- Integrate nvim-cmp confirmation with nvim-autopairs when available.
pcall(function()
	local cmp_autopairs = require("nvim-autopairs.completion.cmp")
	cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
end)
