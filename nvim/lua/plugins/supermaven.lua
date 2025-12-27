---@module "lazy"
---@type LazySpec
return {
  'supermaven-inc/supermaven-nvim',
  -- keymaps = {
  --   accept_suggestion = '<Tab>',
  --   clear_suggestion = '<C-]>',
  --   accept_word = '<C-j>',
  -- },
  opts = {
    disable_inline_completion = true, -- disables inline completion for use with cmp
    disable_keymaps = true, -- disables built in keymaps for more manual control
  },
}
