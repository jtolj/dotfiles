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
