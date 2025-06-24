return {
  'mfussenegger/nvim-dap',
  lazy = true,
  dependencies = {
    {
      'igorlfs/nvim-dap-view',
      opts = {
        winbar = {
          show = true,
          -- You can add a "console" section to merge the terminal with the other views
          sections = { 'scopes', 'watches', 'exceptions', 'breakpoints', 'threads', 'repl', 'console' },
          -- Must be one of the sections declared above
          default_section = 'scopes',
          headers = {
            breakpoints = 'Breakpoints [B]',
            scopes = 'Scopes [S]',
            exceptions = 'Exceptions [E]',
            watches = 'Watches [W]',
            threads = 'Threads [T]',
            repl = 'REPL [R]',
            console = 'Console [C]',
          },
          controls = {
            enabled = true,
            position = 'right',
            buttons = {
              'play',
              'step_into',
              'step_over',
              'step_out',
              'step_back',
              'run_last',
              'terminate',
              'disconnect',
            },
            icons = {
              pause = '',
              play = '',
              step_into = '',
              step_over = '',
              step_out = '',
              step_back = '',
              run_last = '',
              terminate = '',
              disconnect = '',
            },
            custom_buttons = {},
          },
        },
        windows = {
          height = 12,
          terminal = {
            -- 'left'|'right'|'above'|'below': Terminal position in layout
            position = 'left',
            -- List of debug adapters for which the terminal should be ALWAYS hidden
            hide = {},
            -- Hide the terminal when starting a new session
            start_hidden = false,
          },
        },
        -- Controls how to jump when selecting a breakpoint or navigating the stack
        switchbuf = 'usetab,newtab',
      },
    },
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
    { '<leader>do', '<cmd>lua require"dap".step_out()<CR>', desc = 'Step Out' },
    { '<leader>dr', '<cmd>lua require"dap".repl.open()<CR>', desc = 'Open REPL' },
    { '<leader>ds', '<cmd>lua require"dap".run_last()<CR>', desc = 'Run Last' },
    { '<leader>dt', '<cmd>lua require"dap".terminate()<CR>', desc = 'Terminate' },
    { '<leader>dp', '<cmd>lua require"dap".pause()<CR>', desc = 'Pause' },
    { '<leader>dl', '<cmd>lua require"dap".run_to_cursor()<CR>', desc = 'Run to Cursor' },
    { '<leader>du', '<cmd>lua require"dap-view".toggle()<CR>', desc = 'Toggle DAP UI' },
  },
  config = function()
    local dap = require 'dap'
    local dap_virt_text = require 'nvim-dap-virtual-text'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_setup = true,

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
