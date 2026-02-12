return {
  'nickjvandyke/opencode.nvim',
  dependencies = {
    ---@module 'snacks'
    { 'folke/snacks.nvim', opts = { input = {}, picker = {}, terminal = {} } },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      prompts = {
        grammar = {
          prompt = '@buffer Can you check this content for spelling and grammar errors? Please also check for consistent tone. Be sure to reference specific line numbers, and give a summary of each change after providing the old and new lines. Do not change anything, just make suggestions.',
          submit = true,
          ask = false,
        },
      },
      provider = {
        enabled = 'wezterm',
        wezterm = { direction = 'right', percent = 30 },
      },
    }

    -- Required for `opts.events.reload`.
    vim.o.autoread = true

    -- Recommended keymaps.
    vim.keymap.set({ 'n', 'x' }, '<leader>aa', function()
      require('opencode').ask('@this: ', { submit = true })
    end, { desc = 'Ask opencode' })

    vim.keymap.set({ 'n', 't' }, '<leader>ac', function()
      require('opencode').toggle()
    end, { desc = 'Toggle opencode' })

    vim.keymap.set('n', '<leader>as', function()
      require('opencode').select_session()
    end, { desc = 'Select opencode session' })

    vim.keymap.set({ 'n', 'x' }, '<leader>ap', function()
      require('opencode').select()
    end, { desc = 'Pick opencode action' })

    vim.keymap.set({ 'n', 'x' }, '<leader>ao', function()
      return require('opencode').operator '@this '
    end, { desc = 'Add range to opencode', expr = true })

    vim.keymap.set('n', '<leader>ak', function()
      require('opencode').command 'session.half.page.up'
    end, { desc = 'Scroll opencode up' })

    vim.keymap.set('n', '<leader>aj', function()
      require('opencode').command 'session.half.page.down'
    end, { desc = 'Scroll opencode down' })
  end,
}
