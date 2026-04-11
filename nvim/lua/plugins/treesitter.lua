---@module "lazy"
---@type LazySpec

return {
  {
    'nvim-treesitter/nvim-treesitter-context',
    opts = {
      enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
      multiwindow = false, -- Enable multiwindow support.
      max_lines = 256, -- How many lines the window should span. Values <= 0 mean no limit.
      min_window_height = 60, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
      line_numbers = true,
      multiline_threshold = 20, -- Maximum number of lines to show for a single context
      trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
      mode = 'cursor', -- Line used to calculate context. Choices: 'cursor', 'topline'
      -- Separator between context and content. Should be a single character string, like '-'.
      -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
      separator = nil,
      zindex = 20, -- The Z-index of the context window
      on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
    },
  },
  {
    'reybits/ts-forge.nvim',
    config = function()
      local ts = require 'ts-forge'
      ts.parsers.svelte = {
        url = 'https://github.com/jtolj/tree-sitter-svelte',
        rev = 'v1.0.3',
      }
      ts.parsers.blade = {
        url = 'https://github.com/EmranMR/tree-sitter-blade',
        rev = 'cc764dadcbbceb3f259396fef66f970c72e94f96',
      }
      ts.parsers.caddy = {
        url = 'https://github.com/opa-oz/tree-sitter-caddy',
        rev = '9b3fde99d3d74345b85b655a6d8065e004fbe26f',
      }
      ts.parsers.comment = {
        url = 'https://github.com/stsewd/tree-sitter-comment',
        rev = '66272d2b6c73fb61157541b69dd0a7ce7b42a5ad',
      }
      ts.parsers.diff = {
        url = 'https://github.com/tree-sitter-grammars/tree-sitter-diff',
        rev = '2520c3f934b3179bb540d23e0ef45f75304b5fed',
      }
      ts.parsers.git_config = {
        url = 'https://github.com/the-mikedavis/tree-sitter-git-config',
        rev = '0fbc9f99d5a28865f9de8427fb0672d66f9d83a5',
      }
      ts.parsers.git_rebase = {
        url = 'https://github.com/the-mikedavis/tree-sitter-git-rebase',
        rev = '760ba8e34e7a68294ffb9c495e1388e030366188',
      }
      ts.parsers.gitcommit = {
        url = 'https://github.com/gbprod/tree-sitter-gitcommit',
        rev = '33fe8548abcc6e374feaac5724b5a2364bf23090',
      }
      ts.parsers.go = {
        url = 'https://github.com/tree-sitter/tree-sitter-go',
        rev = '2346a3ab1bb3857b48b29d779a1ef9799a248cd7',
      }
      ts.parsers.kotlin = {
        url = 'https://github.com/fwcd/tree-sitter-kotlin',
        rev = '93bfeee1555d2b1442d68c44b0afde2a3b069e46',
      }
      ts.parsers.luadoc = {
        url = 'https://github.com/tree-sitter-grammars/tree-sitter-luadoc',
        rev = '873612aadd3f684dd4e631bdf42ea8990c57634e',
      }
      ts.parsers.php = {
        url = 'https://github.com/tree-sitter/tree-sitter-php',
        rev = '3f2465c217d0a966d41e584b42d75522f2a3149e',
        location = 'php',
      }
      ts.parsers.ruby = {
        url = 'https://github.com/tree-sitter/tree-sitter-ruby',
        rev = 'ad907a69da0c8a4f7a943a7fe012712208da6dee',
      }
      ts.parsers.rust = {
        url = 'https://github.com/tree-sitter/tree-sitter-rust',
        rev = '77a3747266f4d621d0757825e6b11edcbf991ca5',
      }
      ts.parsers.scss = {
        url = 'https://github.com/serenadeai/tree-sitter-scss',
        rev = 'c478c6868648eff49eb04a4df90d703dc45b312a',
      }
      ts.parsers.toml = {
        url = 'https://github.com/tree-sitter-grammars/tree-sitter-toml',
        rev = '64b56832c2cffe41758f28e05c756a3a98d16f41',
      }
      ts.parsers.typst = {
        url = 'https://github.com/uben0/tree-sitter-typst',
        rev = '46cf4ded12ee974a70bf8457263b67ad7ee0379d',
      }
      ts.parsers.vue = {
        url = 'https://github.com/tree-sitter-grammars/tree-sitter-vue',
        rev = 'ce8011a414fdf8091f4e4071752efc376f4afb08',
      }
      ts.parsers.xml = {
        url = 'https://github.com/tree-sitter-grammars/tree-sitter-xml',
        rev = '4b64dd3a03ec002258d6268d712fd93716d6ab57',
        location = 'xml',
      }

      ts.setup {
        auto_install = true,
        ensure_installed = {
          'bash',
          'blade',
          'caddy',
          'comment',
          'cpp',
          'cmake',
          'css',
          'diff',
          'git_config',
          'git_rebase',
          'gitcommit',
          'gitignore',
          'go',
          'html',
          'java',
          'javascript',
          'json',
          'kotlin',
          'lua',
          'luadoc',
          'make',
          'markdown',
          'markdown_inline',
          'python',
          'php',
          'ruby',
          'query',
          'regex',
          'rust',
          'scss',
          'svelte',
          'toml',
          'tsx',
          'typescript',
          'typst',
          'vim',
          'vimdoc',
          'vue',
          'yaml',
          'xml',
        },
      }
      local group = vim.api.nvim_create_augroup('TreesitterSetup', { clear = true })
      -- Enable highlighting on FileType
      vim.api.nvim_create_autocmd('FileType', {
        group = group,
        desc = 'Enable treesitter highlighting and indentation',
        callback = function(event)
          local lang = vim.treesitter.language.get_lang(event.match)
          if not lang then
            return
          end

          local buf = event.buf
          -- Start highlighting immediately (works if parser exists)
          pcall(vim.treesitter.start, buf, lang)

          -- Enable folding
          vim.wo[0][0].foldmethod = 'expr'
          vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'

          -- Enable indentation
          -- TODO: extract this fn from nvim-treesitte?
          -- vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })
    end,
  },
}
