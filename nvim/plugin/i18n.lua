local dev = vim.fn.expand '~/Projects/opensource/i18n.nvim'

if vim.fn.isdirectory(dev) == 1 then
  vim.opt.rtp:prepend(dev)
else
  vim.pack.add {
    'https://github.com/yelog/i18n.nvim',
  }
end

require('i18n').setup {
  activation = 'auto',
}

vim.keymap.set('n', 'K', function()
  if require('i18n.display').get_key_under_cursor() then
    require('i18n').show_popup()
    return
  end

  if #vim.lsp.get_clients { bufnr = 0, method = 'textDocument/hover' } > 0 then
    vim.lsp.buf.hover()
  end
end, { desc = 'i18n translations or LSP hover' })
