vim.pack.add { 'https://github.com/nvim-lualine/lualine.nvim' }

local c = {
  background = '#1C1E26',
  backgroundAlt = '#191A21',
  selection = '#2F3341',
  backgroundLight = '#242631',
  backgroundInlay = '#262A3B',
  attention = '#B4F9F8',
  attentionBackground = '#2D3247',
  floatBorder = '#4A4C5F',
  comment = '#7E8EDA',
  gutter = '#505868',
  white = '#D5D8DA',
  whiteDark = '#999FAC',
  silver = '#84A1BC',
  yellow = '#FFD88C',
  purple = '#BAACFF',
  purpleDark = '#B877DB',
  pink = '#EBBBF7',
  orange = '#FAB795',
  darkOrange = '#FF9668',
  lightBlue = '#B6C4F2',
  blue = '#70B0FF',
  cyan = '#7FDAFF',
  green = '#64D1A9',
  red = '#FF5370',
  warning = '#EFC490',
  info = '#9AC9E3',
  hint = '#A4D6C2',
}

require('lualine').setup {
  options = {
    theme = {
      normal = {
        a = { fg = c.background, bg = c.comment, gui = 'bold' },
        b = { fg = c.white, bg = c.backgroundLight },
        c = { fg = c.gutter, bg = c.background },
      },
      insert = {
        a = { fg = c.background, bg = c.green, gui = 'bold' },
        b = { fg = c.white, bg = c.backgroundLight },
      },
      visual = {
        a = { fg = c.background, bg = c.yellow, gui = 'bold' },
        b = { fg = c.white, bg = c.backgroundLight },
      },
      replace = {
        a = { fg = c.background, bg = c.red, gui = 'bold' },
        b = { fg = c.white, bg = c.backgroundLight },
      },
      inactive = {
        a = { fg = c.whiteDark, bg = c.backgroundLight, gui = 'bold' },
        b = { fg = c.white, bg = c.backgroundLight },
        c = { fg = c.white, bg = c.background },
      },
    },
  },
  sections = {
    lualine_a = { 'mode', 'filename' },
    lualine_b = { 'branch', 'diff', 'diagnostics' },
    lualine_c = {},
    lualine_x = { { 'encoding', show_bomb = true }, 'filetype' },
    lualine_y = {
      {
        'lsp_status',
        icon = '',
        symbols = {
          -- Standard unicode symbols to cycle through for LSP progress:
          spinner = { '*' },
          -- Standard unicode symbol for when LSP is done:
          done = '✓',
          -- Delimiter inserted between LSP names:
          separator = '',
        },
        ignore_lsp = {},
        show_name = false,
      },
      'diagnostics',
    },
    lualine_z = { 'location' },
  },
}
