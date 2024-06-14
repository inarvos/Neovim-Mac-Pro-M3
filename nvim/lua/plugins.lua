-- lua/plugins.lua

-- This file configures Neovim plugins using the packer.nvim plugin manager, including plugins for LSP, autocompletion, Git integration, file exploration, colorschemes, and various other enhancements.

-- Ensure packer is installed
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd('packadd packer.nvim')
end

-- Initialize packer
require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Coding plugins:
    -- LSP configurations for Neovim
    use 'neovim/nvim-lspconfig'
    -- Autocompletion plugin
    use 'hrsh7th/nvim-cmp'
    -- LSP source for nvim-cmp
    use 'hrsh7th/cmp-nvim-lsp'
    -- Buffer completions
    use 'hrsh7th/cmp-buffer'
    -- Path completions
    use 'hrsh7th/cmp-path'
    -- Command-line completions
    use 'hrsh7th/cmp-cmdline'

    -- Uncomment these lines if you want snippet completions and support
    -- use 'saadparwaiz1/cmp_luasnip'
    -- use {
    --     'L3MON4D3/LuaSnip',
    --     run = "make install_jsregexp",
    --     requires = {
    --         'rafamadriz/friendly-snippets', -- Preconfigured snippets
    --     }
    -- }

    -- Git integration:
    -- Git commands in nvim
    use 'tpope/vim-fugitive'
    -- Git signs in the gutter
    use {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup {}
        end
    }

    -- C# support:
    use 'OmniSharp/omnisharp-vim'

    -- Code design:
    -- Treesitter configurations and abstraction layer for Neovim
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
    }
    -- Code linting and formatting
    use {
        'jose-elias-alvarez/null-ls.nvim',
        requires = { 'nvim-lua/plenary.nvim' }
    }
    -- Prettier integration for code formatting
    use('MunifTanjim/prettier.nvim')

    -- Treesitter-based folding workaround
    vim.api.nvim_create_autocmd({'BufEnter','BufAdd','BufNew','BufNewFile','BufWinEnter'}, {
        group = vim.api.nvim_create_augroup('TS_FOLD_WORKAROUND', {}),
        callback = function()
            vim.opt.foldmethod = 'expr'
            vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
        end
    })
    -- Treesitter playground for better understanding of treesitter
    use 'nvim-treesitter/playground'

    -- File explorer tree
    use {
        'kyazdani42/nvim-tree.lua',
        requires = {
            'kyazdani42/nvim-web-devicons', -- File icons
        },
        config = function()
            require('nvim-tree').setup {
                view = {
                    width = 25, -- Set default width for NvimTree
                },
            }
        end
    }

    -- Neo-tree file explorer
    use {
        'nvim-neo-tree/neo-tree.nvim',
        branch = "v2.x",
        requires = {
            'nvim-lua/plenary.nvim',
            'nvim-tree/nvim-web-devicons', -- File icons
            'MunifTanjim/nui.nvim',
        },
        config = function()
            require('neo-tree').setup {
                window = {
                    width = 25, -- Set default width for NeoTree
                },
            }
        end
    }

    -- Colorschemes:
    -- A Lua plugin to create colorschemes using colorbuddy
    use 'tjdevries/colorbuddy.nvim'
    -- Iceberg colorscheme
    use 'cocopon/iceberg.vim'
    -- Tokyo Night colorscheme
    use 'folke/tokyonight.nvim'
    -- Nightfly colorscheme
    use { "bluz71/vim-nightfly-colors", as = "nightfly" }
    -- Moonfly colorscheme
    use 'bluz71/vim-moonfly-colors'
    -- Gruvbox colorscheme
    use 'morhetz/gruvbox'

    -- Text highlighter -> settings/colorizer.lua:
    use 'norcalli/nvim-colorizer.lua'

    -- Lualine (status line)
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'bluz71/vim-moonfly-colors' },
        config = function()
            require('lualine').setup {
                options = {
                    icons_enabled = true,
                    theme = 'moonfly',
                }
            }
        end
    }

    -- Autopairs: -> settings/autopairs.lua
    use {
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup {}
        end
    }

    -- Indent blankline.nvim: -> settings/indent-blankline.lua
    use {
        'lukas-reineke/indent-blankline.nvim',
        config = function()
            require("ibl").setup()
        end
    }

    -- Other useful plugins:
    -- Fuzzy finder and more
    use 'nvim-telescope/telescope.nvim'
    -- File browser extension for Telescope
    use 'nvim-telescope/telescope-file-browser.nvim'

    -- Commenting plugin
    use 'numToStr/Comment.nvim'
    -- Highlight yanked text
    use 'machakann/vim-highlightedyank'

end)
