return { -- Autoformat
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>c!',
      function()
        -- If autoformat is currently disabled for this buffer,
        -- then enable it, otherwise disable it
        if vim.b.disable_autoformat then
          vim.cmd 'FormatEnable'
          vim.notify 'Enabled autoformat for current buffer'
        else
          vim.cmd 'FormatDisable!'
          vim.notify 'Disabled autoformat for current buffer'
        end
      end,
      desc = 'Toggle autoformat for current buffer',
    },
    {
      '<leader>cf',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = 'n',
      desc = '[F]ormat buffer',
    },
  },
  config = function(_, opts)
    require('conform').setup(opts)

    vim.api.nvim_create_user_command('FormatDisable', function(args)
      if args.bang then
        -- :FormatDisable! disables autoformat for this buffer only
        vim.b.disable_autoformat = true
      else
        -- :FormatDisable disables autoformat globally
        vim.g.disable_autoformat = true
      end
    end, {
      desc = 'Disable autoformat-on-save',
      bang = true, -- allows the ! variant
    })

    vim.api.nvim_create_user_command('FormatEnable', function()
      vim.b.disable_autoformat = false
      vim.g.disable_autoformat = false
    end, {
      desc = 'Re-enable autoformat-on-save',
    })
  end,
  opts = {
    notify_on_error = true,
    format_on_save = function(bufnr)
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      local disable_filetypes = { c = true, cpp = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      else
        return {
          timeout_ms = 700,
          lsp_format = 'fallback',
        }
      end
    end,
    formatters = {
      caddy = {
        command = 'caddy',
        args = { 'fmt', '-' },
        stdin = true,
      },
    },
    formatters_by_ft = {
      lua = { 'stylua' },
      php = { 'pint', 'mago_format', stop_after_first = true },
      blade = { 'blade-formatter', stop_after_first = true },
      javascript = { 'biome', 'prettierd', stop_after_first = true },
      json = { 'biome', 'prettierd', stop_after_first = true },
      html = { 'prettierd', stop_after_first = true },
      css = { 'prettierd', stop_after_first = true },
      caddy = { 'caddy' },
      go = { 'goimports', 'gofmt' },
    },
  },
}
