-- Icons to use in the completion menu.
local symbol_kinds = {
  Class = '',
  Color = '',
  Constant = '',
  Constructor = '',
  Copilot = '',
  Enum = '',
  EnumMember = '',
  Event = '',
  Field = '',
  File = '',
  Folder = '',
  Function = '',
  Interface = '',
  Keyword = '',
  Method = '',
  Module = '',
  Operator = '',
  Property = '',
  Reference = '',
  Snippet = '',
  Struct = '',
  Text = '',
  TypeParameter = '',
  Unit = '',
  Value = '',
  Variable = '',
}

return {
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      {
        'zbirenbaum/copilot-cmp',
        config = function()
          require('copilot_cmp').setup()
        end,
      },
      {
        'L3MON4D3/LuaSnip',
        config = function()
          local luasnip = require 'luasnip'
          local types = require 'luasnip.util.types'

          require('luasnip.loaders.from_vscode').lazy_load()

          -- HACK: Cancel the snippet session when leaving insert mode.
          vim.api.nvim_create_autocmd('ModeChanged', {
            group = vim.api.nvim_create_augroup('UnlinkSnippetOnModeChange', { clear = true }),
            pattern = { 's:n', 'i:*' },
            callback = function(event)
              if luasnip.session and luasnip.session.current_nodes[event.buf] and not luasnip.session.jump_active then
                luasnip.unlink_current()
              end
            end,
          })

          luasnip.setup {
            -- Display a cursor-like placeholder in unvisited nodes
            -- of the snippet.
            ext_opts = {
              [types.insertNode] = {
                unvisited = {
                  virt_text = { { '|', 'Conceal' } },
                  virt_text_pos = 'inline',
                },
              },
              [types.exitNode] = {
                unvisited = {
                  virt_text = { { '|', 'Conceal' } },
                  virt_text_pos = 'inline',
                },
              },
            },
          }
        end,
      },
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
      'saadparwaiz1/cmp_luasnip',
    },
    version = false,
    event = 'InsertEnter',
    config = function()
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      local lsp = require 'cmp_nvim_lsp'
      local buffer = require 'cmp_buffer'

      vim.keymap.set({ 'i', 's' }, '<c-l>', function()
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        end
      end)

      ---@diagnostic disable: missing-fields
      cmp.setup {
        -- Disable preselect. On enter, the first thing will be used if nothing
        -- is selected.
        preselect = cmp.PreselectMode.None,
        -- Add icons to the completion menu.
        formatting = {
          format = function(_, vim_item)
            vim_item.kind = (symbol_kinds[vim_item.kind] or '') .. '  ' .. vim_item.kind
            return vim_item
          end,
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          -- Make the completion menu bordered.
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        view = {
          entries = {
            follow_cursor = true,
          },
          docs = { auto_open = true },
        },
        mapping = cmp.mapping.preset.insert {
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
          },
          -- Explicitly request completions.
          ['<C-Space>'] = cmp.mapping.complete(),
        },
        sources = cmp.config.sources {
          { name = 'nvim_lsp', group_index = 2 },
          { name = 'copilot', group_index = 2 },
          { name = 'buffer', group_index = 2 },
          { name = 'luasnip', group_index = 2 },
        },
      }
      ---@diagnostic enable: missing-fields
    end,
  },
}
