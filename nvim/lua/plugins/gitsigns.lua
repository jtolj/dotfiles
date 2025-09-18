return
-- See `:help gitsigns` to understand what the configuration keys do
{ -- Adds git related signs to the gutter, as well as utilities for managing changes
  'lewis6991/gitsigns.nvim',
  keys = {
    { '<leader>ghb', '<cmd>Gitsigns toggle_current_line_blame<cr>', desc = 'Git toggle current line blame' },
    { '<leader>ghB', '<cmd>Gitsigns blame<cr>', desc = 'Git blame' },
  },
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
  },
}
