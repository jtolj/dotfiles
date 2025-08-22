return {
  'mfussenegger/nvim-dap',
  lazy = true,
  dependencies = {
    { 'rcarriga/nvim-dap-ui', dependencies = { 'mfussenegger/nvim-dap', 'nvim-neotest/nvim-nio' }, opts = {} },
    'theHamsta/nvim-dap-virtual-text',
    'nvim-telescope/telescope-dap.nvim',
    'jbyuki/one-small-step-for-vimkind',
    'jay-babu/mason-nvim-dap.nvim',
  },
  keys = {
    { '<leader>db', '<cmd>lua require"dap".toggle_breakpoint()<CR>', desc = 'Toggle Breakpoint' },
    { '<leader>dc', '<cmd>lua require"dap".continue()<CR>', desc = 'Continue' },
    { '<leader>di', '<cmd>lua require"dap".step_into()<CR>', desc = 'Step Into' },
    { '<leader>do', '<cmd>lua require"dap".step_over()<CR>', desc = 'Step Over' },
    { '<leader>dO', '<cmd>lua require"dap".step_out()<CR>', desc = 'Step Out' },
    { '<leader>dr', '<cmd>lua require"dap".repl.open()<CR>', desc = 'Open REPL' },
    { '<leader>ds', '<cmd>lua require"dap".run_last()<CR>', desc = 'Run Last' },
    { '<leader>dt', '<cmd>lua require"dap".terminate()<CR>', desc = 'Terminate' },
    { '<leader>dp', '<cmd>lua require"dap".pause()<CR>', desc = 'Pause' },
    { '<leader>dl', '<cmd>lua require"dap".run_to_cursor()<CR>', desc = 'Run to Cursor' },
    { '<leader>du', '<cmd>lua require"dapui".toggle()<CR>', desc = 'Toggle DAP UI' },
  },
  config = function()
    local dap = require 'dap'
    local dap_virt_text = require 'nvim-dap-virtual-text'

    require('mason-nvim-dap').setup {
      automatic_installation = false,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {
        function(config)
          require('mason-nvim-dap').default_setup(config)
        end,
      },

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {},
    }

    dap_virt_text.setup {
      enabled = true,
      enable_autocmd = false,
    }
  end,
}
