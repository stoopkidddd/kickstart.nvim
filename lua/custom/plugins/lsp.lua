return {
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and formatters to PATH
      {
        'williamboman/mason.nvim',
        config = function()
          require('mason').setup()
        end,
      },
      'neovim/nvim-lspconfig',
      { 'j-hui/fidget.nvim', opts = {} },
      { 'folke/lazydev.nvim', ft = 'lua', opts = { library = { { path = '${3rd}/luv/library', words = { 'vim%.uv' } } } } },
    },
    config = function()
      -- Global Keymaps
      vim.keymap.set('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })
      -- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next Diagnostic' })
      -- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Prev Diagnostic' })

      -- This function gets run when an LSP attaches to a buffer.
      -- We use it to set buffer-local keymaps and settings.
      local on_attach = function(client, bufnr)
        local nmap = function(keys, func, desc)
          if desc then
            desc = 'LSP: ' .. desc
          end
          vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
        end

        nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
        nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
        nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
        nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
        nmap('gy', vim.lsp.buf.type_definition, 'Type [D]efinition')
        nmap('<leader>cr', vim.lsp.buf.rename, '[R]ename')
        nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
        nmap('K', vim.lsp.buf.hover, 'Hover Documentation')

        -- Signature Help
        nmap('gK', vim.lsp.buf.signature_help, 'Signature Documentation')
        vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, { buffer = bufnr, desc = 'LSP: Signature Help' })

        -- Highlight references under cursor
        if client.supports_method 'textDocument/documentHighlight' then
          local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = bufnr,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = bufnr,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })
        end
      end

      -- Diagnostic configuration
      vim.diagnostic.config {
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = 'rounded',
          source = 'if_many',
        },
      }

      -- Get capabilities from blink.cmp (or other completion plugin)
      -- This is not strictly required by blink.cmp but is good practice
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      -- local cmp_capabilities = require('cmp_nvim_lsp').default_capabilities()
      -- capabilities = vim.tbl_deep_extend('force', capabilities, cmp_capabilities)

      -- The list of servers to install and setup
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              completion = { callSnippet = 'Replace' },
              diagnostics = { globals = { 'vim' } },
            },
          },
        },
        vtsls = {
          filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
          settings = {
            complete_function_calls = false,
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                maxInlayHintLength = 30,
                completion = {
                  enableServerSideFuzzyMatch = true,
                },
              },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = 'always' },
              suggest = {
                completeFunctionCalls = false,
              },
              inlayHints = {
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = 'literals' },
                parameterTypes = { enabled = true },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
            },
          },
        },
        eslint = {
          on_attach = function(client, bufnr)
            -- First call the global on_attach to set up keymaps
            on_attach(client, bufnr)

            -- Then add eslint-specific functionality
            vim.api.nvim_create_autocmd('BufWritePre', {
              buffer = bufnr,
              command = 'EslintFixAll',
            })
          end,
          workingDirectory = function(bufnr)
            -- First find the git root directory
            local git_dir = vim.fs.find('.git', {
              upward = true,
              path = vim.api.nvim_buf_get_name(bufnr),
              type = 'directory',
            })[1]

            print('git_dir', git_dir)

            if git_dir then
              -- Get the git root (parent directory of .git)
              local git_root = vim.fn.fnamemodify(git_dir, ':h')

              -- Find the first package.json starting from git root, searching downward
              local package_json = vim.fs.find('package.json', {
                upward = false,
                path = git_root,
                type = 'file',
                limit = 1, -- Stop after finding the first one
              })[1]

              if package_json then
                return { directory = vim.fn.fnamemodify(package_json, ':h') }
              end
            end

            -- Fallback to the original behavior if no Git root or package.json is found
            return { directory = vim.fs.root(bufnr, { 'package.json' }) }
          end,
        },
        cspell = {},
        gopls = {},
      }

      -- Get the list of servers to ensure are installed from the servers table
      -- local ensure_installed = vim.tbl_keys(servers)
      -- require('mason-lspconfig').setup {
      --   ensure_installed = ensure_installed,
      --   automatic_installation = true,
      -- }

      -- Setup all the servers
      for server_name, config in pairs(servers) do
        -- Only set on_attach if the server doesn't have a custom one
        if not config.on_attach then
          config.on_attach = on_attach
        end
        config.capabilities = capabilities
        require('lspconfig')[server_name].setup(config)
      end
    end,
  },
}
