vim.pack.add { 'https://github.com/lewis6991/gitsigns.nvim' }

local gs = require 'gitsigns'

gs.setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

vim.keymap.set('n', '<leader>ghb', '<cmd>Gitsigns toggle_current_line_blame<cr>', { desc = 'Git toggle current line blame' })
vim.keymap.set('n', '<leader>ghB', '<cmd>Gitsigns blame<cr>', { desc = 'Git blame' })
