-- lua/settings/lsp.lua

-- This file configures the Language Server Protocol (LSP) settings for Neovim, including key mappings, autocommands for diagnostics and hover, and general LSP setup.

local M = {}

-- Function to set up LSP-related key mappings and autocommands
M.on_attach = function(_, bufnr)
local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

-- Options for key mappings
local opts = { noremap=true, silent=true }

    -- Key mappings for LSP functions
    buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts) -- Go to declaration
    buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts) -- Go to definition
    buf_set_keymap('n', 'K', '<Cmd>lua vim.b.lsp_hover = true; vim.lsp.buf.hover()<CR>', opts) -- Hover documentation
    buf_set_keymap('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts) -- Go to implementation
    buf_set_keymap('n', '<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts) -- Signature help
    buf_set_keymap('n', '<space>wa', '<Cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts) -- Add workspace folder
    buf_set_keymap('n', '<space>wr', '<Cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts) -- Remove workspace folder
    buf_set_keymap('n', '<space>wl', '<Cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts) -- List workspace folders
    buf_set_keymap('n', '<space>D', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', opts) -- Go to type definition
    buf_set_keymap('n', '<space>rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', opts) -- Rename symbol
    buf_set_keymap('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', opts) -- Find references
    buf_set_keymap('n', '<space>e', '<Cmd>lua vim.diagnostic.open_float()<CR>', opts) -- Open diagnostic float
    buf_set_keymap('n', '[d', '<Cmd>lua vim.diagnostic.goto_prev()<CR>', opts) -- Go to previous diagnostic
    buf_set_keymap('n', ']d', '<Cmd>lua vim.diagnostic.goto_next()<CR>', opts) -- Go to next diagnostic
    buf_set_keymap('n', '<space>q', '<Cmd>lua vim.diagnostic.setloclist()<CR>', opts) -- Set location list
    buf_set_keymap('n', '<space>f', '<Cmd>lua vim.lsp.buf.formatting()<CR>', opts) -- Format code

    -- Autocommand to reset the hover flag when leaving insert mode
    vim.api.nvim_create_autocmd("InsertLeave", {
        buffer = bufnr,
        callback = function()
            vim.b.lsp_hover = false
        end,
})

    -- Autocommand to reset the hover flag after hover
    vim.api.nvim_create_autocmd("CursorMoved", {
        buffer = bufnr,
        callback = function()
            vim.defer_fn(function()
                vim.b.lsp_hover = false
            end, 500) -- Adjust the delay as needed
        end,
    })
end

-- Autocommand to show diagnostics in a floating window on hover
vim.api.nvim_create_autocmd("CursorHold", {
    pattern = "*",
    callback = function()
        if not vim.b.lsp_hover then
            vim.diagnostic.open_float(nil, { focusable = false })
        end
    end,
})

-- Set the updatetime to 300 milliseconds for faster diagnostics
vim.opt.updatetime = 300

-- Keybindings for diagnostics
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float) -- Open diagnostic float
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist) -- Set location list

return M
