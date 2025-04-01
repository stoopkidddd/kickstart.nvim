return {
  'leath-dub/snipe.nvim',
  keys = {
    {
      'gb',
      function()
        require('snipe').open_buffer_menu {
          max_path_width = 3,
        }
      end,
      desc = 'Open Snipe buffer menu',
    },
  },
  opts = {
    ui = {
      position = 'center',
    },
    sort = 'last',
  },
}
