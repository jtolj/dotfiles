require 'settings'
require 'spelling'
require 'commands'
require 'keymaps'
require 'autocommands'

vim.cmd.packadd 'nvim.undotree'
vim.keymap.set('n', '<leader>u', require('undotree').open)

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
