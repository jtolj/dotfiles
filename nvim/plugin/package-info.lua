vim.pack.add { 'https://github.com/vuki656/package-info.nvim' }
require('package-info').setup {
  package_manager = 'bun',
}

vim.keymap.set('n', '<leader>ns', "<cmd>lua require('package-info').show()<cr>", {
  desc = 'Show package info',
  silent = true,
  noremap = true,
})

vim.keymap.set('n', '<leader>nd', "<cmd>lua require('package-info').delete()<cr>", { desc = 'Delete package', silent = true, noremap = true })

vim.keymap.set('n', '<leader>np', "<cmd>lua require('package-info').change_version()<cr>", { desc = 'Change package version', silent = true, noremap = true })
