vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set({ 'n', 'v' }, '<C-k>', '<cmd>Treewalker Up<cr>', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<C-j>', '<cmd>Treewalker Down<cr>', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<C-h>', '<cmd>Treewalker Left<cr>', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<C-l>', '<cmd>Treewalker Right<cr>', { silent = true })

-- vim.keymap.set('n', '<C-H>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
-- vim.keymap.set('n', '<C-L>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
-- vim.keymap.set('n', '<C-J>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
-- vim.keymap.set('n', '<C-K>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set('n', '<leader>yga', function()
  require('toggleterm').exec 'yarn graphql:all'
end, { desc = 'Generate GraphQL' })

vim.keymap.set('n', '<leader>T', function()
  require('toggleterm').toggle(1)
end, { desc = 'Toggle Terminal' })

local function run_jest()
  local current_file = vim.fn.expand '%:p'
  local command = string.format('COVERAGE=true NODE_ENV=test npx jest -c=jest.config.ts --coverage --coverageDirectory=coverage/jest %s', current_file)

  require('toggleterm').exec(command)
end

vim.keymap.set('n', '<leader>tt', function()
  run_jest()
end, { desc = 'Jest Test' })

vim.keymap.set('n', '<leader>bd', ':bp<bar>bd #<CR>', { noremap = true, silent = true, desc = '[B]uffer [D]elete' })
