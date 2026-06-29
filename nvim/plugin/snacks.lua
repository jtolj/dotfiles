vim.pack.add { 'https://github.com/folke/snacks.nvim' }

local snacks = require 'snacks'

snacks.setup {
  bigfile = { enabled = true },
  dashboard = { enabled = false },
  explorer = { enabled = false },
  indent = { enabled = false },
  input = { enabled = true },
  picker = { enabled = false },
  notifier = { enabled = false },
  quickfile = { enabled = false },
  scope = { enabled = false },
  scroll = { enabled = false },
  statuscolumn = { enabled = true },
  words = { enabled = false },
  scratch = { enable = true },
}

vim.keymap.set('n', '<leader>.', function()
  snacks.scratch()
end, { desc = 'Toggle scratch buffer.' })
