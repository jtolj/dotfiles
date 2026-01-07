-- Handle autoloading/auto-saving of session files.
local function get_session_filename()
  local git_branch = vim.fn.systemlist('git rev-parse --abbrev-ref HEAD')[1]
  local cwd = vim.fn.getcwd()
  local safe_cwd = cwd:gsub('[/\\:]', '_')
  return vim.fn.stdpath 'data' .. '/sessions/Session-' .. git_branch .. '-' .. safe_cwd .. '.vim'
end

vim.api.nvim_create_autocmd('VimEnter', {
  desc = 'Autoload session file if it exists',
  group = vim.api.nvim_create_augroup('autoload-session', { clear = true }),
  nested = true,
  callback = function()
    local session_file = get_session_filename()
    if vim.fn.filereadable(session_file) == 1 then
      vim.cmd('source ' .. session_file)
    end
  end,
})

vim.api.nvim_create_autocmd('VimLeavePre', {
  desc = 'Autosave session if it already exists before quitting',
  group = vim.api.nvim_create_augroup('autosave-session', { clear = true }),
  callback = function()
    local session_file = get_session_filename()
    if vim.fn.filereadable(session_file) == 1 then
      vim.cmd('mksession! ' .. vim.fn.fnameescape(session_file))
    end
  end,
})

local function save_session()
  local session_file = get_session_filename()
  vim.cmd('mksession! ' .. vim.fn.fnameescape(session_file))
  print('Session saved to: ' .. session_file)
end

vim.api.nvim_create_user_command('SessionSave', save_session, {})

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
