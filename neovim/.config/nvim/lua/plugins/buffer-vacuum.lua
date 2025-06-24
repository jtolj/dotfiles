return {
  'ChuufMaster/buffer-vacuum',
  lazy = false,
  keys = {
    { '<leader>bv', '<cmd>BufferVacuumToggle<cr>', desc = 'Toggle Vacuum' },
    { '<leader>bp', '<cmd>BufferVacuumPinBuffer<cr>', desc = 'Pin Buffer' },
  },
  opts = {
    max_buffers = 5,
    enabled_messages = true,
    count_pinned_buffers = false,
  },
}
