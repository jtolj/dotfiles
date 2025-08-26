local function get_codecompanion_chat()
  local chat = require('codecompanion').buf_get_chat(vim.api.nvim_get_current_buf())
  if not chat then
    return nil
  end
  return chat
end

local status = 0

local group = vim.api.nvim_create_augroup('CodeCompanionHooks', {})
vim.api.nvim_create_autocmd({ 'User' }, {
  pattern = 'CodeCompanionRequest*',
  group = group,
  callback = function(request)
    local previous_status = status
    if request.match == 'CodeCompanionRequestStarted' then
      status = 1
    elseif request.match == 'CodeCompanionRequestStreaming' then
      status = 2
    elseif request.match == 'CodeCompanionRequestFinished' then
      status = 0
    else
      status = 0
    end
    if status ~= previous_status then
      require('lualine').refresh()
    end
  end,
})

local codecompanion = {
  adapter_name = function()
    local chat = get_codecompanion_chat()
    if not chat then
      return nil
    end

    return ' ' .. chat.adapter.formatted_name
  end,

  model_name = function()
    local chat = get_codecompanion_chat()
    if not chat then
      return nil
    end

    return ' ' .. chat.settings.model
  end,

  status = function()
    if status == 0 then
      return ''
    elseif status == 1 then
      return '󱎫'
    elseif status == 2 then
      return '󰍦'
    end
    return ''
  end,
}

local dmode_enabled = false
vim.api.nvim_create_autocmd('User', {
  pattern = 'DebugModeChanged',
  callback = function(args)
    dmode_enabled = args.data.enabled
  end,
})

local mode = {
  'mode',
  fmt = function(s)
    return dmode_enabled and 'DEBUG' or s
  end,
}

return {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  dependencies = { 'nvim-tree/nvim-web-devicons', lazy = true },
  opts = {
    theme = 'auto',
    inactive_sections = {
      lualine_a = {
        {
          'filename',
          symbols = {
            modified = ' ●',
            readonly = ' ',
            unnamed = '',
          },
        },
      },
      lualine_b = {},
      lualine_c = {},
      lualine_x = {},
      lualine_y = {},
      lualine_z = {},
    },
    sections = {
      lualine_a = { mode },
      lualine_b = { 'branch', 'diff', 'diagnostics' },
      lualine_c = {},
      lualine_x = { 'encoding', 'fileformat', 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    },
    extensions = {
      {
        filetypes = { 'codecompanion' },
        sections = {
          lualine_a = { mode },
          lualine_b = { codecompanion.adapter_name },
          lualine_c = { codecompanion.status },
          lualine_x = { codecompanion.model_name },
          lualine_y = {},
          lualine_z = { 'location' },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = { codecompanion.adapter_name },
          lualine_c = {},
          lualine_x = { codecompanion.model_name },
          lualine_y = {},
          lualine_z = {},
        },
      },
    },
  },
}
