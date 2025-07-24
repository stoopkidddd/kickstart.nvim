return {
  'greggh/claude-code.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim', -- Required for git operations
  },
  config = function()
    require('claude-code').setup {
      window = {
        position = 'vertical',
        split_ratio = 0.5,
      },
      keymaps = {
        toggle = {
          normal = '<leader>cC', -- Normal mode keymap for toggling Claude Code, false to disable
          terminal = '<leader>cC', -- Terminal mode keymap for toggling Claude Code, false to disable
          variants = {
            continue = false, -- Normal mode keymap for Claude Code with continue flag
            verbose = false, -- Normal mode keymap for Claude Code with verbose flag
          },
        },
        window_navigation = true, -- Enable window navigation keymaps (<C-h/j/k/l>)
        scrolling = true, -- Enable scrolling keymaps (<C-f/b>) for page up/down
      },
    }
  end,
}
