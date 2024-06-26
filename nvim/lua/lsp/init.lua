-- lua/lsp/init.lua

-- This init.lua file initializes the language server configurations for Neovim by requiring the specific configurations for each language server.

-- Require the Lua language server configuration
require('lsp.servers.lua_ls')

-- Require the Python language server configuration
require('lsp.servers.python_ls')

-- Require other language servers here
require('lsp.servers.c_ls')
require('lsp.servers.csharp_ls')
require('lsp.servers.java_ls')
require('lsp.servers.cpp_ls')

-- Add additional language server configurations as needed
