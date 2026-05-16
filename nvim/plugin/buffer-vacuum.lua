vim.pack.add { 'https://github.com/ChuufMaster/buffer-vacuum' }

require('buffer-vacuum').setup {
  max_buffers = 6,
  enabled_messages = true,
  count_pinned_buffers = false,
}

vim.keymap.set('n', '<leader>bv', '<cmd>BufferVacuumToggle<cr>', { desc = 'Toggle Vacuum' })
vim.keymap.set('n', '<leader>bp', '<cmd>BufferVacuumPinBuffer<cr>', { desc = 'Pin Buffer' })
