---@module "lazy"
---@type LazySpec
return {
  { 'mfussenegger/nvim-dap', lazy = true },
  { 'theHamsta/nvim-dap-virtual-text' },
  { 'jay-babu/mason-nvim-dap.nvim' },
  {
    'miroshQa/debugmaster.nvim',
    -- osv is needed if you want to debug neovim lua code. Also can be used
    -- as a way to quickly test-drive the plugin without configuring debug adapters
    dependencies = { 'mfussenegger/nvim-dap', 'jbyuki/one-small-step-for-vimkind' },
    config = function()
      local dm = require 'debugmaster'
      -- make sure you don't have any other keymaps that starts with "<leader>d" to avoid delay
      -- Alternative keybindings to "<leader>d" could be: "<leader>m", "<leader>;"
      vim.keymap.set({ 'n', 'v' }, '<leader>d', dm.mode.toggle, { nowait = true, desc = '[D]ebug Mode' })
      -- If you want to disable debug mode in addition to leader+d using the Escape key:
      -- vim.keymap.set("n", "<Esc>", dm.mode.disable)
      -- This might be unwanted if you already use Esc for ":noh"
      -- vim.keymap.set('t', '<C-\\>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

      dm.plugins.osv_integration.enabled = true -- needed if you want to debug neovim lua code
      local dap = require 'dap'

      local dap_virt_text = require 'nvim-dap-virtual-text'

      require('mason-nvim-dap').setup {
        automatic_installation = false,

        handlers = {
          function(config)
            require('mason-nvim-dap').default_setup(config)
          end,
        },

        ensure_installed = {},
      }

      dap_virt_text.setup {
        enabled = true,
        enable_autocmd = false,
      }

      vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })
      vim.fn.sign_define('DapStopped', { text = '⏸', texthl = '', linehl = '', numhl = '' })
      vim.fn.sign_define('DapBreakpointCondition', { text = '🔴', texthl = '', linehl = '', numhl = '' })
      vim.fn.sign_define('DapBreakpointRejected', { text = '❌', texthl = '', linehl = '', numhl = '' })
      vim.fn.sign_define('DapLogPoint', { text = '📝', texthl = '', linehl = '', numhl = '' })
    end,
  },
}
