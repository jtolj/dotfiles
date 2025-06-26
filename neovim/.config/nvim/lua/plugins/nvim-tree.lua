return {
  'nvim-tree/nvim-tree.lua',
  config = function()
    require('nvim-tree').setup()
  end,
  keys = {
    {
      '<leader>e',
      function()
        vim.cmd 'NvimTreeToggle'
      end,
      desc = 'Open nvim tree',
    },
  },
}
