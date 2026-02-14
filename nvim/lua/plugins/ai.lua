local function focus_pane(pane_id)
  vim.fn.system(string.format('wezterm cli activate-pane --pane-id %d', pane_id))
end

local wez = {}
wez.name = 'wezterm-custom'
wez.cmd = 'opencode --port'
wez.pane_id = nil

function wez:get_pane_id()
  if self.pane_id == nil then
    return nil
  end

  local result = vim.fn.system 'wezterm cli list --format json 2>&1'

  if result == nil or result == '' or result:match 'error' then
    self.pane_id = nil
    return nil
  end

  local success, panes = pcall(vim.json.decode, result)
  if not success or type(panes) ~= 'table' then
    self.pane_id = nil
    return nil
  end

  -- Search for the pane in the list
  for _, pane in ipairs(panes) do
    if tostring(pane.pane_id) == tostring(self.pane_id) then
      return self.pane_id
    end
  end

  -- Pane was not found in the list
  self.pane_id = nil
  return nil
end

function wez:is_zoomed()
  local result = vim.fn.system 'wezterm cli list --format json 2>&1'
  if result == nil or result == '' or result:match 'error' then
    vim.notify 'Could not determine zoomed status.'
    return
  end

  local success, panes = pcall(vim.json.decode, result)
  if not success or type(panes) ~= 'table' then
    vim.notify 'Could not decode results.'
    return
  end
  for _, pane in ipairs(panes) do
    if tostring(pane.pane_id) == tostring(vim.env.WEZTERM_PANE) then
      return pane.is_zoomed
    end
  end
  vim.notify 'Could not find pane.'
end

function wez:toggle()
  local pane_id = self:get_pane_id()
  if pane_id then
    local cmd_parts = { 'wezterm', 'cli', 'zoom-pane', '--pane-id', vim.env.WEZTERM_PANE }
    if self:is_zoomed() then
      table.insert(cmd_parts, '--unzoom')
    else
      table.insert(cmd_parts, '--zoom')
    end
    local result = vim.fn.system(table.concat(cmd_parts, ' '))
  else
    self:start()
  end
end

function wez:start()
  local pane_id = self:get_pane_id()

  if not pane_id then
    if self:is_zoomed() then
      local cmd_parts = { 'wezterm', 'cli', 'zoom-pane', '--pane-id', vim.env.WEZTERM_PANE, '--unzoom' }
      local result = vim.fn.system(table.concat(cmd_parts, ' '))
    end

    local cmd_parts = { 'wezterm', 'cli', 'split-pane', '--right', '--percent', '30', '--top-level' }

    table.insert(cmd_parts, '--')
    table.insert(cmd_parts, self.cmd)

    local result = vim.fn.system(table.concat(cmd_parts, ' '))

    focus_pane(vim.env.WEZTERM_PANE)

    self.pane_id = result:match '^%d+'
  end
end

function wez:stop()
  local pane_id = self:get_pane_id()

  if pane_id then
    vim.fn.system(string.format('wezterm cli kill-pane --pane-id %d', pane_id))
    self.pane_id = nil
    if self:is_zoomed() then
      local cmd_parts = { 'wezterm', 'cli', 'zoom-pane', '--pane-id', vim.env.WEZTERM_PANE, '--unzoom' }
      local result = vim.fn.system(table.concat(cmd_parts, ' '))
    end
  end
end

function wez:health()
  return vim.env.WEZTERM_PANE ~= nil
end

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
      provider = wez,
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

    vim.keymap.set({ 'n', 't' }, '<leader>aC', function()
      local provider = require('opencode.config').provider
      if provider and provider.pane_id then
        focus_pane(provider.pane_id)
      end
    end, { desc = 'Focus opencode' })

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
