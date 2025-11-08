-- Copilot.
return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {
      panel = { enabled = false },
      suggestion = { enabled = false },
      server_opts_overrides = {
        settings = {
          telemetry = {
            telemetryLevel = 'off',
          },
        },
      },
      filetypes = { markdown = true },
    },
    config = function(_, opts)
      require('copilot').setup(opts)

      local function set_trigger(trigger)
        vim.b.copilot_suggestion_auto_trigger = trigger
        vim.b.copilot_suggestion_hidden = not trigger
      end
    end,
  },
  {
    'olimorris/codecompanion.nvim',
    opts = {
      adapters = {
        http = {
          anthropic = function()
            return require('codecompanion.adapters').extend('anthropic', {
              env = {
                api_key = 'ANTHROPIC_API_KEY',
              },
            })
          end,
          copilot = function()
            return require('codecompanion.adapters').extend('copilot', {
              schema = {
                context_window = {
                  default = 200000,
                },
              },
            })
          end,
        },
      },
      prompt_library = {
        ['Grammar Check'] = {
          strategy = 'chat',
          description = 'Make suggestions for grammar, spelling, and tone',
          opts = {
            auto_submit = true,
          },
          prompts = {
            {
              role = 'system',
              content = 'You are a world class proofreader',
            },
            {
              role = 'user',
              content = '#{buffer}\nCan you check this copy for spelling and grammar errors? Please also check for consistent tone. Be sure to reference specific line numbers, and give a summary of each change after providing the old and new lines.',
            },
          },
        },
      },
      actions = {
        menu = {
          'explain_code',
          'generate_tests',
          'improve_code',
          'find_bugs',
          'document_code',
          'ask_about_code',
        },
      },
    },
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    keys = {
      {
        '<leader>aa',
        function()
          vim.cmd 'CodeCompanionActions'
        end,
        desc = 'Open Code Companion Actions menu',
      },
      {
        '<leader>ac',
        function()
          vim.cmd 'CodeCompanionChat Toggle'
        end,
        desc = 'Open chat',
      },
      {
        '<leader>at',
        mode = { 'v' },
        function()
          vim.cmd "'<,'>CodeCompanion /tests"
        end,
        desc = 'Create tests for selected text',
      },
    },
  },
}
