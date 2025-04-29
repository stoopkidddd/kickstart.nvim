return {
  'olimorris/codecompanion.nvim',
  opts = {
    display = {
      chat = {
        show_settings = true,
      },
      action_palette = {
        provider = 'telescope',
      },
    },
    strategies = {
      chat = {
        adapter = 'openrouter_claude',
      },
      inline = {
        adapter = 'openrouter_claude',
      },
      cmd = {
        adapter = 'openrouter claude',
      },
    },
    adapters = {
      openrouter_claude = function()
        return require('codecompanion.adapters').extend('openai_compatible', {
          env = {
            url = 'https://openrouter.ai/api',
            api_key = '',
            chat_url = '/v1/chat/completions',
          },
          schema = {
            model = {
              default = 'anthropic/claude-3.7-sonnet',
            },
          },
        })
      end,
    },
  },
  keys = {
    { '<leader>cc', '<cmd>CodeCompanionChat<cr>', desc = 'Code Companion Chat' },
    { '<leader>cA', '<cmd>CodeCompanionAction<cr>', desc = 'Code Companion Actions' },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
  },
}
