vim.pack.add { 'https://github.com/igorlfs/nvim-dap-view' }
vim.pack.add { 'https://github.com/mason-org/mason.nvim' }
vim.pack.add { 'https://github.com/jay-babu/mason-nvim-dap.nvim' }
vim.pack.add { 'https://github.com/mfussenegger/nvim-dap' }
vim.pack.add { 'https://github.com/jbyuki/one-small-step-for-vimkind' }

local dapview = require 'dap-view'

-- make sure you don't have any other keymaps that starts with "<leader>d" to avoid delay
-- Alternative keybindings to "<leader>d" could be: "<leader>m", "<leader>;"
vim.keymap.set({ 'n', 'v' }, '<leader>dv', dapview.toggle, { nowait = true, desc = 'Toggle debug view' })

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

vim.keymap.set({ 'n' }, '<leader>db', dap.toggle_breakpoint, { desc = 'Toggle breakpoint' })
vim.keymap.set({ 'n' }, '<leader>dc', dap.continue, { desc = 'Debug continue' })
vim.keymap.set({ 'n' }, '<leader>dso', dap.step_over, { desc = 'Debug step over' })
vim.keymap.set({ 'n' }, '<leader>dsi', dap.step_over, { desc = 'Debug step into' })

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
dap.configurations.lua = {
  {
    type = 'nlua',
    request = 'attach',
    name = 'Attach to running Neovim instance',
  },
}

dap.adapters.nlua = function(callback, config)
  callback { type = 'server', host = config.host or '127.0.0.1', port = config.port or 8086 }
end

vim.keymap.set('n', '<leader>dl', function()
  require('osv').launch { port = 8086 }
end, { noremap = true, desc = 'Start Lua debug server' })

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
