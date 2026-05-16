vim.pack.add { 'https://github.com/nvim-neotest/neotest' }
vim.pack.add { 'https://github.com/nvim-neotest/nvim-nio' }
vim.pack.add { 'https://github.com/nvim-lua/plenary.nvim' }
vim.pack.add { 'https://github.com/olimorris/neotest-phpunit' }
vim.pack.add { 'https://github.com/V13Axel/neotest-pest' }
require('neotest').setup {
  adapters = {
    require 'neotest-phpunit' {
      root_ignore_files = { 'tests/Pest.php' },
    },
    require 'neotest-pest' {},
  },
}

vim.keymap.set('n', '<leader>tt', function()
  require('neotest').run.run()
end, { desc = 'Run nearest test' })
vim.keymap.set('n', '<leader>tT', function()
  require('neotest').run.run(vim.fn.expand '%')
end, { desc = 'Run all tests' })
