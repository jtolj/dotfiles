-- https://github.com/magoz/.dotfiles/blob/d66d1b31d6186c5e2b7d2edbd762f363ff2b765a/nvim/.config/nvim/lua/magoz/plugins/nvim-tree.lua
-- Float window ratio
local HEIGHT_RATIO = 0.8
local WIDTH_RATIO = 0.8

return {
  {
    'nvim-tree/nvim-tree.lua',
    lazy = false,
    config = function()
      require('nvim-tree').setup {
        actions = {
          open_file = {
            -- quit_on_open = true,
          },
        },
        filters = {
          dotfiles = false, -- display dotfiles by default. Can be toggled with H
          custom = { -- always hide these files
            '.DS_Store',
          },
          exclude = { -- always show these files
            '.env',
            '.env.local',
          },
        },
        git = {
          ignore = true, -- show listed files in .gitignore by default. Can be toggled with I
        },
        update_focused_file = {
          enable = true,
          update_cwd = true,
        },
        renderer = {
          root_folder_modifier = ':t',
          icons = {
            glyphs = {
              default = '',
              symlink = '',
              folder = {
                arrow_open = '',
                arrow_closed = '',
                default = '',
                open = '',
                empty = '',
                empty_open = '',
                symlink = '',
                symlink_open = '',
              },
              git = {
                unstaged = '',
                staged = 'S',
                unmerged = '',
                renamed = '➜',
                untracked = 'U',
                deleted = '',
                ignored = '◌',
              },
            },
          },
        },
        diagnostics = {
          enable = true,
          show_on_dirs = true,
          icons = {
            hint = '󰌶',
            info = '',
            warning = '',
            error = '',
          },
        },
        view = {
          width = 50,
        },
      }
      -- Automatically open file on creation
      -- https://github.com/nvim-tree/nvim-tree.lua/issues/1120
      local api = require 'nvim-tree.api'
      api.events.subscribe(api.events.Event.FileCreated, function(file)
        vim.cmd('edit ' .. file.fname)
      end)

      vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', { desc = 'File Explorer via nvim tree' })
    end,
  },
}
