vim.pack.add { 'https://github.com/folke/sidekick.nvim' }

require('sidekick').setup {
  nes = { enabled = false },
  copilot = { status = { enabled = false } },
  cli = {
    win = {
      split = {
        width = 0.4,
      },
    },
  },
}

vim.keymap.set({ 'n', 'v' }, '<leader>ac', function()
  require('sidekick.cli').toggle { name = 'opencode', focus = true }
end, { desc = 'Sidekick Toggle CLI' })

vim.keymap.set('n', '<leader>ad', function()
  require('sidekick.cli').close()
end, { desc = 'Detach a CLI Session' })

vim.keymap.set({ 'n', 'x' }, '<leader>at', function()
  require('sidekick.cli').send { msg = '{this}' }
end, { desc = 'Send This' })

vim.keymap.set('n', '<leader>af', function()
  require('sidekick.cli').send { msg = '{file}' }
end, { desc = 'Send File' })

vim.keymap.set('x', '<leader>av', function()
  require('sidekick.cli').send { msg = '{selection}' }
end, { desc = 'Send Visual Selection' })

vim.keymap.set({ 'n', 'x' }, '<leader>ap', function()
  require('sidekick.cli').prompt()
end, { desc = 'Sidekick Select Prompt' })
