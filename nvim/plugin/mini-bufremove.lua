vim.pack.add { 'https://github.com/nvim-mini/mini.nvim' }

local bufrem = require 'mini.bufremove'

vim.keymap.set('n', 'bd', function()
  bufrem.delete()
end)
