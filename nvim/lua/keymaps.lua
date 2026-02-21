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
-- See lua/plugins/wezterm.lua
-- vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
-- vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
-- vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
-- vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<leader>wc', '<C-w>c', { desc = 'Close current window' })

-- Autosurround in visual mode
vim.keymap.set('v', '"', 'c""<esc>P')
vim.keymap.set('v', '[', 'c[]<esc>P')
vim.keymap.set('v', '(', 'c()<esc>P')
vim.keymap.set('v', "'", "c''<esc>P")
vim.keymap.set('v', '`', 'c``<esc>P')

-- Map Backhole Register to `\`
vim.keymap.set({ 'n', 'v' }, '\\', '"_', { desc = 'Black hole register' })

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Quick save
vim.keymap.set('n', ',,', '<cmd>silent w<CR>')
