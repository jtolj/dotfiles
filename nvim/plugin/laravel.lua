vim.pack.add { 'https://github.com/MunifTanjim/nui.nvim' }
vim.pack.add { 'https://github.com/nvim-lua/plenary.nvim' }
vim.pack.add { 'https://github.com/nvim-neotest/nvim-nio' }
-- vim.pack.add { 'https://github.com/adalessa/laravel.nvim' }
vim.cmd.packadd 'laravel.nvim'

local function is_laravel_project()
  return vim.uv.fs_stat(vim.fs.joinpath(vim.uv.cwd(), 'artisan')) ~= nil
end

if is_laravel_project() then
  local laravel = require 'laravel'
  laravel.setup {
    features = {
      pickers = {
        provider = 'fzf-lua',
      },
    },
  }

  vim.g.Laravel = laravel

  local function map(lhs, fn, desc)
    vim.keymap.set('n', lhs, fn, { desc = desc })
  end

  map('<leader>ll', function()
    Laravel.pickers.laravel()
  end, 'Laravel: Open Artisan Picker')

  map('<leader>la', function()
    Laravel.pickers.artisan()
  end, 'Laravel: Open Artisan Picker')

  map('<leader>lr', function()
    Laravel.pickers.routes()
  end, 'Laravel: Open Routes Picker')

  map('<leader>lm', function()
    Laravel.pickers.make()
  end, 'Laravel: Open Make Picker')

  map('<leader>lc', function()
    Laravel.pickers.commands()
  end, 'Laravel: Open Commands Picker')

  map('<leader>lo', function()
    Laravel.pickers.resources()
  end, 'Laravel: Open Resources Picker')

  map('<leader>lu', function()
    Laravel.commands.run 'hub'
  end, 'Laravel Artisan hub')

  map('<leader>lh', function()
    Laravel.run 'artisan docs'
  end, 'Laravel: Open Documentation')

  map('<c-g>', function()
    Laravel.commands.run 'view:finder'
  end, 'Laravel: Open View Finder')

  map('<leader>lp', function()
    Laravel.commands.run 'command_center'
  end, 'Laravel: Open Command Center')

  vim.keymap.set('n', 'gf', function()
    local ok, res = pcall(function()
      if Laravel.app('gf').cursorOnResource() then
        return "<cmd>lua Laravel.commands.run('gf')<cr>"
      end
    end)
    if not ok or not res then
      return 'gf'
    end
    return res
  end, { desc = 'Laravel: Go to resource', expr = true, noremap = true })
end
