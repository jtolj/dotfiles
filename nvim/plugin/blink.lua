vim.pack.add {
  'https://github.com/L3MON4D3/LuaSnip',
  'https://github.com/rafamadriz/friendly-snippets',
  'https://github.com/mikavilpas/blink-ripgrep.nvim',
  { src = 'https://github.com/saghen/blink.compat', version = vim.version.range '2.*' },
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range '1.*' },
}

require('luasnip.loaders.from_vscode').lazy_load()

require('blink.cmp').setup {
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
    default = { 'lsp', 'snippets', 'path', 'buffer', 'ripgrep' },
    per_filetype = {
      php = { inherit_defaults = true, 'laravel' },
      blade = { inherit_defaults = true, 'laravel' },
    },
    providers = {
      ripgrep = {
        module = 'blink-ripgrep',
        name = 'Ripgrep',
        opts = {
          backend = {
            use = 'gitgrep-or-ripgrep',
          },
        },
        score_offset = -100,
        transform_items = function(ctx, items)
          for _, item in ipairs(items) do
            item.kind_icon = ''
            item.kind_name = 'Ripgrep'
          end
          return items
        end,
      },
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
}
