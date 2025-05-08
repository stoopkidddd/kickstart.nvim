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
    extensions = {
      history = {
        enabled = true,
        opts = {
          -- Keymap to open history from chat buffer (default: gh)
          keymap = 'gh',
          -- Automatically generate titles for new chats
          auto_generate_title = true,
          ---On exiting and entering neovim, loads the last chat on opening chat
          continue_last_chat = false,
          ---When chat is cleared with `gx` delete the chat from history
          delete_on_clearing_chat = false,
          -- Picker interface ("telescope" or "default")
          picker = 'telescope',
          ---Enable detailed logging for history extension
          enable_logging = false,
          ---Directory path to save the chats
          dir_to_save = vim.fn.stdpath 'data' .. '/codecompanion-history',
        },
      },
      vectorcode = {
        opts = {
          add_tool = true,
          add_slash_command = true,
        },
      },
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
