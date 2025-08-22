return {
  'benjasper/nightfall.nvim',
  priority = 1000, -- Make sure to load this before all the other start plugins.
  config = function()
    require('nightfall').setup()

    vim.cmd 'colorscheme nightfall'
  end,
}
