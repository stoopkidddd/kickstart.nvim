return {
  'andythigpen/nvim-coverage',
  opts = {
    commands = true,
    coverage_dir = './coverage/jest',
    coverage_file = 'coverage_final.json',
    lcov_file = './coverage/jest/lcov.info',
    auto_reload = true,
    load_coverage_cb = function(ftype)
      vim.notify('Loaded ' .. ftype .. ' coverage')
    end,
  },
}
