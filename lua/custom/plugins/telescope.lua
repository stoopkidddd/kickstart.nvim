local function is_relevant_ts_file(filename)
  if filename:match '%.ts$' or filename:match '%.tsx$' then
    if not (filename:match '%.stories%.tsx$' or filename:match '%.test%.ts$' or filename:match '%.test%.tsx$') then
      return true
    end
  end
  return false
end

vim.keymap.set('n', 'gR', function()
  vim.lsp.buf_request(0, 'textDocument/references', vim.lsp.util.make_position_params(), function(err, result, ctx, _)
    if err or not result then
      return
    end
    -- Filter references by filetype (e.g., only show Lua files)
    local filtered = vim.tbl_filter(function(ref)
      local uri = ref.uri or ref.targetUri
      local fname = vim.uri_to_fname(uri)
      return is_relevant_ts_file(fname)
    end, result)
    -- Use Telescope to display filtered results
    require('telescope.pickers')
      .new({}, {
        prompt_title = 'LSP References (excludes tests/stories)',
        finder = require('telescope.finders').new_table {
          results = filtered,
          entry_maker = function(entry)
            local uri = entry.uri or entry.targetUri
            local fname = vim.uri_to_fname(uri)
            return {
              value = entry,
              display = fname,
              ordinal = fname,
              filename = fname,
              lnum = entry.range.start.line + 1,
              col = entry.range.start.character + 1,
            }
          end,
        },
        previewer = require('telescope.previewers').vim_buffer_cat.new {},
        sorter = require('telescope.config').values.generic_sorter {},
      })
      :find()
  end)
end, { desc = 'Telescope LSP references (Lua files only)' })

return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',

      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },

    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    {
      'isak102/telescope-git-file-history.nvim',
      dependencies = {
        'nvim-lua/plenary.nvim',
        'tpope/vim-fugitive',
      },
    },
  },
  config = function()
    require('telescope').setup {
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')
    pcall(require('telescope').load_extension, 'git_file_history')

    -- See `:help telescope.builtin`
    local builtin = require 'telescope.builtin'
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    vim.keymap.set('n', '<leader>fk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    vim.keymap.set('n', '<leader><space>', function()
      require('telescope').extensions.smart_open.smart_open {
        cwd_only = true,
      }
    end, { desc = 'Find Files', noremap = true, silent = true })
    vim.keymap.set('n', '<leader>gc', function()
      require('telescope').extensions.git_file_history.git_file_history()
    end, { desc = '[G]it [C]ommit History Current Buffer', noremap = true, silent = true })

    -- vim.keymap.set('n', '<leader><leader>', builtin.find_files, { desc = '[S]earch [F]iles' })
    vim.keymap.set('n', '<leader>/', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    vim.keymap.set('n', '<leader>gs', builtin.git_status, { desc = '[Git] [S]tatus' })
    vim.keymap.set('n', '<leader>bb', builtin.buffers, { desc = '[ ] Find existing buffers' })

    -- Shortcut for searching your Neovim configuration files
    vim.keymap.set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })
  end,
}
