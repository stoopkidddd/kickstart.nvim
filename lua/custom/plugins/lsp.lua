-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go { severity = severity }
  end
end

return {
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
      },
    },
  },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', opts = {} },
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { 'j-hui/fidget.nvim', opts = {} },
    },
    keys = {
      { 'gd', vim.lsp.buf.definition, desc = 'Goto Definition' },
      { 'gr', require('telescope.builtin').lsp_references, desc = 'References' },
      { 'gI', vim.lsp.buf.implementation, desc = 'Goto Implementation' },
      { 'gy', vim.lsp.buf.type_definition, desc = 'Goto T[y]pe Definition' },
      { 'gD', vim.lsp.buf.declaration, desc = 'Goto Declaration' },
      -- {
      --   'K',
      --   function()
      --     return vim.lsp.buf.hover { border = 'rounded' }
      --   end,
      --   desc = 'Hover',
      -- },
      {
        'gK',
        function()
          return vim.lsp.buf.signature_help()
        end,
        desc = 'Signature Help',
      },
      {
        '<c-k>',
        function()
          return vim.lsp.buf.signature_help()
        end,
        mode = 'i',
        desc = 'Signature Help',
      },
      { '<leader>ca', vim.lsp.buf.code_action, desc = 'Code Action', mode = { 'n', 'v' } },
      {
        '<leader>cR',
        function()
          Snacks.rename.rename_file()
        end,
        desc = 'Rename File',
        mode = { 'n' },
      },
      { '<leader>cr', vim.lsp.buf.rename, desc = 'Rename' },
      { '<leader>cd', vim.diagnostic.open_float, { desc = 'Line Diagnostics' } },
      { ']d', diagnostic_goto(true), { desc = 'Next Diagnostic' } },
      { '[d', diagnostic_goto(false), { desc = 'Prev Diagnostic' } },
    },
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local function client_supports_method(client, method, bufnr)
            if vim.fn.has 'nvim-0.11' == 1 then
              return client:supports_method(method, bufnr)
            else
              return client.supports_method(method, { bufnr = bufnr })
            end
          end

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end
        end,
      })

      -- vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
      --   border = 'single',
      -- })
      --
      -- vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      --   border = 'single',
      -- })

      -- Diagnostic Config
      -- See :help vim.diagnostic.Opts
      vim.diagnostic.config {
        severity_sort = true,
        float = { border = 'rounded', source = 'if_many' },
        underline = { severity = vim.diagnostic.severity.ERROR },
        signs = vim.g.have_nerd_font and {
          text = {
            [vim.diagnostic.severity.ERROR] = '󰅚 ',
            [vim.diagnostic.severity.WARN] = '󰀪 ',
            [vim.diagnostic.severity.INFO] = '󰋽 ',
            [vim.diagnostic.severity.HINT] = '󰌶 ',
          },
        } or {},
        -- not sure I like the virtual lines...
        -- virtual_lines = {
        --   -- current_line = true,
        --   severity = { min = 'ERROR' },
        --   float = true,
        -- },
        virtual_text = {
          source = 'if_many',
          spacing = 2,
          -- current_line = true,
          -- severity = { min = 'INFO', max = 'WARN' },
          -- format = function(diagnostic)
          --   local diagnostic_message = {
          --     [vim.diagnostic.severity.ERROR] = diagnostic.message,
          --     [vim.diagnostic.severity.WARN] = diagnostic.message,
          --     [vim.diagnostic.severity.INFO] = diagnostic.message,
          --     [vim.diagnostic.severity.HINT] = diagnostic.message,
          --   }
          --   return diagnostic_message[diagnostic.severity]
          -- end,
        },
      }

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local servers = {
        -- clangd = {},
        -- gopls = {},
        -- pyright = {},
        -- rust_analyzer = {},
        -- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
        --
        -- Some languages (like typescript) have entire language plugins that can be useful:
        --    https://github.com/pmizio/typescript-tools.nvim
        --
        -- But for many setups, the LSP (`ts_ls`) will work just fine
        -- ts_ls = {},
        --
        cspell = {
          filetypes = {
            'javascript',
            'javascriptreact',
            'javascript.jsx',
            'typescript',
            'typescriptreact',
            'typescript.tsx',
          },
        },

        lua_ls = {
          -- cmd = { ... },
          -- filetypes = { ... },
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
              -- diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },
        eslint = {
          on_attach = function(client, bufnr)
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
        vtsls = {
          -- explicitly add default filetypes, so that we can extend
          -- them in related extras
          filetypes = {
            'javascript',
            'javascriptreact',
            'javascript.jsx',
            'typescript',
            'typescriptreact',
            'typescript.tsx',
          },
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
          -- keys = {
          --   {
          --     'gD',
          --     function()
          --       local params = vim.lsp.util.make_position_params()
          --       LazyVim.lsp.execute {
          --         command = 'typescript.goToSourceDefinition',
          --         arguments = { params.textDocument.uri, params.position },
          --         open = true,
          --       }
          --     end,
          --     desc = 'Goto Source Definition',
          --   },
          --   {
          --     'gR',
          --     function()
          --       LazyVim.lsp.execute {
          --         command = 'typescript.findAllFileReferences',
          --         arguments = { vim.uri_from_bufnr(0) },
          --         open = true,
          --       }
          --     end,
          --     desc = 'File References',
          --   },
          --   {
          --     '<leader>co',
          --     LazyVim.lsp.action['source.organizeImports'],
          --     desc = 'Organize Imports',
          --   },
          --   {
          --     '<leader>cM',
          --     LazyVim.lsp.action['source.addMissingImports.ts'],
          --     desc = 'Add missing imports',
          --   },
          --   {
          --     '<leader>cu',
          --     LazyVim.lsp.action['source.removeUnused.ts'],
          --     desc = 'Remove unused imports',
          --   },
          --   {
          --     '<leader>cD',
          --     LazyVim.lsp.action['source.fixAll.ts'],
          --     desc = 'Fix all diagnostics',
          --   },
          --   {
          --     '<leader>cV',
          --     function()
          --       LazyVim.lsp.execute { command = 'typescript.selectTypeScriptVersion' }
          --     end,
          --     desc = 'Select TS workspace version',
          --   },
          -- },
        },
      }

      -- Ensure the servers and tools above are installed
      --
      -- To check the current status of installed tools and/or manually install
      -- other tools, you can run
      --    :Mason
      --
      -- You can press `g?` for help in this menu.
      --
      -- `mason` had to be setup earlier: to configure its options see the
      -- `dependencies` table for `nvim-lspconfig` above.
      --
      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
        automatic_installation = false,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for ts_ls)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
    end,
  },
  -- {
  --   'pmizio/typescript-tools.nvim',
  --   dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
  --   opts = {},
  -- },
  -- {
  --   'esmuellert/nvim-eslint',
  --   opts = {
  --     settings = {
  --       format = true,
  --       codeActionOnSave = {
  --         mode = 'all',
  --       },
  --       workingDirectory = function(bufnr)
  --         return { directory = vim.fs.root(bufnr, { 'package.json' }) }
  --       end,
  --     },
  --   },
  -- },
  {
    'HallerPatrick/py_lsp.nvim',
    opts = {
      default_venv_name = '.venv',
      language_server = 'pylsp',
      source_strategies = { 'poetry', 'default', 'system' },
      configurationSources = { 'flake8' },
      on_attach = function(client)
        if vim.bo.filetype == 'python' then
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end
      end,
      pylsp_plugins = {
        autopep8 = {
          enabled = false,
        },
        pycodestyle = {
          enabled = false,
        },
        pydocstyle = {
          enabled = true,
        },
        pyls_mypy = {
          enabled = true,
        },
        pyls_isort = {
          enabled = true,
        },
        pylint = {
          enabled = true,
          args = { '--disable=C0301' },
        },
        flake8 = {
          enabled = false,
          executable = '.venv/bin/flake8',
          ignore = { 'E501' },
        },
        ruff = {
          enabled = true,
          extendIgnore = { 'E501' },
        },
      },
    },
  },
}
