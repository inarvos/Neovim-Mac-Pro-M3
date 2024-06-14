-- lua/settings/nvim-cmp.lua

-- This file configures the nvim-cmp plugin for autocompletion in Neovim, including key mappings, completion sources, sorting, and specific settings for different file types and command line modes.

-- Load the nvim-cmp plugin
local cmp = require 'cmp'

-- Main setup configuration for nvim-cmp
cmp.setup({
    -- Configure snippet expansion (commented out here)
    -- snippet = {
    --     expand = function(args)
    --         require('luasnip').lsp_expand(args.body)
    --     end,
    -- },

    -- Configure window appearance for completion and documentation
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },

    -- Key mappings for nvim-cmp
    mapping = {
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),  -- Scroll documentation up
        ['<C-f>'] = cmp.mapping.scroll_docs(4),   -- Scroll documentation down
        ['<C-Space>'] = cmp.mapping.complete(),   -- Trigger completion
        ['<C-e>'] = cmp.mapping.abort(),          -- Abort completion
        ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Confirm selection

        -- Navigate through completion items
        ['<Down>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
        ['<Up>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),

        -- Custom mapping for space key to confirm and complete
        ['<Space>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.confirm({ select = false })
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(" ", true, true, true), "n", true)
                vim.defer_fn(function() cmp.complete() end, 10)
            else
                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(" ", true, true, true), "n", true)
                vim.defer_fn(function() cmp.complete() end, 10)
            end
        end, { 'i', 's' }),
    },

    -- Configure completion sources with priority
    sources = cmp.config.sources({
        { name = 'nvim_lsp', priority = 1000 },  -- LSP source
        --{ name = 'luasnip', priority = 750 },  -- Snippet source (commented out)
    }, {
        { name = 'buffer', priority = 500 },    -- Buffer source
        { name = 'path', priority = 250 },      -- Path source
    }),

    -- Sorting configuration for completion items
    sorting = {
        priority_weight = 2,
        comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            function(entry1, entry2)
                local priority1 = entry1.source.priority or 0
                local priority2 = entry2.source.priority or 0
                if priority1 > priority2 then
                    return true
                elseif priority1 < priority2 then
                    return false
                end
            end,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },
})

-- Specific configuration for gitcommit file type
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'cmp_git' },  -- Git source
    }, {
        { name = 'buffer' },   -- Buffer source
    })
})

-- Configuration for '/' command line completion
cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }  -- Buffer source
    }
})

-- Configuration for '?' command line completion
cmp.setup.cmdline('?', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }  -- Buffer source
    }
})

-- Configuration for ':' command line completion
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' },   -- Path source
    }, {
        { name = 'cmdline' } -- Command-line source
    })
})
