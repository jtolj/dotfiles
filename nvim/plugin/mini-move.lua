vim.pack.add { 'https://github.com/nvim-mini/mini.nvim' }

require('mini.move').setup {
  mappings = {
    left = 'H',
    right = 'L',
    down = 'J',
    up = 'K',
  },
}
