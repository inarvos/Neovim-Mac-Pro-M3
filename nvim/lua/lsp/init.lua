-- lua/lsp/init.lua

-- This init.lua file initializes the language server configurations for Neovim by requiring the specific configurations for each language server.

-- Require the Lua language server configuration
require('lsp.servers.lua_ls')

-- Require the Python language server configuration
require('lsp.servers.python_ls')

-- Require other language servers here
require('lsp.servers.c_ls')
-- Example:
-- require('lsp.servers.rust_ls')
-- require('lsp.servers.go_ls')
-- Add additional language server configurations as needed
