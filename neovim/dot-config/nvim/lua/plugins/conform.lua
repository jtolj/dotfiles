return { -- Autoformat
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>cf',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = 'n',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = true,
    format_on_save = function(bufnr)
      local disable_filetypes = { c = true, cpp = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      else
        return {
          timeout_ms = 4000,
          lsp_format = 'fallback',
        }
      end
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      php = { 'pint', stop_after_first = true },
      blade = { 'blade-formatter', stop_after_first = true },
      javascript = { 'biome', 'prettier', stop_after_first = true },
      json = { 'biome', 'prettier', stop_after_first = true },
      html = { 'htmlbeautifier', 'prettier', stop_after_first = true },
    },
  },
}
