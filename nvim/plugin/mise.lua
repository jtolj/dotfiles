vim.api.nvim_create_user_command('Mise', function(args)
  vim.cmd('term mise run ' .. args.args)
end, { desc = 'Execute mise run', nargs = '*' })

local function recurse_input(task_name, args, inputs, callback)
  local current_arg = table.remove(args)
  -- TODO: any way to show the description of the arg here?
  vim.ui.input({
    prompt = task_name .. ' Please enter > ' .. current_arg,
  }, function(input)
    if input then
      table.insert(inputs, input)
    end
    if #args > 0 then
      recurse_input(task_name, args, inputs, callback)
    else
      callback(inputs)
    end
  end)
end

local function run_task(task_name, task_details, cmd_builder)
  local usage = task_details.usage or ''
  if usage == '' then
    cmd_builder(task_name, '')
    return
  end
  local args = {}

  for line in usage:gmatch '[^\n]+' do
    local name = line:match 'arg "([^"]+)"'
    if name then
      args[#args + 1] = name
    end
  end

  local i, j = 1, #args
  while i < j do
    args[i], args[j] = args[j], args[i]

    i = i + 1
    j = j - 1
  end

  recurse_input(task_name, args, {}, function(inputs)
    local input = table.concat(inputs, ' ')
    cmd_builder(task_name, ' ' .. input)
  end)
end

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

        local task = string.sub(selected[1], 1, 30)
        local task_name = task:match '(.+)%s*$'
        local details = task_data[selected[1]]

        run_task(task_name, details, function(name, args)
          vim.cmd('term mise run ' .. name .. args)
        end)
      end,

      ['ctrl-r'] = function(selected, opts)
        if selected[1] == nil then
          return
        end

        local task = string.sub(selected[1], 1, 30)
        local task_name = task:match '(.+)%s*$'
        local details = task_data[selected[1]]
        local cwd = vim.env.MISE_PROJECT_ROOT or vim.fn.getcwd()

        run_task(task_name, details, function(name, args)
          vim.fn.jobstart({ 'wezterm', 'cli', 'spawn', '--cwd', cwd, '--', 'zsh', '-lc', 'mise run ' .. name .. args .. '; exec zsh -l' }, { detach = true })
        end)
      end,
    },
  })
end, { desc = 'Mise task picker' })

vim.keymap.set('n', '<leader>M', function()
  vim.cmd 'MisePick'
end, { desc = 'Pick mise task' })
