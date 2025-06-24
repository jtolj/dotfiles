return {
  'nvim-neotest/neotest',
  lazy = true,
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    -- "antoinemadec/FixCursorHold.nvim",
    'nvim-treesitter/nvim-treesitter',
    'olimorris/neotest-phpunit',
    'V13Axel/neotest-pest',
  },
  config = function()
    require('neotest').setup {
      adapters = {
        require 'neotest-phpunit' {
          root_ignore_files = { 'tests/Pest.php' },
        },
        require 'neotest-pest' {
          root_ignore_files = { 'tailwind.config-poa.js' }, -- Temporary and ugly for Castos
        },
      },
    }
  end,
  keys = {
    {
      '<leader>tt',
      function()
        require('neotest').run.run()
      end,
      desc = 'Run nearest test',
    },
    {
      '<leader>tT',
      function()
        require('neotest').run.run(vim.fn.expand '%')
      end,
      desc = 'Run all tests',
    },
  },
}
