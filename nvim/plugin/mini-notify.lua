vim.pack.add { 'https://github.com/nvim-mini/mini.nvim' }

require('mini.notify').setup {
  lsp_progress = {
    enable = false,
    duration_last = 2000,
    level = 'WARN', -- TODO: this doesn't seem to work (still get processing completion/diagnosing messages)
  },
}
