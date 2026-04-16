---@module "lazy"
---@type LazySpec
return {
  {
    'igorlfs/nvim-dap-view',
    -- let the plugin lazy load itself
    lazy = false,
    -- osv is needed if you want to debug neovim lua code. Also can be used
    -- as a way to quickly test-drive the plugin without configuring debug adapters
    dependencies = {
      'mason-org/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',
      'mfussenegger/nvim-dap',
      'jbyuki/one-small-step-for-vimkind',
    },
    config = function()
      local dapview = require 'dap-view'
      -- make sure you don't have any other keymaps that starts with "<leader>d" to avoid delay
      -- Alternative keybindings to "<leader>d" could be: "<leader>m", "<leader>;"
      vim.keymap.set({ 'n', 'v' }, '<leader>dv', dapview.toggle, { nowait = true, desc = '[D]ebug [V]iew Toggle' })

      dapview.setup {}

      local dap = require 'dap'
      dap.configurations.rust = {
        {
          name = 'Launch file (Tauri)',
          type = 'codelldb',
          request = 'launch',
          program = function()
            return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. 'src-tauri/target/debug/', 'file')
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
        },
      }

      vim.keymap.set({ 'n' }, '<leader>db', dap.toggle_breakpoint, { desc = '[D]ebug Toggle [b]reakpoint' })
      vim.keymap.set({ 'n' }, '<leader>dc', dap.continue, { desc = '[D]ebug [c]ontinue' })
      vim.keymap.set({ 'n' }, '<leader>dso', dap.step_over, { desc = '[D]ebug [s]tep [o]ver' })
      vim.keymap.set({ 'n' }, '<leader>dsi', dap.step_over, { desc = '[D]ebug [s]tep [i]into' })

      -- From https://github.com/StevanFreeborn/nvim-config/blob/main/lua/plugins/debugging.lua#L111-L123
      for _, adapterType in ipairs { 'node', 'chrome', 'msedge' } do
        local pwaType = 'pwa-' .. adapterType

        dap.adapters[pwaType] = {
          type = 'server',
          host = 'localhost',
          port = '${port}',
          executable = {
            command = 'node',
            args = {
              vim.fn.stdpath 'data' .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js',
              '${port}',
            },
          },
        }

        -- this allow us to handle launch.json configurations
        -- which specify type as "node" or "chrome" or "msedge"
        dap.adapters[adapterType] = function(cb, config)
          local nativeAdapter = dap.adapters[pwaType]
          config.type = pwaType

          if type(nativeAdapter) == 'function' then
            nativeAdapter(cb, config)
          else
            cb(nativeAdapter)
          end
        end
      end

      local enter_launch_url = function()
        local co = coroutine.running()
        return coroutine.create(function()
          vim.ui.input({ prompt = 'Enter URL: ', default = 'http://localhost:1420' }, function(url)
            if url == nil or url == '' then
              return
            else
              coroutine.resume(co, url)
            end
          end)
        end)
      end

      for _, language in ipairs { 'typescript', 'javascript', 'typescriptreact', 'javascriptreact', 'vue', 'svelte' } do
        dap.configurations[language] = {
          {
            type = 'pwa-chrome',
            request = 'launch',
            name = 'Launch Chrome (nvim-dap)',
            url = enter_launch_url,
            runtimeExecutable = '/Applications/Chromium.app/Contents/MacOS/Chromium',
            runtimeArgs = { '--remote-debugging-port=9222' },
            webRoot = '${workspaceFolder}',
            sourceMaps = true,
          },
        }
      end

      require('mason-nvim-dap').setup {
        ensure_installed = { 'codelldb', 'js-debug-adapter' },
        automatic_installation = false,
        handlers = nil,
      }

      vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })
      vim.fn.sign_define('DapStopped', { text = '⏸', texthl = '', linehl = '', numhl = '' })
      vim.fn.sign_define('DapBreakpointCondition', { text = '🔴', texthl = '', linehl = '', numhl = '' })
      vim.fn.sign_define('DapBreakpointRejected', { text = '❌', texthl = '', linehl = '', numhl = '' })
      vim.fn.sign_define('DapLogPoint', { text = '📝', texthl = '', linehl = '', numhl = '' })
    end,
  },
}
