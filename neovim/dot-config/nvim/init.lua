-- disable netrw
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
-- disable swap file
vim.opt.swapfile = false
-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
vim.opt.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions'
-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

--
vim.opt_local.winbar = nil
-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.opt.confirm = true

-- Code Folding
vim.opt.foldtext = ''
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldnestmax = 4
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.FileTypeExpr(v:lnum, &filetype)'

-- adapted from https://gist.github.com/elementdavv/350361b3e45695f8152a4d8a97fff1ef
local doc_state = {}
local import_state = {}

local function getline(lnum)
  return vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1] or ''
end

local function DocExpr(lnum, bufnr)
  doc_state[bufnr] = doc_state[bufnr] or { hasdoc = 0 }
  local aline = getline(lnum)
  if aline:match '^%s*/%*.*%*/$' then
    if doc_state[bufnr].hasdoc > 0 then
      return '='
    else
      return '0'
    end
  elseif aline:match '^%s*/%*.*$' then
    doc_state[bufnr].hasdoc = doc_state[bufnr].hasdoc + 1
    return 'a1'
  elseif aline:match '^%s*%*/%s*$' then
    doc_state[bufnr].hasdoc = doc_state[bufnr].hasdoc - 1
    return 's1'
  elseif doc_state[bufnr].hasdoc > 0 then
    return '='
  end
  return '0'
end

local function ImportContinued(lnum, reg)
  local bufnr = vim.api.nvim_get_current_buf()
  local nextline = lnum
  while true do
    nextline = nextline + 1
    local bline = getline(nextline)
    if not bline then
      return false
    end
    if bline:match(reg) then
      return true
    end
    if bline:match '^%s*$' then
      -- skip blank
    else
      return false
    end
  end
end

local function ImportExpr(lnum, reg, bufnr)
  import_state[bufnr] = import_state[bufnr] or { hasimport = 0 }
  local aline = getline(lnum)
  if aline:match(reg) then
    if import_state[bufnr].hasimport == 1 then
      if ImportContinued(lnum, reg) then
        return '='
      else
        import_state[bufnr].hasimport = 0
        return 's1'
      end
    else
      if ImportContinued(lnum, reg) then
        import_state[bufnr].hasimport = 1
        return 'a1'
      else
        return '0'
      end
    end
  end
  if import_state[bufnr].hasimport == 1 then
    return '='
  end
  return '0'
end

function _G.FileTypeExpr(lnum, ft)
  local bufnr = vim.api.nvim_get_current_buf()
  if ft == 'php' then
    local docexpr = DocExpr(lnum, bufnr)
    if docexpr ~= '0' then
      return docexpr
    end
  end

  local reg = ''
  if ft == 'cpp' or ft == 'c' then
    reg = '^%s*#include'
  elseif ft == 'python' then
    reg = '^%s*(from.*)?import'
  elseif ft == 'php' then
    reg = '^%s*use'
  end

  if reg ~= '' then
    local importexpr = ImportExpr(lnum, reg, bufnr)
    if importexpr ~= '0' then
      return importexpr
    end
  end

  -- fallback to treesitter
  return vim.treesitter.foldexpr(lnum)
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'c', 'cpp', 'python', 'php' },
  callback = function(args)
    vim.api.nvim_set_option_value('foldexpr', 'v:lua.FileTypeExpr(v:lnum, &filetype)', {})
  end,
})

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Quick save
vim.keymap.set('n', ',,', ':w<cr>')

-- Indents
vim.opt_local.tabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true
vim.opt_local.autoindent = true
vim.opt_local.smarttab = true

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>Q', vim.diagnostic.open_float, { desc = 'Open diagnostic float' })

-- Move when in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move selected text down' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move selected text up' })

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<leader>wc', '<C-w>c', { desc = 'Close current window' })

-- Autosurround in visual mode
vim.keymap.set('v', '"', 'c""<esc>P')
vim.keymap.set('v', '[', 'c[]<esc>P')
vim.keymap.set('v', '(', 'c()<esc>P')
vim.keymap.set('v', "'", "c''<esc>P")
vim.keymap.set('v', '`', 'c``<esc>P')

-- Map Backhole Register to `\`
vim.keymap.set({ 'n', 'v' }, '\\', '"_', { desc = 'Black hole register' })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '⏸', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointCondition', { text = '🔴', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointRejected', { text = '❌', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapLogPoint', { text = '📝', texthl = '', linehl = '', numhl = '' })

-- Spelling
vim.opt.spell = false
vim.opt.spelllang = { 'en_us' }
vim.opt.spelloptions = 'camel'

local function add_all_spelling_mistakes()
  -- save view/cursor
  local view = vim.fn.winsaveview()
  -- go to top
  vim.cmd 'silent! normal! gg'

  local last_pos = { 0, 0 }

  -- loop over each bad word
  while true do
    local ok = pcall(vim.cmd, 'silent! normal! ]s')
    if not ok then
      break
    end

    -- get current cursor position
    local current_pos = vim.api.nvim_win_get_cursor(0)

    -- if we haven't moved, we're done
    if current_pos[1] == last_pos[1] and current_pos[2] == last_pos[2] then
      break
    end

    last_pos = current_pos

    -- mark it as good
    vim.cmd 'silent! normal! zg'
  end

  -- restore view/cursor
  vim.fn.winrestview(view)
end

vim.keymap.set('n', 'zG', add_all_spelling_mistakes, { desc = 'Add all words to spell list', silent = true })

local function toggle_spell()
  vim.opt.spell = not vim.opt.spell:get()
  if vim.opt.spell:get() then
    vim.notify('Spell checking enabled', vim.log.levels.INFO)
  else
    vim.notify('Spell checking disabled', vim.log.levels.INFO)
  end
end

vim.keymap.set('n', 'z!', toggle_spell, { desc = 'Toggle spell checking', silent = true })

-- Disable arrow keys in normal mode
vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- [[ Configure and install plugins ]]
--
--  To check the current status of your plugins, run
--    :Lazy
--
--  You can press `?` in this menu for help. Use `:q` to close the window
--
--  To update plugins you can run
--    :Lazy update
--
require('lazy').setup({
  { 'williamboman/mason.nvim', opts = {} },
  { import = 'plugins' },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
