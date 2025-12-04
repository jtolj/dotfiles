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
