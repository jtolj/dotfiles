---@module "lazy"
---@type LazySpec
return {
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
