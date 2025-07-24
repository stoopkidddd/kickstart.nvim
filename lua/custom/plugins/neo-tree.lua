return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '<leader>e', ':Neotree toggle<CR>', desc = 'NeoTree toggle', silent = true },
    { '<leader>E', ':Neotree focus<CR>', desc = 'NeoTree focus', silent = true },
  },
  opts = {
    filesystem = {
      hijack_netrw_behavior = 'open_current',
      follow_current_file = {
        enabled = true,
        leave_dirs_open = false,
      },
      window = {
        mappings = {
          ['\\'] = 'close_window',
          ['<C-t>'] = function(state)
            local node = state.tree:get_node()
            local path = node.type == 'file' and vim.fn.fnamemodify(node.path, ':h') or node.path
            vim.cmd('ToggleTerm direction=float dir=' .. vim.fn.shellescape(path))
          end,
        },
      },
    },
  },
}
