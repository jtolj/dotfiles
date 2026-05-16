vim.pack.add { 'https://github.com/letieu/wezterm-move.nvim' }

local wm = require 'wezterm-move'

vim.keymap.set('n', '<C-h>', function()
  wm.move 'h'
end)

vim.keymap.set('n', '<C-j>', function()
  wm.move 'j'
end)

vim.keymap.set('n', '<C-k>', function()
  wm.move 'k'
end)

vim.keymap.set('n', '<C-l>', function()
  wm.move 'l'
end)
