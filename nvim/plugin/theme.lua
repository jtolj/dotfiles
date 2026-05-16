vim.pack.add {
  'https://github.com/benjasper/nightfall.nvim',
}

require('nightfall').setup()
vim.cmd 'colorscheme nightfall'
