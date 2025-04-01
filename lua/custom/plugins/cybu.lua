return {
  'ghillb/cybu.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons', 'nvim-lua/plenary.nvim' },
  config = function()
    require('cybu').setup()
  end,
  keys = {
    {
      '<c-j>',
      function()
        vim.cmd 'CybuPrev'
      end,
      desc = 'Previous Buffer',
    },
    {
      '<c-k>',
      function()
        vim.cmd 'CybuNext'
      end,
      desc = 'Next Buffer',
    },
  },
}
