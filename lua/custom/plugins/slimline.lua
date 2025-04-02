return {
  -- Calls `require('slimline').setup({})`
  'sschleemilch/slimline.nvim',
  opts = {
    style = 'bg',
    bold = true,
    hl = {
      secondary = 'Comment',
    },
    configs = {
      mode = {
        hl = {
          normal = 'Comment',
          insert = 'Normal',
          pending = 'Normal',
          visual = 'Normal',
          command = 'Normal',
        },
      },
      path = {
        hl = {
          primary = 'Label',
        },
      },
      git = {
        hl = {
          primary = 'Function',
        },
      },
      diagnostics = {
        hl = {
          primary = 'Statement',
        },
      },
      filetype_lsp = {
        hl = {
          primary = 'String',
        },
      },
    },
    spaces = {
      components = '',
      left = '',
      right = '',
    },
    sep = {
      hide = {
        first = true,
        last = true,
      },
      left = '',
      right = '',
    },
  },
}
