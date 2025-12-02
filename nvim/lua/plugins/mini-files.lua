return {
  'nvim-mini/mini.files',
  version = '*',
  keys = {
    {
      '<leader>e',
      function()
        local MiniFiles = require 'mini.files'
        if not MiniFiles.close() then
          MiniFiles.open(nil, false)
        end
      end,
      desc = 'Open mini.files',
    },
    {
      '<leader>E',
      function()
        local MiniFiles = require 'mini.files'
        if not MiniFiles.close() then
          MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
          MiniFiles.reveal_cwd()
        end
      end,
      desc = 'Open mini.files in current working directory',
    },
  },
  config = function()
    -- Show/Hide dotfiles
    -- https://github.com/nvim-mini/mini.nvim/blob/25c4bf4efac51aad5393e37949e68ac3e672a73c/doc/mini-files.txt#L400-L426
    local show_dotfiles = false

    local filter_show = function(fs_entry)
      return true
    end

    local filter_hide = function(fs_entry)
      return not vim.startswith(fs_entry.name, '.')
    end

    local toggle_dotfiles = function()
      show_dotfiles = not show_dotfiles
      local new_filter = show_dotfiles and filter_show or filter_hide
      MiniFiles.refresh { content = { filter = new_filter } }
    end

    vim.api.nvim_create_autocmd('User', {
      pattern = 'MiniFilesBufferCreate',
      callback = function(args)
        local buf_id = args.data.buf_id
        -- Tweak left-hand side of mapping to your liking
        vim.keymap.set('n', 'g.', toggle_dotfiles, { buffer = buf_id })
      end,
    })

    require('mini.files').setup {
      -- Customization of shown content
      content = {
        -- Predicate for which file system entries to show
        filter = show_dotfiles and filter_show or filter_hide,
        -- Highlight group to use for a file system entry
        highlight = nil,
        -- Prefix text and highlight to show to the left of file system entry
        prefix = nil,
        -- Order in which to show file system entries
        sort = nil,
      },

      -- Module mappings created only inside explorer.
      -- Use `''` (empty string) to not create one.
      mappings = {
        close = '<ESC>',
        go_in = 'l',
        go_in_plus = 'L',
        go_out = 'h',
        go_out_plus = 'H',
        mark_goto = "'",
        mark_set = 'm',
        reset = '<BS>',
        reveal_cwd = '@',
        show_help = 'g?',
        synchronize = '=',
        trim_left = '<',
        trim_right = '>',
      },

      -- General options
      options = {
        -- Whether to delete permanently or move into module-specific trash
        permanent_delete = true,
        -- Whether to use for editing directories
        use_as_default_explorer = true,
      },

      -- Customization of explorer windows
      windows = {
        -- Maximum number of windows to show side by side
        max_number = 5,
        -- Whether to show preview of file/directory under cursor
        preview = true,
        -- Width of focused window
        width_focus = 50,
        -- Width of non-focused window
        width_nofocus = 15,
        -- Width of preview window
        width_preview = 120,
      },
    }
  end,
}
