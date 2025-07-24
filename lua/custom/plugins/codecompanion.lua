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
        adapter = 'copilot',
      },
      inline = {
        adapter = 'copilot',
      },
      cmd = {
        adapter = 'copilot',
      },
    },
    adapters = {
      copilot = function()
        return require('codecompanion.adapters').extend('copilot', {
          schema = {
            model = {
              default = 'claude-opus-4',
            },
            max_tokens = {
              default = 64000,
            },
          },
        })
      end,
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
      mcphub = {
        callback = 'mcphub.extensions.codecompanion',
        opts = {
          show_result_in_chat = true, -- Show mcp tool results in chat
          make_vars = true, -- Convert resources to #variables
          make_slash_commands = true, -- Add prompts as /slash commands
        },
      },
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
    'ravitemer/codecompanion-history.nvim',
  },
}
