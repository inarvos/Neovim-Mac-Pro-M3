-- lua/settings/gitsigns.lua

-- This file configures the gitsigns plugin to display Git changes (additions, deletions, modifications) in the sign column, with options for blame, highlighting, and more.

-- Load and configure gitsigns plugin
require('gitsigns').setup {
  signs = {
    add          = { text = '┃' }, -- Sign for added lines
    change       = { text = '┃' }, -- Sign for changed lines
    delete       = { text = '_' }, -- Sign for deleted lines
    topdelete    = { text = '‾' }, -- Sign for top-deleted lines
    changedelete = { text = '~' }, -- Sign for changed and deleted lines
    untracked    = { text = '┆' }, -- Sign for untracked lines
  },
  signcolumn = true,  -- Show signs in the sign column
  numhl      = false, -- Disable line number highlighting
  linehl     = false, -- Disable line highlighting
  word_diff  = false, -- Disable word diff highlighting
  watch_gitdir = {
    follow_files = true -- Follow files in the git directory
  },
  auto_attach = true, -- Automatically attach to buffers
  attach_to_untracked = false, -- Do not attach to untracked files
  current_line_blame = false, -- Disable current line blame
  current_line_blame_opts = {
    virt_text = true, -- Show blame text virtually
    virt_text_pos = 'eol', -- Position blame text at end of line ('eol')
    delay = 1000, -- Delay before showing blame text (in milliseconds)
    ignore_whitespace = false, -- Do not ignore whitespace changes
    virt_text_priority = 100, -- Priority of virtual text
  },
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>', -- Format for blame text
  current_line_blame_formatter_opts = {
    relative_time = false, -- Do not use relative time for blame
  },
  sign_priority = 6, -- Priority of signs
  update_debounce = 100, -- Debounce time for updates (in milliseconds)
  status_formatter = nil, -- Use default status formatter
  max_file_length = 40000, -- Disable gitsigns for files longer than this (in lines)
  preview_config = {
    -- Options for preview window
    border = 'single', -- Border style for preview window
    style = 'minimal', -- Minimal style for preview window
    relative = 'cursor', -- Position preview window relative to cursor
    row = 0, -- Row offset for preview window
    col = 1  -- Column offset for preview window
  },
}
