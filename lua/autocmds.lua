-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

local function augroup(name)
  return vim.api.nvim_create_augroup('custom_' .. name, { clear = true })
end

-- turn off automatic wrap for gitcommit message
vim.api.nvim_create_autocmd('FileType', {
  group = augroup 'gitcommit_format',
  pattern = { 'gitcommit' },
  callback = function()
    vim.api.nvim_buf_set_option(0, 'formatoptions', 't')
    vim.api.nvim_buf_set_option(0, 'formatoptions', 'l')
  end,
})

-- cd to git root and set up autocmd for vim start to search.
-- I should probably only do this for ~/repos/ and standardize on that for all machines
local function get_git_root()
  local dot_git_path = vim.fn.finddir('.git', '.;')
  return vim.fn.fnamemodify(dot_git_path, ':h')
end

vim.api.nvim_create_user_command('CdGitRoot', function()
  vim.api.nvim_set_current_dir(get_git_root())
end, {})

vim.api.nvim_create_autocmd('VimEnter', {
  group = augroup 'cd_to_git_root',
  callback = function()
    vim.cmd 'CdGitRoot'
  end,
})
