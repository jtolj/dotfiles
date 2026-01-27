vim.api.nvim_create_user_command('Mise', function(args)
  vim.cmd('!mise run ' .. args.args)
end, { desc = 'Execute mise run', nargs = '*' })
