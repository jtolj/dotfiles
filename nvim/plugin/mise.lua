vim.api.nvim_create_user_command('Mise', function(args)
  vim.cmd('term mise run ' .. args.args)
end, { desc = 'Execute mise run', nargs = '*' })

vim.api.nvim_create_user_command('MisePick', function(args)
  local fzf = require 'fzf-lua'
  local command = { 'mise', 'tasks', '--json' }

  local result = vim.system(command, { text = true }):wait()
  if result.code ~= 0 then
    return vim.notify(vim.inspect(result))
  end

  local items_json = vim.json.decode(result.stdout)

  local tasks = {}
  local task_data = {}
  for _, task in ipairs(items_json) do
    local name = string.format('%-30s %s', task.name, task.description)
    table.insert(tasks, name)
    task_data[name] = task
  end

  if #tasks == 0 then
    vim.notify 'No mise tasks were found.'
    return
  end

  require('fzf-lua').fzf_exec(tasks, {
    prompt = 'mise task > ',
    fzf_opts = {
      ['--header'] = '[enter] run in nvim  |  [ctrl-r] run in wezterm tab',
    },
    actions = {
      ['default'] = function(selected, opts)
        if selected[1] == nil then
          return
        end
        local task_details = task_data[selected[1]]
        local task = string.sub(selected[1], 1, 30)
        -- vim.notify(vim.inspect(task_details))
        -- TODO: handle providing argument(s) with vim.ui.input
        vim.cmd('term mise run ' .. task:match '(.+)%s*$')
      end,

      ['ctrl-r'] = function(selected, opts)
        if selected[1] == nil then
          return
        end
        local task_details = task_data[selected[1]]
        local task = string.sub(selected[1], 1, 30)
        local cwd = vim.env.MISE_PROJECT_ROOT or vim.fn.getcwd()
        vim.fn.jobstart(
          { 'wezterm', 'cli', 'spawn', '--cwd', cwd, '--', 'zsh', '-lc', 'mise run ' .. task:match '(.+)%s*$' .. '; exec zsh -l' },
          { detach = true }
        )
      end,
    },
  })
end, { desc = 'Mise task picker' })

vim.keymap.set('n', '<leader>M', function()
  vim.cmd 'MisePick'
end, { desc = 'Pick mise task' })
