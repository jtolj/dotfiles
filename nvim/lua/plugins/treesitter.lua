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
    'arborist-ts/arborist.nvim',
    config = function()
      require('arborist').setup {
        overrides = {
          svelte = { url = 'https://github.com/jtolj/tree-sitter-svelte' },
        },
        install_popular = 'false',
        update_cadence = 'manual',
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
    end,
  },
}
