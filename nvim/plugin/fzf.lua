vim.pack.add { 'https://github.com/ibhagwan/fzf-lua' }
local fzf = require 'fzf-lua'

fzf.setup {
  keymap = {
    fzf = {
      ['ctrl-q'] = 'select-all+accept',
    },
  },
}

fzf.register_ui_select()

vim.keymap.set('n', '<leader><space>', function()
  fzf.files()
end, {
  desc = 'Fuzzy search files',
})

vim.keymap.set('n', '<leader>/', function()
  fzf.live_grep_native()
end, {
  desc = 'Live grep',
})
vim.keymap.set('n', '<leader>sn', function()
  -- TODO: fzf_exec with get_all()
  require('mini.notify').show_history()
end, { desc = 'Search notification history' })

vim.keymap.set('n', '<leader>,', function()
  fzf.buffers()
end, {
  desc = 'Search open buffers',
})

vim.keymap.set('n', '<leader>ss', function()
  fzf.lsp_document_symbols()
end, {
  desc = 'Search symbols (file)',
})

vim.keymap.set('n', '<leader>sl', function()
  fzf.lsp_finder()
end, {
  desc = 'Search symbols (workspaces)',
})

vim.keymap.set('n', '<leader>sd', function()
  fzf.lsp_document_diagnostics()
end, {
  desc = 'Search diagnostics (file)',
})

vim.keymap.set('n', '<leader>sD', function()
  fzf.lsp_workspace_diagnostics()
end, {
  desc = 'Search diagnostics (workspace)',
})

vim.keymap.set('n', '<leader>sm', function()
  fzf.marks()
end, {
  desc = 'Search marks',
})

vim.keymap.set('n', '<leader>sr', function()
  fzf.registers()
end, {
  desc = 'Search registers',
})

vim.keymap.set('n', '<leader>su', function()
  fzf.undotree()
end, {
  desc = 'Search undotree',
})

vim.keymap.set('n', '<leader>s?', function()
  fzf.builtin()
end, { desc = 'Search pickers' })

vim.keymap.set('n', 'gd', function()
  fzf.lsp_definitions { jump1 = true }
end, {
  desc = 'LSP definitions',
})

vim.keymap.set('n', 'gD', function()
  fzf.lsp_declarations()
end, {
  desc = 'LSP declaration',
})

vim.keymap.set({ 'n' }, '<leader>dsr', function()
  fzf.dap_commands()
end, { desc = 'Debug search commands' })

vim.keymap.set({ 'n' }, '<leader>dsc', function()
  fzf.dap_commands()
end, { desc = 'Debug search configs' })

vim.keymap.set({ 'n' }, '<leader>dsb', function()
  fzf.dap_breakpoints()
end, { desc = 'Debug search breakpoints' })

vim.keymap.set({ 'n' }, '<leader>dsv', function()
  fzf.dap_breakpoints()
end, { desc = 'Debug search variables' })

vim.keymap.set({ 'n' }, '<leader>dsf', function()
  fzf.dap_breakpoints()
end, { desc = 'Debug jump to frame' })
