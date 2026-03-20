---@module "lazy"
---@type LazySpec

local dmode_enabled = false
vim.api.nvim_create_autocmd('User', {
  pattern = 'DebugModeChanged',
  callback = function(args)
    dmode_enabled = args.data.enabled
  end,
})

local mode = {
  'mode',
  fmt = function(s)
    return dmode_enabled and 'DEBUG' or s
  end,
}

return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  dependencies = { 'nvim-tree/nvim-web-devicons', lazy = true },
  opts = {
    theme = 'auto',
    sections = {
      lualine_a = { mode, 'filename' },
      lualine_b = { 'branch', 'diff', 'diagnostics' },
      lualine_c = {},
      lualine_x = { 'encoding', 'fileformat', 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    },
  },
}
