return {
  'adibhanna/laravel.nvim',
  dependencies = {
    'MunifTanjim/nui.nvim',
    'nvim-lua/plenary.nvim',
  },
  ft = { 'php', 'blade' },
  config = function()
    require('laravel').setup {
      notifications = false, -- Enable/disable Laravel.nvim notifications
      debug = false, -- Enable/disable debug error notifications
      keymaps = true, -- Enable/disable Laravel.nvim keymaps
      sail = {
        enabled = false, -- Enable/disable Laravel Sail integration
        auto_detect = false, -- Auto-detect Sail usage in project
        url = 'http://localhost', -- URL to open when using SailOpen command
      },
    }
  end,
}
