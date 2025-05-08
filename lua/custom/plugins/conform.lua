local function biome_lsp_or_prettier(bufnr)
  local has_biome_lsp = vim.lsp.get_active_clients({
    bufnr = bufnr,
    name = 'biome',
  })[1]
  if has_biome_lsp then
    return { 'biome' }
  end
  local has_prettier = vim.fs.find({
    -- https://prettier.io/docs/en/configuration.html
    '.prettierrc',
    '.prettierrc.json',
    '.prettierrc.yml',
    '.prettierrc.yaml',
    '.prettierrc.json5',
    '.prettierrc.js',
    '.prettierrc.cjs',
    '.prettierrc.toml',
    'prettier.config.js',
    'prettier.config.cjs',
  }, { upward = true })[1]
  if has_prettier then
    return { 'prettier' }
  end
  return { 'prettier' }
end

return { -- Autoformat
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>cf',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { c = true, cpp = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      else
        return {
          timeout_ms = 500,
          lsp_format = 'fallback',
        }
      end
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      ['javascript'] = biome_lsp_or_prettier,
      ['javascriptreact'] = biome_lsp_or_prettier,
      ['typescript'] = biome_lsp_or_prettier,
      ['typescriptreact'] = biome_lsp_or_prettier,
      -- ["vue"] = { "biome" },
      -- ["css"] = { "biome" },
      -- ["scss"] = { "biome" },
      -- ["less"] = { "biome" },
      -- ["html"] = { "biome" },
      -- ["json"] = { "biome" },
      -- ["jsonc"] = { "biome" },
      -- ["yaml"] = { "biome" },
      ['markdown'] = biome_lsp_or_prettier,
      ['markdown.mdx'] = biome_lsp_or_prettier,
      -- ["graphql"] = { "biome" },
      -- ["handlebars"] = { "biome" },

      -- Conform can also run multiple formatters sequentially
      -- python = { "isort", "black" },
      --
      -- You can use 'stop_after_first' to run the first available formatter from the list
      -- javascript = { "prettierd", "prettier", stop_after_first = true },
    },
  },
}
