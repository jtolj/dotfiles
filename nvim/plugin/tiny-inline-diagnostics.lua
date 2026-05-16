vim.pack.add { 'https://github.com/rachartier/tiny-inline-diagnostic.nvim' }

require('tiny-inline-diagnostic').setup {
  preset = 'powerline',
}

vim.diagnostic.config { virtual_text = false } -- Disable default virtual text
