vim.pack.add { 'https://github.com/nvim-mini/mini.nvim' }

require('mini.notify').setup {
  lsp_progress = {
    -- Whether to enable showing
    enable = false,
  },
  content = {
    format = function(n)
      return '\n' .. '   ' .. n.msg .. '   \n'
    end,
  },
}
