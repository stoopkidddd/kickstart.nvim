return {
  'ghillb/cybu.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons', 'nvim-lua/plenary.nvim' },
  config = function()
    require('cybu').setup()
  end,
  keys = {
    {
      '<C-p>',
      function()
        vim.cmd 'CybuPrev'
      end,
      desc = 'Previous Buffer',
    },
    {
      '<C-S-P>',
      function()
        vim.cmd 'CybuNext'
      end,
      desc = 'Next Buffer',
    },
  },
}
