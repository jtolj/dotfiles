return {
  dir = '/Users/jesse/Projects/bufferin.nvim', -- Use local directory instead of GitHub repo
  name = 'bufferin.nvim', -- Optional: specify plugin name for lazy.nvim
  opts = {
    -- Window appearance
    window = {
      width = 0.8, -- 80% of screen width
      height = 0.8, -- 80% of screen height
      border = 'rounded', -- 'single', 'double', 'rounded', 'solid', 'shadow', 'none'
      position = 'center',
    },

    -- Key mappings (inside bufferin window)
    mappings = {
      select = '<CR>', -- Select buffer
      delete = 'dd', -- Delete buffer
      move_up = 'K', -- Move buffer up
      move_down = 'J', -- Move buffer down
      quit = '<ESC>', -- Close window
    },

    -- Display options
    display = {
      show_numbers = true, -- Show buffer numbers
      show_modified = true, -- Show modified indicator (●)
      show_path = true, -- Show file paths
      show_hidden = false, -- Show hidden/unlisted buffers
      show_icons = true, -- Show file type icons
    },

    -- Icon configuration
    icons = {
      modified = '●', -- Modified buffer indicator
      readonly = '', -- Read-only buffer indicator
      terminal = '', -- Terminal buffer indicator
      provider = 'auto', -- 'auto', 'devicons', 'mini', or 'builtin'

      -- Built-in icon fallbacks (when no icon plugin available)
      builtin = {
        default = '',
        lua = '',
        vim = '',
        js = '',
        ts = '',
        py = '',
        -- ... (see lua/bufferin/config.lua for complete list)
      },
    },

    -- Experimental/optional features
    show_window_layout = false, -- Show window layout visualization (experimental)
  },
  dependencies = {
    'nvim-tree/nvim-web-devicons', -- For file icons
  },
  keys = {
    {
      '<leader>,',
      function()
        require('bufferin').open()
      end,
      desc = 'Buffers',
    },
  },
}
