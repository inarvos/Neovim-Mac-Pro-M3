-- lua/snippets/luasnip.lua

-- This file configures the LuaSnip plugin to lazily load snippets from VSCode-style snippet files.

-- Load LuaSnip plugin
require("luasnip.loaders.from_vscode").lazy_load()
