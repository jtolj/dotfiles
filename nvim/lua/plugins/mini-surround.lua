---@module "lazy"
---@type LazySpec
return {
  'nvim-mini/mini.surround',
  version = '*',
  config = function()
    require('mini.surround').setup {
      highlight_duration = 2000,
    }
  end,
}
