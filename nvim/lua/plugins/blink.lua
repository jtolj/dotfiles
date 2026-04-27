---@module "lazy"
---@type LazySpec

return {
  {
    'saghen/blink.compat',
    -- use v2.* for blink.cmp v1.*
    version = '2.*',
    -- lazy.nvim will automatically load the plugin when it's required by blink.cmp
    lazy = true,
    -- make sure to set opts so that lazy.nvim calls blink.compat's setup
    opts = {},
  },
  {
    'saghen/blink.cmp',
    dependencies = {
      ---@type LazySpec
      {
        'L3MON4D3/LuaSnip',
        dependencies = {
          'rafamadriz/friendly-snippets',
          config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
          end,
        },
      },
    },
    version = '1.*',
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = { preset = 'enter' },

      appearance = {
        nerd_font_variant = 'mono',
      },

      completion = {
        list = {
          selection = {
            preselect = false,
          },
        },
        documentation = {
          window = {
            border = 'rounded',
            winhighlight = 'Normal:CatppuccinSurface0,FloatBorder:CatppuccinSurface2,Search:None',
          },
          auto_show = true,
          auto_show_delay_ms = 1000,
        },
        menu = {
          border = 'rounded',
          winhighlight = 'Normal:CatppuccinSurface0,FloatBorder:CatppuccinSurface2,Search:None',
          draw = {
            padding = 1,
            columns = {
              { 'label', 'label_description', gap = 1 },
              { 'kind_icon', 'kind', gap = 1 },
            },
          },
        },
      },

      snippets = {
        preset = 'luasnip',
      },

      sources = {
        default = { 'lsp', 'snippets', 'path', 'buffer' },
        per_filetype = {
          php = { inherit_defaults = true, 'laravel' },
          blade = { inherit_defaults = true, 'laravel' },
        },
        providers = {
          snippets = {
            score_offset = -20,
          },
          buffer = {
            score_offset = -30,
          },
          lsp = {
            score_offset = 10,
          },
          path = {
            opts = {
              get_cwd = function(_)
                return vim.fn.getcwd()
              end,
              ignore_root_slash = true,
            },
          },
          laravel = {
            name = 'laravel',
            module = 'blink.compat.source',
            score_offset = 9,
            transform_items = function(ctx, items)
              for _, item in ipairs(items) do
                item.kind_icon = ''
                item.kind_name = 'Laravel'
              end
              return items
            end,
          },
        },
      },
      fuzzy = { implementation = 'prefer_rust_with_warning' },
    },
    opts_extend = { 'sources.default' },
  },
}
