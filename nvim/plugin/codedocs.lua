vim.pack.add { 'https://github.com/jeangiraldoo/codedocs.nvim' }

require('codedocs').setup {}

vim.keymap.set('n', '<leader>ck', '<cmd>Codedocs<CR>', { desc = 'Insert annotation' })
